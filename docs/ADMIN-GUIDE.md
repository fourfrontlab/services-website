# Aster Digital administration

Open `/admin` (or `/admin/login`) and sign in with a username or email. The requested local account is `syedhaseebbadshah`; use the password supplied in the conversation. Passwords are bcrypt hashes in PostgreSQL and are never included in the frontend or committed source.

The dashboard lives separately in `src/admin`, while the customer site and dashboard share `apps/api` and PostgreSQL. Contact, consultation, service and website-review requests all use the public enquiry form and arrive in the same protected inbox. Receipt in the dashboard does not depend on email delivery. Email notifications need Resend configuration; local development has no live email provider.

To configure an account on another installation, apply migrations, set `ADMIN_USERNAME` and `ADMIN_PASSWORD` in the server environment, then run `node --import tsx scripts/configure-admin.ts`. Remove those environment variables afterwards. Running this command again for the same username resets its password and revokes its existing sessions. Existing email-based accounts continue working. Credentials are not automatically created when cloning or deploying the repository.

- **Dashboard:** the five latest new enquiries, with a total count and direct links, refresh every 30 seconds while the page is visible. Also shows enquiries received over the last seven days, published services, confirmed subscribers, and queued delivery counts. Revenue totals stay separated by currency and status. Monthly bars use the payment date and show the current calendar year.
- **Enquiries:** search names, email addresses, companies and messages; filter by status, exact service name, and inclusive date range. Use Refresh to fetch new records. View the full enquiry including the source page, update status and internal notes. Delete hides a lead from the inbox; permanent erasure is a separate data request procedure.
- **Services:** create and edit names, summaries, deliverables, group, publication state and display order. Existing URL slugs are seeded unchanged. Changing a slug changes its URL. Remove unpublishes; it does not destroy the record. New services get a generic detail page using their saved content. Public pages read current data on page load.
- **Revenue:** enter an exact amount, currency, invoice date and status. Paid records require a payment date. A related lead ID is optional and must refer to an existing lead. This records revenue; it does not charge a customer or generate an invoice.
- **Newsletter:** confirmed subscribers are distinguished from pending and unsubscribed records. New signups receive a 24-hour confirmation link. Unsubscribe is immediate and invalidates pending confirmation links.
- **Exports:** CSV exports retrieve all matching records in bounded pages of 100. Lead filters are preserved. Spreadsheet formula characters are escaped. Avoid editing records while exporting a large result set. Keep downloaded files private and delete them when no longer needed.
- **Settings:** edit contact details, public pixel IDs, Google Ads conversion ID/label and consent copy. Server secrets show only configured/not configured. They must be changed in the API environment. Password changes revoke all sessions.
- **Audit log:** records admin actions without storing passwords or full lead content.

If a delivery fails, the enquiry remains saved. The worker retries up to 12 times with increasing delay. The dashboard shows failed deliveries. An operator should fix credentials/provider errors and explicitly reset failed jobs as described in the runbook.
