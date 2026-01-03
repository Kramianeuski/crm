/* ===============================
   Types
   =============================== */

export type User = {
  id: number | string;
  email: string;
  lang?: string;
  roles: string[];
  permissions: string[];
};

export type Language = {
  code: string;
  name: string;
  is_active: boolean;
  is_default: boolean;
};

export type TranslationsResponse = {
  languages: Language[];
  defaultLanguage: string;
  translations: Record<string, Record<string, string>>;
};

type MeResponse = {
  user: {
    id: number | string;
    email: string;
    lang?: string;
  };
  roles: { code: string; name?: string }[];
  permissions: string[];
  lang?: string;
};

/* ===============================
   Constants
   =============================== */

const API_PREFIX = '/api';
const AUTH_STORAGE_KEY = 'crm_token';

type RequestOptions = RequestInit & {
  skipAuth?: boolean;
};

/* ===============================
   Token storage
   =============================== */

export const tokenStore = {
  get(): string | null {
    return localStorage.getItem(AUTH_STORAGE_KEY);
  },
  set(token: string) {
    localStorage.setItem(AUTH_STORAGE_KEY, token);
  },
  clear() {
    localStorage.removeItem(AUTH_STORAGE_KEY);
  }
};

/* ===============================
   Low-level fetch wrapper
   =============================== */

async function apiFetch<T>(
  path: string,
  options: RequestOptions = {}
): Promise<T> {
  const headers = new Headers(options.headers || {});

  if (!options.skipAuth) {
    const token = tokenStore.get();
    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }
  }

  if (
    options.body &&
    !headers.has('Content-Type') &&
    !(options.body instanceof FormData)
  ) {
    headers.set('Content-Type', 'application/json');
  }

  const response = await fetch(`${API_PREFIX}${path}`, {
    ...options,
    headers
  });

  if (response.status === 204) {
    return {} as T;
  }

  const contentType = response.headers.get('content-type') || '';
  const isJson = contentType.includes('application/json');

  const payload = isJson
    ? await response.json().catch(() => null)
    : await response.text();

  if (!response.ok) {
    const message =
      typeof payload === 'string'
        ? payload || 'Request failed'
        : payload?.error || payload?.message || 'Request failed';
    const error = new Error(message);
    // @ts-expect-error - propagate backend error key for i18n
    error.code = typeof payload === 'object' && payload ? payload.error || null : null;
    throw error;
  }

  return (payload ?? {}) as T;
}

/* ===============================
   Auth API
   =============================== */

export async function login(
  email: string,
  password: string
): Promise<string> {
  const data = await apiFetch<{ token: string }>('/core/v1/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
    skipAuth: true
  });

  tokenStore.set(data.token);
  return data.token;
}

export async function fetchCurrentUser(): Promise<User> {
  const data = await apiFetch<MeResponse>('/core/v1/auth/me');

  return {
    id: data.user.id,
    email: data.user.email,
    lang: data.lang || data.user.lang,
    roles: data.roles.map((r) => r.code),
    permissions: data.permissions
  };
}

/* ===============================
   I18n API
   =============================== */

export async function fetchTranslationsBundle(): Promise<TranslationsResponse> {
  return apiFetch<TranslationsResponse>('/core/v1/i18n/translations');
}

export async function createLanguage(payload: {
  code: string;
  name: string;
  is_active?: boolean;
  is_default?: boolean;
}): Promise<Language> {
  const { language } = await apiFetch<{ language: Language }>('/core/v1/i18n/languages', {
    method: 'POST',
    body: JSON.stringify(payload)
  });
  return language;
}

export async function updateLanguage(code: string, payload: Partial<Language>): Promise<Language> {
  const { language } = await apiFetch<{ language: Language }>(`/core/v1/i18n/languages/${code}`, {
    method: 'PATCH',
    body: JSON.stringify(payload)
  });
  return language;
}

export async function registerKey(key: string, description?: string): Promise<void> {
  await apiFetch('/core/v1/i18n/keys', {
    method: 'POST',
    body: JSON.stringify({ key, description })
  });
}

export async function upsertTranslation(payload: { key: string; translations: Record<string, string> }): Promise<void> {
  await apiFetch('/core/v1/i18n/translations', {
    method: 'POST',
    body: JSON.stringify(payload)
  });
}
