import { useEffect, useState, type ReactNode } from "react";
import { hydrateContent, packages } from "../content";
import { configureAnalytics } from "../lib/analytics";
import {
  allServices,
  fetchPackages,
  fetchPublicSettings,
  type Settings,
} from "../lib/api";
import {
  DEFAULT_SERVICES,
  DEFAULT_PACKAGES,
  DEFAULT_SETTINGS,
} from "../lib/fallback-data";

export let siteSettings: Settings = DEFAULT_SETTINGS;

// Initialize default content synchronously so the website renders instantly
hydrateContent(
  DEFAULT_SERVICES.map((row) => ({
    ...row,
    id: row.id || row.slug,
    description: row.summary,
    items: row.deliverables,
  })),
  DEFAULT_SETTINGS,
);
packages.splice(0, packages.length, ...DEFAULT_PACKAGES);

export default function PublicData({ children }: { children: ReactNode }) {
  const [, setAttempt] = useState(0);

  useEffect(() => {
    let cancelled = false;

    Promise.all([allServices(), fetchPublicSettings(), fetchPackages()])
      .then(([rows, settings, names]) => {
        if (cancelled) return;
        const validRows =
          rows && rows.length > 0 ? rows : DEFAULT_SERVICES;
        const validPackages =
          names && names.length > 0 ? names : DEFAULT_PACKAGES;
        const validSettings =
          settings && Object.keys(settings).length > 0
            ? settings
            : DEFAULT_SETTINGS;

        hydrateContent(
          validRows.map((row) => ({
            ...row,
            id: row.id || row.slug,
            description: row.summary,
            items: row.deliverables,
          })),
          validSettings,
        );
        packages.splice(0, packages.length, ...validPackages);
        siteSettings = validSettings;
        configureAnalytics(validSettings);
        setAttempt((x) => x + 1);
      })
      .catch(() => {
        // Fallback data is already hydrated; site remains fully functional
      });

    return () => {
      cancelled = true;
    };
  }, []);

  return <>{children}</>;
}
