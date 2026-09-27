import fs from "node:fs";

const services = JSON.parse(
  fs.readFileSync("apps/api/prisma/seed-services.json", "utf8"),
);
const packages = JSON.parse(
  fs.readFileSync("apps/api/prisma/seed-packages.json", "utf8"),
);

const content = `import type { ServiceRow } from "./api";

export const DEFAULT_SERVICES: ServiceRow[] = ${JSON.stringify(services, null, 2)};

export const DEFAULT_PACKAGES: string[] = ${JSON.stringify(packages, null, 2)};

export const DEFAULT_SETTINGS: Record<string, string | boolean> = {
  "contact.email": "",
  "contact.phone": "",
  "contact.whatsapp": "",
  "consent.copy":
    "We use optional analytics and advertising cookies to understand visits and enquiries. You can accept, decline, or change your choice at any time.",
  spamBypass: false,
  turnstileSiteKey: "",
  ga4ServerRelay: false,
  metaServerRelay: false,
};
`;

fs.writeFileSync("src/lib/fallback-data.ts", content);
console.log("Successfully generated src/lib/fallback-data.ts");
