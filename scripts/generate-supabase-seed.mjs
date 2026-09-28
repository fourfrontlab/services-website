import fs from "node:fs";

const services = JSON.parse(
  fs.readFileSync("apps/api/prisma/seed-services.json", "utf8"),
);
const packages = JSON.parse(
  fs.readFileSync("apps/api/prisma/seed-packages.json", "utf8"),
);

let sql = `-- =============================================================================
-- Aster Digital - Initial Seed Data for Supabase
-- =============================================================================

-- Packages
INSERT INTO public."Package" ("id", "name", "sortOrder") VALUES
${packages
  .map(
    (pkg, i) =>
      `  (COALESCE((SELECT "id" FROM public."Package" WHERE "name" = '${pkg}'), gen_random_uuid()::text), '${pkg}', ${i})`,
  )
  .join(",\n")}
ON CONFLICT ("name") DO NOTHING;

-- Services
INSERT INTO public."Service" (
  "id",
  "name",
  "slug",
  "group",
  "summary",
  "deliverables",
  "isPublished",
  "sortOrder",
  "createdAt",
  "updatedAt"
) VALUES
${services
  .map((s) => {
    const deliverables =
      "ARRAY[" +
      s.deliverables.map((d) => `'${d.replace(/'/g, "''")}'`).join(", ") +
      "]";
    const name = s.name.replace(/'/g, "''");
    const slug = s.slug.replace(/'/g, "''");
    const group = s.group.replace(/'/g, "''");
    const summary = s.summary.replace(/'/g, "''");
    return `  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = '${slug}'), gen_random_uuid()::text), '${name}', '${slug}', '${group}', '${summary}', ${deliverables}, ${s.isPublished}, ${s.sortOrder}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)`;
  })
  .join(",\n")}
ON CONFLICT ("slug") DO UPDATE SET
  "name" = EXCLUDED."name",
  "group" = EXCLUDED."group",
  "summary" = EXCLUDED."summary",
  "deliverables" = EXCLUDED."deliverables",
  "isPublished" = EXCLUDED."isPublished",
  "sortOrder" = EXCLUDED."sortOrder",
  "updatedAt" = CURRENT_TIMESTAMP;
`;

fs.mkdirSync("supabase", { recursive: true });
fs.writeFileSync("supabase/seed.sql", sql);
console.log("Successfully generated supabase/seed.sql");
