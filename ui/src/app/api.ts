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

export type CoreSettings = {
  system: {
    systemName: string;
    defaultLanguage: string;
    timezone: string;
    developerMode: boolean;
  };
  security: {
    enableLocalPasswords: boolean;
    enableSSO: boolean;
    jwtTtl: number;
    allowMultipleSessions: boolean;
  };
};

export type RolePermission = {
  code: string;
  scope: string;
};

export type UserSummary = {
  id: number | string;
  email: string;
  login?: string | null;
  first_name?: string | null;
  last_name?: string | null;
  company_name?: string | null;
  display_name?: string | null;
  lang?: string | null;
  is_active?: boolean;
  roles?: string[];
  groups?: string[];
  departments?: { id: string; name?: string; name_key?: string; code?: string }[];
};

export type UserDetail = UserSummary & {
  permissions?: string[];
};

export type Department = {
  id: string;
  code: string;
  name?: string;
  name_key?: string;
  parent_id?: string | null;
  manager_user_id?: string | null;
  manager?: { id: string; email?: string; first_name?: string; last_name?: string };
  users?: { id: string; email?: string }[];
};

export type AuditLog = {
  id: string;
  event?: string;
  event_type?: string;
  user?: string;
  actor?: { id?: string; email?: string };
  entity?: string;
  entity_type?: string;
  entity_id?: string | null;
  payload?: Record<string, unknown> | null;
  created_at: string;
};

export type SystemLog = {
  id: string;
  queue: string;
  payload?: Record<string, unknown> | null;
  created_at: string;
};

export type Role = {
  id: string;
  code: string;
  name_key: string;
  permissions: RolePermission[];
};

export type Permission = {
  id: string;
  code: string;
  description: string | null;
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

export async function upsertTranslation(payload: { key: string; translations: Record<string, string> }): Promise<void> {
  await apiFetch('/core/v1/i18n/translations', {
    method: 'PUT',
    body: JSON.stringify(payload)
  });
}

export async function fetchSettings(): Promise<CoreSettings> {
  return apiFetch<CoreSettings>('/core/v1/settings');
}

export async function updateSettings(payload: Partial<CoreSettings>): Promise<void> {
  await apiFetch('/core/v1/settings', {
    method: 'PUT',
    body: JSON.stringify(payload)
  });
}

export async function fetchRoles(): Promise<Role[]> {
  const { roles } = await apiFetch<{ roles: Role[] }>('/core/v1/roles');
  return roles;
}

export async function fetchPermissions(): Promise<Permission[]> {
  const { permissions } = await apiFetch<{ permissions: Permission[] }>('/core/v1/permissions');
  return permissions;
}

export async function fetchUsers(): Promise<UserSummary[]> {
  const { users } = await apiFetch<{ users: UserSummary[] }>('/core/v1/users');
  return users;
}

export async function fetchUser(id: string): Promise<UserDetail> {
  const { user } = await apiFetch<{ user: UserDetail }>(`/core/v1/users/${id}`);
  return user;
}

export async function createUser(payload: {
  email: string;
  first_name?: string;
  last_name?: string;
  company_name?: string;
  lang?: string;
  roles?: string[];
  is_active?: boolean;
  password?: string;
}): Promise<UserDetail> {
  const { user } = await apiFetch<{ user: UserDetail }>('/core/v1/users', {
    method: 'POST',
    body: JSON.stringify(payload)
  });
  return user;
}

export async function updateUser(id: string, payload: Partial<UserDetail>): Promise<UserDetail> {
  const { user } = await apiFetch<{ user: UserDetail }>(`/core/v1/users/${id}`, {
    method: 'PATCH',
    body: JSON.stringify(payload)
  });
  return user;
}

export async function deleteUser(id: string): Promise<void> {
  await apiFetch(`/core/v1/users/${id}`, { method: 'DELETE' });
}

export async function fetchDepartments(): Promise<Department[]> {
  const { departments } = await apiFetch<{ departments: Department[] }>('/core/v1/departments');
  return departments;
}

export async function createDepartment(payload: {
  code: string;
  name?: string;
  name_key?: string;
  parent_id?: string | null;
  manager_user_id?: string | null;
}): Promise<Department> {
  const { department } = await apiFetch<{ department: Department }>('/core/v1/departments', {
    method: 'POST',
    body: JSON.stringify(payload)
  });
  return department;
}

export async function updateDepartment(
  id: string,
  payload: Partial<Department>
): Promise<Department> {
  const { department } = await apiFetch<{ department: Department }>(`/core/v1/departments/${id}`, {
    method: 'PATCH',
    body: JSON.stringify(payload)
  });
  return department;
}

export async function fetchAuditLogs(params: {
  from?: string;
  to?: string;
  event?: string;
  q?: string;
  limit?: number;
  page?: number;
}): Promise<{ logs: AuditLog[]; total?: number }> {
  const query = new URLSearchParams();
  if (params.from) query.set('from', params.from);
  if (params.to) query.set('to', params.to);
  if (params.event) query.set('event', params.event);
  if (params.q) query.set('q', params.q);
  if (params.limit) query.set('limit', String(params.limit));
  if (params.page) query.set('page', String(params.page));

  const data = await apiFetch<{
    logs?: AuditLog[];
    audit?: AuditLog[];
    items?: AuditLog[];
    total?: number;
    pagination?: { total?: number };
  }>(`/core/v1/audit?${query.toString()}`);

  const logs = data.logs || data.audit || data.items || [];
  const total = data.total ?? data.pagination?.total;
  return { logs, total };
}

export async function fetchSystemLogs(params: {
  from?: string;
  to?: string;
  queue?: string;
  q?: string;
  limit?: number;
  page?: number;
}): Promise<{ logs: SystemLog[]; total?: number }> {
  const query = new URLSearchParams();
  if (params.from) query.set('from', params.from);
  if (params.to) query.set('to', params.to);
  if (params.queue) query.set('queue', params.queue);
  if (params.q) query.set('q', params.q);
  if (params.limit) query.set('limit', String(params.limit));
  if (params.page) query.set('page', String(params.page));

  const data = await apiFetch<{
    logs?: SystemLog[];
    items?: SystemLog[];
    total?: number;
    pagination?: { total?: number };
  }>(`/core/v1/logs/system?${query.toString()}`);

  const logs = data.logs || data.items || [];
  const total = data.total ?? data.pagination?.total;
  return { logs, total };
}
