# Admin dashboard

This folder contains the separate, lazy-loaded admin interface at `/admin`.

- `Admin.tsx`: username/email login, overview, enquiry inbox, service management, revenue, newsletter, settings and activity log.
- `admin.css`: dashboard styles scoped to `.admin-shell`.
- Shared API client: `../lib/api.ts`.
- Backend: `../../apps/api/src`, with persistent PostgreSQL storage through Prisma.

All admin data endpoints require a server-authenticated session. The public contact page submits to `/api/contact`; saved enquiries are read through `/api/admin/leads`. Passwords and database credentials must never be added to this folder. See `../../docs/ADMIN-GUIDE.md` for account setup and operation.
