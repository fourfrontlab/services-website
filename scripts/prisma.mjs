import dotenv from "dotenv";
import { spawnSync } from "node:child_process";
dotenv.config({ path: "apps/api/.env", quiet: true });
dotenv.config({ path: ".env", quiet: true });
if (!process.env.DATABASE_URL) {
  process.env.DATABASE_URL =
    "postgresql://postgres:postgres@localhost:5432/postgres";
}
if (!process.env.DIRECT_URL) {
  process.env.DIRECT_URL = process.env.DATABASE_URL;
}
const result = spawnSync(
  process.execPath,
  [
    "node_modules/prisma/build/index.js",
    ...process.argv.slice(2),
    "--schema",
    "apps/api/prisma/schema.prisma",
  ],
  { stdio: "inherit", env: process.env },
);
process.exit(result.status ?? 1);
