# Permits Architecture - Independent Storage

## Overview
Phone and WearOS permits are stored **independently** on each device. There is **NO cloud sync** for permits to avoid authentication complexity and privacy concerns.

## How It Works

### Mobile App (Phone/Tablet)
- Permits stored in local SQLite database (via Drift)
- Encrypted with AES-256
- Add, edit, delete permits independently
- QR code generation for verification
- Location: `AppDatabase` → `permits` table

### WearOS App (Smartwatch)
- Permits stored in separate local SQLite database
- Same encryption as phone
- Display-only functionality optimized for watch screen
- Independent from phone permits
- Location: `AppDatabase` → `permits` table (separate instance)

## Why Independent?

**Security & Privacy:**
- No need for user authentication
- Each device's data stays local
- No cloud storage = no data breaches
- Complies with data privacy regulations

**Offline-First:**
- Works without internet
- No sync delays or failures
- Faster performance
- Reliable in areas with poor connectivity (like during Hajj)

**Simplicity:**
- No Firebase Auth setup needed
- No complex sync logic
- Easier to maintain
- Lower cloud costs

## User Workflow

### If User Has Both Phone and Watch:

**Option 1: Use Phone Primarily**
1. Add permit on phone
2. Show QR code when needed
3. Watch can have same permit entered manually (optional)

**Option 2: Use Watch for Quick Access**
1. Add permit manually on watch
2. Use for quick display when raising wrist
3. Keep main permit on phone for detailed view

**Option 3: Same Permit on Both (Manual Entry)**
1. Enter same permit details on phone
2. Enter same permit details on watch
3. Both devices work independently

## Firebase Usage

Firebase Firestore is **only** used for:
- ✅ Family location sharing
- ✅ Family group management
- ❌ **NOT** for permit storage

## Database Schema

```
permits (SQLite/Drift)
├── id (int, primary key)
├── permitNumber (string, encrypted)
├── fullName (string, encrypted)
├── permitType (string) - "Hajj" or "Umrah"
├── startDate (DateTime)
├── endDate (DateTime)
├── createdAt (DateTime)
└── updatedAt (DateTime)
```

## Security Features

- AES-256-CBC encryption for sensitive fields
- SHA-256 key derivation
- Local-only storage (no transmission)
- Automatic data cleanup on app uninstall

## Future Enhancement Ideas (Optional)

If cloud sync is needed later, you could:
1. Use Firebase Auth for user accounts
2. Store permits under `users/{userId}/permits/`
3. Implement Firestore security rules
4. Add offline/online sync logic

But for now, **local-only** is the simpler, more secure approach! 🔐
