# Aster Digital — Supabase Database Integration Guide

This guide explains how to connect and run Aster Digital on [Supabase](https://supabase.com).

The Supabase setup in this folder includes:
- [schema.sql](file:///d:/Programming/Web%20Development/services-website/supabase/schema.sql): Complete SQL schema defining all 12 tables, indexes, foreign keys, automatic `updatedAt` triggers, Row Level Security (RLS) policies, and the Prisma migration baseline.
- [seed.sql](file:///d:/Programming/Web%20Development/services-website/supabase/seed.sql): Idempotent seed script inserting default service packages and all 26 core digital agency services with their complete deliverables.

---

## 1. Quick Setup via Supabase Web Dashboard (Recommended)

1. **Create a Supabase Project:**
   - Go to [database.new](https://database.new) and create a new project.
   - Note your database password and project region.

2. **Run the Database Schema:**
   - In your Supabase project dashboard, open the **SQL Editor** from the left navigation.
   - Click **New query**.
   - Copy the entire contents of [supabase/schema.sql](file:///d:/Programming/Web%20Development/services-website/supabase/schema.sql) and paste it into the editor.
   - Click **Run** (or `Ctrl` + `Enter`).
   - All 12 tables (`Admin`, `RefreshToken`, `LoginAttempt`, `Service`, `Package`, `Lead`, `NewsletterSubscriber`, `RevenueEntry`, `SiteSetting`, `AuditLog`, `Outbox`, `TrackingEvent`), constraints, triggers, and RLS policies will be created.

3. **Populate Default Services & Packages:**
   - In the **SQL Editor**, open another **New query**.
   - Copy the contents of [supabase/seed.sql](file:///d:/Programming/Web%20Development/services-website/supabase/seed.sql) and paste it.
   - Click **Run**.
   - Your database is now seeded with the 3 packages (`Foundation`, `Momentum`, `Partnership`) and 26 services with their full descriptions and deliverables.

4. **Create Initial Admin Account:**
   - To create an initial administrator account, you can either:
     - Run `npm run db:seed` with `INITIAL_ADMIN_EMAIL` and `INITIAL_ADMIN_PASSWORD` (see Section 3), OR
     - Run this SQL in the Supabase SQL Editor (replace email and password hash with your own):
       ```sql
       -- Example bcrypt hash (cost 12) for: "ChangeMe12345!"
       INSERT INTO public."Admin" ("id", "email", "passwordHash", "role", "isActive")
       VALUES (
         gen_random_uuid()::text,
         'owner@yourdomain.com',
         '$2a$12$e0MYzXyjpJS7Pd0RVvHwHeT96vKqvW8m9qQx/vC1xU9d70Xw1y4tq',
         'admin',
         true
       )
       ON CONFLICT ("email") DO NOTHING;
       ```

---

## 2. Configure Environment Variables in `apps/api/.env`

In your Supabase project dashboard:
1. Navigate to **Project Settings** -> **Database**.
2. Scroll to the **Connection string** section.

### Set up `apps/api/.env`:

```env
# Mode: Transaction Pooler (Port 6543) - used for regular API queries
DATABASE_URL="postgresql://postgres.hxjtmkzlnhjysfmylajz:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true"

# Mode: Session Pooler (Port 5432) or Direct Connection - used for Prisma migrations
DIRECT_URL="postgresql://postgres.hxjtmkzlnhjysfmylajz:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres"

# Optional direct connection without pooler:
# DIRECT_URL="postgresql://postgres:[YOUR-PASSWORD]@db.hxjtmkzlnhjysfmylajz.supabase.co:5432/postgres"

SUPABASE_URL="https://hxjtmkzlnhjysfmylajz.supabase.co"
SUPABASE_ANON_KEY="sb_publishable_iN0ntol8LK3MrmqxLNowRA_62fCRu67"
```

> **Important notes:**
> - If your database password contains special characters (like `@`, `#`, `$`, `%`), make sure the password in the connection string is URL-encoded.
> - `DATABASE_URL` uses port `6543` with `?pgbouncer=true` for pooled connections.
> - `DIRECT_URL` uses port `5432` for Prisma migrations and schema verification.

---

## 3. Alternative: Running Migrations & Seeding via CLI

If you prefer to deploy migrations through Prisma directly against Supabase:

1. Put your Supabase `DATABASE_URL` and `DIRECT_URL` into `apps/api/.env`.
2. Set initial admin credentials temporarily in `apps/api/.env`:
   ```env
   INITIAL_ADMIN_EMAIL=owner@yourdomain.com
   INITIAL_ADMIN_PASSWORD=YourStrongPassword123!
   ```
3. Run:
   ```bash
   npm run db:migrate
   npm run db:seed
   ```
4. Remove `INITIAL_ADMIN_EMAIL` and `INITIAL_ADMIN_PASSWORD` from `apps/api/.env` after the first run.

---

## 4. Row Level Security (RLS) Overview

The provided schema activates Row Level Security (RLS) on all tables:

| Table | Public Access (`anon` / `authenticated`) | Backend / `service_role` Access |
|---|---|---|
| `"Service"` | `SELECT` (published services only: `isPublished = true`) | Full CRUD |
| `"Package"` | `SELECT` (all packages) | Full CRUD |
| `"SiteSetting"` | `SELECT` (public configuration) | Full CRUD |
| `"Lead"` | `INSERT` (contact form submissions) | Full CRUD |
| `"NewsletterSubscriber"` | `INSERT` (sign up), `UPDATE` (confirm / unsubscribe) | Full CRUD |
| `"TrackingEvent"` | `INSERT` (opt-in analytics deduplication) | Full CRUD |
| `"Admin"` | No access | Full CRUD |
| `"RefreshToken"` | No access | Full CRUD |
| `"LoginAttempt"` | No access | Full CRUD |
| `"RevenueEntry"` | No access | Full CRUD |
| `"AuditLog"` | No access | Full CRUD |
| `"Outbox"` | No access | Full CRUD |

> Connections from the Express backend via `DATABASE_URL` connect as the PostgreSQL owner role (`postgres`), which automatically bypasses RLS while keeping client-side access through Supabase APIs completely secure.
