---
name: Proactive Boilerplate Feature Confirmation
description: Always ask the user for confirmation before keeping or removing boilerplate default features, and correctly identify if Terms of Service is mandatory.
---
# Proactive Boilerplate Feature Confirmation

When setting up a new app or utilizing an existing boilerplate/app-factory codebase:
1. **Never assume all default features should be kept.**
2. **Proactively ask the user** to confirm whether specific default boilerplate modules (such as onboarding screens, tutorials, or social logins) should be included or removed, based on the app's core purpose.
3. **Terms of Service (이용약관):** Understand that a Terms of Service is **not mandatory** for all apps. Simple casual games or utility apps do not strictly need them. Only enforce or recommend generating a Terms of Service if the app has In-App Purchases, Subscriptions, User-Generated Content, or handles sensitive user accounts. Otherwise, treat it as optional and ask the user if they want to exclude it. (Note: Privacy Policy is ALWAYS mandatory).
4. **Explicitly review default permissions** (e.g., Camera, Read External Storage, Location) present in the boilerplate's configuration (like `AndroidManifest.xml` or `Info.plist`) with the user.
5. Remove any permissions or modules that are unnecessary for the specific app being built to avoid app store review issues.
6. **Proactively suggest adding permissions back:** If the nature of the new app clearly requires certain permissions (e.g., a photo editing app needs Camera/Storage), the AI MUST proactively inform the user and ask for permission to add them back to the manifest. Do not let the app fail silently due to missing permissions.
7. Obtain the user's explicit decision on these features *before* proceeding with the final setup or build.
