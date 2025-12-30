export type User = {
  email: string;
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

  if (!response.ok) {
    const message = await response.text();
    throw new Error(message || 'Request failed');
  }

  if (response.status === 204) {
    return {} as T;
  }

  return response.json() as Promise<T>;
}

export async function login(email: string, password: string) {
  const data = await apiFetch<{ token: string }>('/v1/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
    skipAuth: true
  });
  tokenStore.set(data.token);
  return data.token;
}

export async function fetchCurrentUser(): Promise<User> {
  return apiFetch<User>('/v1/auth/me');
}
