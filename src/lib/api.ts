import {
  DEFAULT_SERVICES,
  DEFAULT_PACKAGES,
  DEFAULT_SETTINGS,
} from "./fallback-data";

export const API = import.meta.env.VITE_API_URL || "";
export const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL || "";
export const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY || "";

let csrfToken = "";
let refreshing: Promise<void> | null = null;

export async function fetchFromSupabase<T>(
  table: string,
  query = "",
): Promise<T | null> {
  if (!SUPABASE_URL || !SUPABASE_KEY_VAL()) return null;
  try {
    const key = SUPABASE_KEY_VAL();
    const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}${query}`, {
      headers: {
        apikey: key,
        Authorization: `Bearer ${key}`,
      },
      signal: AbortSignal.timeout(6000),
    });
    if (!res.ok) return null;
    return (await res.json()) as T;
  } catch {
    return null;
  }
}

function SUPABASE_KEY_VAL() {
  return (
    SUPABASE_ANON_KEY ||
    "sb_publishable_iN0ntol8LK3MrmqxLNowRA_62fCRu67"
  );
}

export async function api<T = unknown>(
  path: string,
  options: { method?: string; body?: unknown } = {},
  retry = true,
): Promise<T> {
  const admin = path.startsWith("/admin");
  const method = options.method || "GET";

  if (admin && method !== "GET" && path !== "/admin/login" && !csrfToken) {
    try {
      const response = await fetch(API + "/api/admin/csrf", {
        credentials: "include",
      });
      if (response.ok) {
        csrfToken = (await response.json()).csrfToken;
      }
    } catch {}
  }

  try {
    const response = await fetch(API + "/api" + path, {
      method,
      credentials: admin ? "include" : "omit",
      headers: {
        ...(method !== "GET" ? { "Content-Type": "application/json" } : {}),
        ...(admin && csrfToken ? { "X-CSRF-Token": csrfToken } : {}),
      },
      ...(method !== "GET" ? { body: JSON.stringify(options.body || {}) } : {}),
    });

    if (
      response.status === 401 &&
      admin &&
      !["/admin/login", "/admin/refresh"].includes(path) &&
      retry
    ) {
      refreshing ||= api<{ csrfToken: string }>(
        "/admin/refresh",
        { method: "POST" },
        false,
      )
        .then((data) => {
          csrfToken = data.csrfToken;
        })
        .finally(() => {
          refreshing = null;
        });
      await refreshing;
      return api<T>(path, options, false);
    }

    if (response.ok) {
      const data = await response.json().catch(() => ({}));
      if (data.csrfToken) csrfToken = data.csrfToken;
      return data as T;
    }
  } catch {
    // If backend is not running or unreachable, fallback to Supabase for contact & newsletter
  }

  // Fallback to Supabase for contact enquiries
  if (path === "/contact" && method === "POST") {
    const body = (options.body || {}) as Record<string, unknown>;
    const key = SUPABASE_KEY_VAL();
    if (SUPABASE_URL && key) {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/Lead`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          apikey: key,
          Authorization: `Bearer ${key}`,
          Prefer: "return=minimal",
        },
        body: JSON.stringify({
          name: body.name,
          email: body.email,
          phone: body.phone || null,
          company: body.company || null,
          description: body.description,
          intent: body.intent || null,
          serviceName: body.serviceName || null,
          packageName: body.packageName || null,
          eventId: body.eventId || null,
        }),
      });
      if (res.ok) return { ok: true } as T;
    }
  }

  // Fallback to Supabase for newsletter
  if (path === "/newsletter/subscribe" && method === "POST") {
    const body = (options.body || {}) as Record<string, unknown>;
    const key = SUPABASE_KEY_VAL();
    if (SUPABASE_URL && key) {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/NewsletterSubscriber`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          apikey: key,
          Authorization: `Bearer ${key}`,
          Prefer: "return=minimal",
        },
        body: JSON.stringify({
          email: body.email,
          isConfirmed: false,
        }),
      });
      if (res.ok) return { ok: true } as T;
    }
  }

  throw new Error("Service temporarily unavailable; please retry shortly.");
}

export type ServiceRow = {
  id?: string;
  name: string;
  slug: string;
  group: string;
  summary: string;
  deliverables: string[];
  isPublished: boolean;
  sortOrder: number;
};

export type List<T> = { items: T[]; total: number; page: number };
export type Settings = Record<string, string | boolean>;

export async function allServices(): Promise<ServiceRow[]> {
  // 1. Try Express API
  try {
    const rows: ServiceRow[] = [];
    let page = 1;
    while (true) {
      const result = await api<List<ServiceRow>>(
        `/services?limit=100&page=${page++}`,
      );
      if (result?.items?.length) {
        rows.push(...result.items);
        if (rows.length >= result.total || !result.items.length) {
          if (rows.length > 0) return rows;
          break;
        }
      } else {
        break;
      }
    }
  } catch {}

  // 2. Try Supabase REST API
  const supabaseRows = await fetchFromSupabase<ServiceRow[]>(
    "Service",
    "?isPublished=eq.true&order=sortOrder.asc",
  );
  if (supabaseRows && supabaseRows.length > 0) {
    return supabaseRows;
  }

  // 3. Fallback to bundled catalog data
  return DEFAULT_SERVICES;
}

export async function fetchPackages(): Promise<string[]> {
  try {
    const result = await api<string[]>("/packages");
    if (result && result.length > 0) return result;
  } catch {}

  const supabaseRows = await fetchFromSupabase<{ name: string }[]>(
    "Package",
    "?order=sortOrder.asc",
  );
  if (supabaseRows && supabaseRows.length > 0) {
    return supabaseRows.map((r) => r.name);
  }

  return DEFAULT_PACKAGES;
}

export async function fetchPublicSettings(): Promise<Settings> {
  try {
    const result = await api<Settings>("/settings/public");
    if (result && Object.keys(result).length > 0) return result;
  } catch {}

  const supabaseRows = await fetchFromSupabase<{ key: string; value: string }[]>(
    "SiteSetting",
  );
  if (supabaseRows && supabaseRows.length > 0) {
    const settings: Settings = { ...DEFAULT_SETTINGS };
    for (const row of supabaseRows) {
      settings[row.key] = row.value;
    }
    return settings;
  }

  return DEFAULT_SETTINGS;
}

export async function exportCsv(path: string, filename: string) {
  await api("/admin/me");
  const [endpoint, query] = path.split("?");
  const params = new URLSearchParams(query);
  params.set("limit", "100");
  params.set("page", "1");
  const list = await api<List<{ id: string }>>(
    endpoint.replace(/\/export$/, "") + "?" + params,
  );
  const parts: string[] = [];
  for (let page = 1; page <= Math.max(1, Math.ceil(list.total / 100)); page++) {
    params.set("page", String(page));
    const response = await fetch(API + "/api" + endpoint + "?" + params, {
      credentials: "include",
    });
    if (!response.ok) throw new Error("Export failed; please retry");
    const text = await response.text();
    parts.push(page === 1 ? text : text.slice(text.indexOf("\r\n") + 2));
  }
  const url = URL.createObjectURL(
    new Blob([parts.join("\r\n")], { type: "text/csv;charset=utf-8" }),
  );
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
  URL.revokeObjectURL(url);
}
