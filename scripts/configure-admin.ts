import "../apps/api/src/config.js";
import { db } from "../apps/api/src/db.js";
import { passwordHash, hash } from "../apps/api/src/auth.js";
import { login } from "../apps/api/src/validators.js";

// Supply credentials through the environment; never commit a password.
const credentials = login.parse({
  username: process.env.ADMIN_USERNAME,
  password: process.env.ADMIN_PASSWORD,
});
if (
  !credentials.username ||
  credentials.password.length < 10 ||
  Buffer.byteLength(credentials.password) > 72
)
  throw new Error(
    "Set ADMIN_USERNAME and ADMIN_PASSWORD (10–72 bytes minimum 10 characters).",
  );
try {
  const encoded = await passwordHash(credentials.password);
  await db.$transaction(async (tx) => {
    const admin = await tx.admin.upsert({
      where: { username: credentials.username },
      create: {
        username: credentials.username,
        email: `${credentials.username}@admin.local`,
        passwordHash: encoded,
      },
      update: { passwordHash: encoded, isActive: true },
    });
    await tx.refreshToken.updateMany({
      where: { adminId: admin.id },
      data: { revokedAt: new Date() },
    });
    await tx.loginAttempt.deleteMany({
      where: { key: { in: [hash(admin.id), hash(credentials.username!)] } },
    });
  });
  console.log(
    "Admin account configured. Sign in at /admin with the supplied username.",
  );
} finally {
  await db.$disconnect();
}
