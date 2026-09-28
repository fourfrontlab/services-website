-- =============================================================================
-- Aster Digital - Initial Seed Data for Supabase
-- =============================================================================

-- Packages
INSERT INTO public."Package" ("id", "name", "sortOrder") VALUES
  (COALESCE((SELECT "id" FROM public."Package" WHERE "name" = 'Foundation'), gen_random_uuid()::text), 'Foundation', 0),
  (COALESCE((SELECT "id" FROM public."Package" WHERE "name" = 'Momentum'), gen_random_uuid()::text), 'Momentum', 1),
  (COALESCE((SELECT "id" FROM public."Package" WHERE "name" = 'Partnership'), gen_random_uuid()::text), 'Partnership', 2)
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
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'web-design-and-development'), gen_random_uuid()::text), 'Customized Website Development', 'web-design-and-development', 'Web Design & Development', 'Turn a confusing website into a clear path from first visit to enquiry.', ARRAY['Discovery & sitemap', 'Responsive interface design', 'Accessible frontend', 'Launch checklist'], true, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'ecommerce'), gen_random_uuid()::text), 'eCommerce Store Development', 'ecommerce', 'Web Design & Development', 'Make browsing, choosing, and buying feel effortless for your customers.', ARRAY['Product architecture', 'Storefront design', 'Checkout planning', 'Catalogue handover'], true, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'wordpress'), gen_random_uuid()::text), 'WordPress Website Development', 'wordpress', 'Web Design & Development', 'Give your team a website they can confidently update themselves.', ARRAY['Custom themes', 'Editor training', 'Plugin review', 'Content migration'], true, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'shopify'), gen_random_uuid()::text), 'Shopify Website Development', 'shopify', 'Web Design & Development', 'Build a distinctive store around your products and the way your customers shop.', ARRAY['Theme configuration', 'Collections', 'Payment provider planning', 'Store training'], true, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'custom-applications'), gen_random_uuid()::text), 'Custom applications', 'custom-applications', 'Technology', 'Replace scattered spreadsheets with a considered digital workflow.', ARRAY['Workflow mapping', 'Interactive prototype', 'API architecture', 'Role and access planning'], true, 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'seo-and-search-visibility'), gen_random_uuid()::text), 'SEO & search visibility', 'seo-and-search-visibility', 'Brand & Content', 'Help the right people discover the answers your business can offer.', ARRAY['Technical review', 'Local SEO & Google Business Profile', 'Content strategy', 'AEO & GEO planning'], true, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'paid-advertising'), gen_random_uuid()::text), 'Paid advertising', 'paid-advertising', 'Brand & Content', 'Connect a specific offer with an audience that is ready to act.', ARRAY['Google Search & Shopping', 'Meta campaign planning', 'Landing pages', 'Conversion measurement'], true, 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'social-media'), gen_random_uuid()::text), 'Social media', 'social-media', 'Brand & Content', 'Build a consistent presence that gives people a reason to follow along.', ARRAY['Editorial calendar', 'Community guidelines', 'Campaign creative', 'Influencer planning'], true, 7, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'branding-and-graphic-design'), gen_random_uuid()::text), 'Branding & graphic design', 'branding-and-graphic-design', 'Brand & Content', 'Bring your business into focus with a recognisable, usable visual identity.', ARRAY['Logo & identity', 'Corporate stationery', 'Packaging', 'Brand guidelines'], true, 8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'content-writing'), gen_random_uuid()::text), 'Content writing', 'content-writing', 'Brand & Content', 'Explain your offer in language your customers actually use.', ARRAY['Website copy', 'Product descriptions', 'Articles', 'Editorial guidelines'], true, 9, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'photography-and-video'), gen_random_uuid()::text), 'Photography & video', 'photography-and-video', 'Videography & Photography', 'Show the details that make your products, spaces, and people worth noticing.', ARRAY['Shot planning', 'Product photography', 'Video & reels', 'Drone production planning'], true, 10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'virtual-tours'), gen_random_uuid()::text), 'Virtual tours', 'virtual-tours', 'Videography & Photography', 'Let visitors understand a space before they step through the door.', ARRAY['Capture plan', '360° tour production', 'Hotspot content', 'Website embedding'], true, 11, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'hosting-and-domains'), gen_random_uuid()::text), 'Hosting & domains', 'hosting-and-domains', 'Technology', 'Give your website and business email a well-considered home.', ARRAY['Domain planning', 'Hosting configuration', 'Business email', 'SSL setup'], true, 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'maintenance-and-support'), gen_random_uuid()::text), 'Maintenance & support', 'maintenance-and-support', 'Technology', 'Keep your website useful as your content and business evolve.', ARRAY['Update planning', 'Backups', 'Performance reviews', 'Support workflow'], true, 13, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'telecom-and-voip'), gen_random_uuid()::text), 'Telecom & VOIP', 'telecom-and-voip', 'Technology', 'Plan clearer communication between your team and your customers.', ARRAY['Call flow mapping', 'SIP & PBX planning', 'Queue configuration', 'Team documentation'], true, 14, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'infrastructure-support'), gen_random_uuid()::text), 'Infrastructure support', 'infrastructure-support', 'Technology', 'Create an organised foundation for the tools your team depends on.', ARRAY['Network assessment', 'Cloud planning', 'Monitoring plan', 'Recovery documentation'], true, 15, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'platform-development'), gen_random_uuid()::text), 'Platform development', 'platform-development', 'Web Design & Development', 'Choose the right publishing platform for the people maintaining your website.', ARRAY['WooCommerce', 'Wix & Squarespace', 'Webflow', 'Migration planning'], true, 16, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'business-systems'), gen_random_uuid()::text), 'Business systems', 'business-systems', 'Technology', 'Shape purpose-built tools around a real operational problem.', ARRAY['CRM & ERP planning', 'LMS & marketplaces', 'Billing & project management', 'Recruitment & balloting workflows'], true, 17, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'extensions-and-integrations'), gen_random_uuid()::text), 'Extensions & integrations', 'extensions-and-integrations', 'Technology', 'Connect existing tools without adding unnecessary work for your team.', ARRAY['WordPress plugins', 'Shopify apps', 'Custom themes', 'API integrations'], true, 18, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'digital-growth-partnership'), gen_random_uuid()::text), 'Digital growth partnership', 'digital-growth-partnership', 'Brand & Content', 'Coordinate your website, content, and campaigns around one shared plan.', ARRAY['Quarterly priorities', 'Ecommerce brand building', 'Campaign coordination', 'Measurement reviews'], true, 19, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'ai-assisted-experiences'), gen_random_uuid()::text), 'AI-assisted experiences', 'ai-assisted-experiences', 'Technology', 'Explore useful automation with clear human oversight.', ARRAY['Use-case review', 'Search & assistance design', 'Prototype evaluation', 'Privacy requirements'], true, 20, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'laravel-custom-website-development'), gen_random_uuid()::text), 'Laravel Custom Website Development', 'laravel-custom-website-development', 'Web Design & Development', 'Give complex workflows a clear, scalable home, from booking platforms to business portals.', ARRAY['Workflow discovery', 'Laravel architecture', 'Portal interface', 'Integration planning'], true, 21, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'website-redesign-and-development'), gen_random_uuid()::text), 'Website Redesign & Development', 'website-redesign-and-development', 'Web Design & Development', 'Keep what works and reimagine the parts that hold your website back.', ARRAY['Content audit', 'User journey redesign', 'Migration planning', 'Performance review'], true, 22, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'photography'), gen_random_uuid()::text), 'Photography', 'photography', 'Videography & Photography', 'Create a coherent image library around your products, people, and places.', ARRAY['Creative direction', 'Product photography', 'Brand & lifestyle photography', 'Image selection & retouching'], true, 23, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'videography'), gen_random_uuid()::text), 'Videography', 'videography', 'Videography & Photography', 'Bring your story to life with purposeful motion, sound, and a considered edit.', ARRAY['Brand films', 'Commercial & product videos', 'Social media edits', 'Event coverage'], true, 24, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (COALESCE((SELECT "id" FROM public."Service" WHERE "slug" = 'video-editing'), gen_random_uuid()::text), 'Video Editing', 'video-editing', 'Videography & Photography', 'Turn raw footage into a focused story, ready for the channels that matter.', ARRAY['Story assembly', 'Colour treatment', 'Sound editing', 'Captions & channel exports'], true, 25, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT ("slug") DO UPDATE SET
  "name" = EXCLUDED."name",
  "group" = EXCLUDED."group",
  "summary" = EXCLUDED."summary",
  "deliverables" = EXCLUDED."deliverables",
  "isPublished" = EXCLUDED."isPublished",
  "sortOrder" = EXCLUDED."sortOrder",
  "updatedAt" = CURRENT_TIMESTAMP;
