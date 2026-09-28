/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL?: string;
  readonly VITE_GA4_MEASUREMENT_ID?: string;
  readonly VITE_META_PIXEL_ID?: string;
  readonly VITE_TURNSTILE_SITE_KEY?: string;
  readonly VITE_SENTRY_DSN?: string;
  readonly VITE_SUPABASE_URL?: string;
  readonly VITE_SUPABASE_ANON_KEY?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
