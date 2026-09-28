ALTER TABLE "Admin" ADD COLUMN "username" TEXT;
CREATE UNIQUE INDEX "Admin_username_key" ON "Admin"("username");
