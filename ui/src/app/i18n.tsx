import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';
import {
  Language,
  TranslationsResponse,
  fetchTranslationsBundle,
  upsertTranslation
} from './api';

type I18nContextValue = {
  language: string;
  defaultLanguage: string;
  languages: Language[];
  loading: boolean;
  translations: TranslationsResponse['translations'];
  t: (key: string, params?: Record<string, string | number>) => string;
  setLanguage: (code: string) => void;
  refresh: () => Promise<void>;
  registerTranslation: (key: string, values: Record<string, string>) => Promise<void>;
};

const STORAGE_KEY = 'crm_language';

const I18nContext = createContext<I18nContextValue | undefined>(undefined);

function format(template: string, params?: Record<string, string | number>): string {
  if (!params) return template;
  return Object.entries(params).reduce(
    (acc, [k, v]) => acc.replace(new RegExp(`{{${k}}}`, 'g'), String(v)),
    template
  );
}

export function I18nProvider({ userLanguage, children }: { userLanguage?: string | null; children: ReactNode }) {
  const [language, setLanguageState] = useState<string>(localStorage.getItem(STORAGE_KEY) || userLanguage || 'en');
  const [defaultLanguage, setDefaultLanguage] = useState<string>('en');
  const [languages, setLanguages] = useState<Language[]>([]);
  const [translations, setTranslations] = useState<TranslationsResponse['translations']>({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    refresh();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (!userLanguage) return;
    setLanguage(userLanguage);
  }, [userLanguage]);

  const setLanguage = (code: string) => {
    setLanguageState(code);
    localStorage.setItem(STORAGE_KEY, code);
  };

  const refresh = async () => {
    setLoading(true);
    try {
      const data = await fetchTranslationsBundle();
      setLanguages(data.languages);
      setDefaultLanguage(data.defaultLanguage || 'en');
      setTranslations(data.translations);

      const isAllowed = data.languages.find((l) => l.code === language && l.is_active);
      if (!isAllowed) {
        const fallback = userLanguage && data.languages.find((l) => l.code === userLanguage && l.is_active)
          ? userLanguage
          : data.defaultLanguage || 'en';
        setLanguage(fallback);
      }
    } catch (err) {
      // eslint-disable-next-line no-console
      console.error('Failed to load translations', err);
    } finally {
      setLoading(false);
    }
  };

  const translate = (key: string, params?: Record<string, string | number>): string => {
    const preferred = translations[language]?.[key];
    const fallback = translations[defaultLanguage]?.[key];
    const value = preferred ?? fallback;
    if (!value) {
      return import.meta.env.DEV ? `[missing: ${key}]` : key;
    }
    return format(value, params);
  };

  const registerTranslation = async (key: string, values: Record<string, string>) => {
    await upsertTranslation({ key, translations: values });
    await refresh();
  };

  const contextValue: I18nContextValue = useMemo(
    () => ({
      language,
      defaultLanguage,
      languages,
      loading,
      translations,
      t: translate,
      setLanguage,
      refresh,
      registerTranslation
    }),
    [language, defaultLanguage, languages, loading, translations]
  );

  return <I18nContext.Provider value={contextValue}>{children}</I18nContext.Provider>;
}

export function useI18n(): I18nContextValue {
  const ctx = useContext(I18nContext);
  if (!ctx) {
    throw new Error('I18nContext not available');
  }
  return ctx;
}
