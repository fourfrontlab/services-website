-- =============================================================================
-- Aster Digital - Complete Supabase PostgreSQL Database Schema
-- Compatible with Prisma ORM and Supabase Studio / REST API
-- =============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Ensure public schema exists
CREATE SCHEMA IF NOT EXISTS "public";

-- =============================================================================
-- 2. TABLE DEFINITIONS
-- =============================================================================

-- Table: Admin (Superadmins and platform administrators)
CREATE TABLE IF NOT EXISTS public."Admin" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'admin',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("id")
);

-- Table: RefreshToken (Hashed rotating refresh tokens)
CREATE TABLE IF NOT EXISTS public."RefreshToken" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "adminId" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "family" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- Table: LoginAttempt (Rate limiting and lockout tracking)
CREATE TABLE IF NOT EXISTS public."LoginAttempt" (
    "key" TEXT NOT NULL,
    "failures" INTEGER NOT NULL DEFAULT 0,
    "lockedUntil" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LoginAttempt_pkey" PRIMARY KEY ("key")
);

-- Table: Service (Published and draft digital agency services)
CREATE TABLE IF NOT EXISTS public."Service" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "group" TEXT NOT NULL,
    "summary" TEXT NOT NULL,
    "deliverables" TEXT[] NOT NULL DEFAULT '{}',
    "isPublished" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "Service_group_check" CHECK ("group" IN (
        'Web Design & Development',
        'Videography & Photography',
        'Brand & Content',
        'Technology'
    ))
);

-- Table: Package (Tiered service packages)
CREATE TABLE IF NOT EXISTS public."Package" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "name" TEXT NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Package_pkey" PRIMARY KEY ("id")
);

-- Table: Lead (Contact enquiries and lead submissions)
CREATE TABLE IF NOT EXISTS public."Lead" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "company" TEXT,
    "description" TEXT NOT NULL,
    "intent" TEXT,
    "serviceName" TEXT,
    "packageName" TEXT,
    "status" TEXT NOT NULL DEFAULT 'new',
    "source" TEXT,
    "notes" TEXT,
    "eventId" TEXT,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Lead_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "Lead_status_check" CHECK ("status" IN ('new', 'contacted', 'qualified', 'won', 'lost'))
);

-- Table: NewsletterSubscriber (Double opt-in newsletter subscribers)
CREATE TABLE IF NOT EXISTS public."NewsletterSubscriber" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "email" TEXT NOT NULL,
    "isConfirmed" BOOLEAN NOT NULL DEFAULT false,
    "confirmedAt" TIMESTAMP(3),
    "unsubscribedAt" TIMESTAMP(3),
    "tokenHash" TEXT,
    "tokenExpiresAt" TIMESTAMP(3),
    "unsubscribeHash" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NewsletterSubscriber_pkey" PRIMARY KEY ("id")
);

-- Table: RevenueEntry (Manual client revenue & invoice tracking)
CREATE TABLE IF NOT EXISTS public."RevenueEntry" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "leadId" TEXT,
    "clientName" TEXT NOT NULL,
    "serviceName" TEXT,
    "amount" DECIMAL(14,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'GBP',
    "status" TEXT NOT NULL DEFAULT 'invoiced',
    "invoicedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paidAt" TIMESTAMP(3),
    "notes" TEXT,

    CONSTRAINT "RevenueEntry_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "RevenueEntry_currency_check" CHECK ("currency" IN ('GBP', 'USD', 'EUR')),
    CONSTRAINT "RevenueEntry_status_check" CHECK ("status" IN ('invoiced', 'paid', 'overdue', 'refunded'))
);

-- Table: SiteSetting (Key-value site settings and pixel tracking IDs)
CREATE TABLE IF NOT EXISTS public."SiteSetting" (
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "SiteSetting_pkey" PRIMARY KEY ("key")
);

-- Table: AuditLog (Immutable administrator action audit log)
CREATE TABLE IF NOT EXISTS public."AuditLog" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "adminId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "metadata" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- Table: Outbox (Persistent asynchronous background jobs e.g. emails)
CREATE TABLE IF NOT EXISTS public."Outbox" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "kind" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "nextAttemptAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Outbox_pkey" PRIMARY KEY ("id")
);

-- Table: TrackingEvent (Deduplicated analytics and conversion events)
CREATE TABLE IF NOT EXISTS public."TrackingEvent" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TrackingEvent_pkey" PRIMARY KEY ("id")
);

-- =============================================================================
-- 3. INDEXES & CONSTRAINTS
-- =============================================================================

-- Admin
CREATE UNIQUE INDEX IF NOT EXISTS "Admin_email_key" ON public."Admin"("email");

-- RefreshToken
CREATE UNIQUE INDEX IF NOT EXISTS "RefreshToken_tokenHash_key" ON public."RefreshToken"("tokenHash");
CREATE INDEX IF NOT EXISTS "RefreshToken_family_idx" ON public."RefreshToken"("family");
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'RefreshToken_adminId_fkey') THEN
        ALTER TABLE public."RefreshToken"
        ADD CONSTRAINT "RefreshToken_adminId_fkey"
        FOREIGN KEY ("adminId") REFERENCES public."Admin"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;

-- Service
CREATE UNIQUE INDEX IF NOT EXISTS "Service_slug_key" ON public."Service"("slug");

-- Package
CREATE UNIQUE INDEX IF NOT EXISTS "Package_name_key" ON public."Package"("name");

-- Lead
CREATE UNIQUE INDEX IF NOT EXISTS "Lead_eventId_key" ON public."Lead"("eventId");
CREATE INDEX IF NOT EXISTS "Lead_deletedAt_status_createdAt_idx" ON public."Lead"("deletedAt", "status", "createdAt");

-- NewsletterSubscriber
CREATE UNIQUE INDEX IF NOT EXISTS "NewsletterSubscriber_email_key" ON public."NewsletterSubscriber"("email");
CREATE UNIQUE INDEX IF NOT EXISTS "NewsletterSubscriber_tokenHash_key" ON public."NewsletterSubscriber"("tokenHash");
CREATE UNIQUE INDEX IF NOT EXISTS "NewsletterSubscriber_unsubscribeHash_key" ON public."NewsletterSubscriber"("unsubscribeHash");

-- RevenueEntry
CREATE INDEX IF NOT EXISTS "RevenueEntry_currency_status_invoicedAt_idx" ON public."RevenueEntry"("currency", "status", "invoicedAt");
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'RevenueEntry_leadId_fkey') THEN
        ALTER TABLE public."RevenueEntry"
        ADD CONSTRAINT "RevenueEntry_leadId_fkey"
        FOREIGN KEY ("leadId") REFERENCES public."Lead"("id") ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END $$;

-- AuditLog
CREATE INDEX IF NOT EXISTS "AuditLog_createdAt_idx" ON public."AuditLog"("createdAt");

-- Outbox
CREATE INDEX IF NOT EXISTS "Outbox_deliveredAt_nextAttemptAt_idx" ON public."Outbox"("deliveredAt", "nextAttemptAt");


-- =============================================================================
-- 4. AUTOMATIC updatedAt TRIGGER FUNCTION
-- =============================================================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "set_updated_at_Admin" ON public."Admin";
CREATE TRIGGER "set_updated_at_Admin"
BEFORE UPDATE ON public."Admin"
FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS "set_updated_at_LoginAttempt" ON public."LoginAttempt";
CREATE TRIGGER "set_updated_at_LoginAttempt"
BEFORE UPDATE ON public."LoginAttempt"
FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS "set_updated_at_Service" ON public."Service";
CREATE TRIGGER "set_updated_at_Service"
BEFORE UPDATE ON public."Service"
FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS "set_updated_at_Lead" ON public."Lead";
CREATE TRIGGER "set_updated_at_Lead"
BEFORE UPDATE ON public."Lead"
FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();


-- =============================================================================
-- 5. ROW LEVEL SECURITY (RLS) & POLICIES
-- =============================================================================

-- Enable RLS on all tables
ALTER TABLE public."Admin" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."RefreshToken" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."LoginAttempt" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."Service" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."Package" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."Lead" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."NewsletterSubscriber" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."RevenueEntry" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."SiteSetting" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."AuditLog" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."Outbox" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."TrackingEvent" ENABLE ROW LEVEL SECURITY;

-- Note on Postgres / Express backend:
-- Connections established via DATABASE_URL using the 'postgres' role bypass RLS automatically.
-- The policies below govern Supabase API / PostgREST access (anon, authenticated, and service_role).

-- --- Service Policies ---
DROP POLICY IF EXISTS "Allow public read access to published services" ON public."Service";
CREATE POLICY "Allow public read access to published services"
ON public."Service"
FOR SELECT
TO anon, authenticated
USING ("isPublished" = true);

DROP POLICY IF EXISTS "Allow service role full access to services" ON public."Service";
CREATE POLICY "Allow service role full access to services"
ON public."Service"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- Package Policies ---
DROP POLICY IF EXISTS "Allow public read access to packages" ON public."Package";
CREATE POLICY "Allow public read access to packages"
ON public."Package"
FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Allow service role full access to packages" ON public."Package";
CREATE POLICY "Allow service role full access to packages"
ON public."Package"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- SiteSetting Policies ---
DROP POLICY IF EXISTS "Allow public read access to site settings" ON public."SiteSetting";
CREATE POLICY "Allow public read access to site settings"
ON public."SiteSetting"
FOR SELECT
TO anon, authenticated
USING (true);

DROP POLICY IF EXISTS "Allow service role full access to site settings" ON public."SiteSetting";
CREATE POLICY "Allow service role full access to site settings"
ON public."SiteSetting"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- Lead Policies (Public submission for contact form) ---
DROP POLICY IF EXISTS "Allow anonymous lead submission" ON public."Lead";
CREATE POLICY "Allow anonymous lead submission"
ON public."Lead"
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to leads" ON public."Lead";
CREATE POLICY "Allow service role full access to leads"
ON public."Lead"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- NewsletterSubscriber Policies ---
DROP POLICY IF EXISTS "Allow anonymous newsletter signup" ON public."NewsletterSubscriber";
CREATE POLICY "Allow anonymous newsletter signup"
ON public."NewsletterSubscriber"
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow token update for newsletter subscribers" ON public."NewsletterSubscriber";
CREATE POLICY "Allow token update for newsletter subscribers"
ON public."NewsletterSubscriber"
FOR UPDATE
TO anon, authenticated
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to subscribers" ON public."NewsletterSubscriber";
CREATE POLICY "Allow service role full access to subscribers"
ON public."NewsletterSubscriber"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- TrackingEvent Policies ---
DROP POLICY IF EXISTS "Allow anonymous tracking events" ON public."TrackingEvent";
CREATE POLICY "Allow anonymous tracking events"
ON public."TrackingEvent"
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to tracking events" ON public."TrackingEvent";
CREATE POLICY "Allow service role full access to tracking events"
ON public."TrackingEvent"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- --- Protected Admin / Operations Tables (service_role only) ---
DROP POLICY IF EXISTS "Allow service role full access to admin" ON public."Admin";
CREATE POLICY "Allow service role full access to admin"
ON public."Admin"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to refresh tokens" ON public."RefreshToken";
CREATE POLICY "Allow service role full access to refresh tokens"
ON public."RefreshToken"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to login attempts" ON public."LoginAttempt";
CREATE POLICY "Allow service role full access to login attempts"
ON public."LoginAttempt"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to revenue entries" ON public."RevenueEntry";
CREATE POLICY "Allow service role full access to revenue entries"
ON public."RevenueEntry"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to audit logs" ON public."AuditLog";
CREATE POLICY "Allow service role full access to audit logs"
ON public."AuditLog"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to outbox" ON public."Outbox";
CREATE POLICY "Allow service role full access to outbox"
ON public."Outbox"
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);


-- =============================================================================
-- 6. PRISMA MIGRATIONS COMPATIBILITY BASELINE
-- =============================================================================
-- Creates the _prisma_migrations baseline record so Prisma CLI recognises this
-- schema as migration '202609140001_initial', avoiding drift and allowing
-- future 'prisma migrate deploy' commands to run cleanly.

CREATE TABLE IF NOT EXISTS public."_prisma_migrations" (
    "id" VARCHAR(36) NOT NULL,
    "checksum" VARCHAR(64) NOT NULL,
    "finished_at" TIMESTAMPTZ,
    "migration_name" VARCHAR(255) NOT NULL,
    "logs" TEXT,
    "rolled_back_at" TIMESTAMPTZ,
    "started_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "applied_steps_count" INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT "_prisma_migrations_pkey" PRIMARY KEY ("id")
);

INSERT INTO public."_prisma_migrations" (
    "id",
    "checksum",
    "finished_at",
    "migration_name",
    "logs",
    "rolled_back_at",
    "started_at",
    "applied_steps_count"
)
VALUES (
    gen_random_uuid()::text,
    '51351ea28577b8d42360a1e9462b5ceb2cd6a09c1066e92882eb2defb8e7d125',
    now(),
    '202609140001_initial',
    NULL,
    NULL,
    now(),
    1
)
ON CONFLICT ("id") DO NOTHING;
