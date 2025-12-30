export type User = {
  id: number | string;
  email: string;
  lang?: string;
  roles: string[];
  permissions: string[];
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

const API_PREFIX = '/api';
const AUTH_STORAGE_KEY = 'crm_token';

type RequestOptions = RequestInit & {
  skipAuth?: boolean;
};

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

async function apiFetch<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const headers = new Headers(options.headers || {});
  if (!options.skipAuth) {
    const token = tokenStore.get();
    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }
  }

  if (options.body && !headers.has('Content-Type') && !(options.body instanceof FormData)) {
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
  const payload = isJson ? await response.json().catch(() => null) : await response.text();

  if (!response.ok) {
    const message =
      typeof payload === 'string'
        ? payload || 'Request failed'
        : payload?.error || payload?.message || 'Request failed';
    throw new Error(message);
  }

  return (payload ?? {}) as T;
}

export async function login(email: string, password: string) {
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
    roles: data.roles.map((role) => role.code),
    permissions: data.permissions
  };
}
