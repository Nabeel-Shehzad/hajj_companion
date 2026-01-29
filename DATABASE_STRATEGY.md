# Database Strategy for Hajj Companion App

## ✅ DECISION: Hybrid Database Approach

### **Primary Database: Drift (SQLite)**
**Status:** ✅ Already Implemented  
**Package:** `drift: ^2.14.0` + `sqlite3_flutter_libs: ^0.5.0`

---

## 📊 Why This Hybrid Architecture?

### **1. Drift/SQLite - For LOCAL Data (Primary)**
**Use Cases:**
- ✅ Permit information (encrypted)
- ✅ App settings & preferences
- ✅ Offline ritual guidance data
- ✅ Cached location data
- ✅ Offline duas library

**Advantages:**
- ✅ Works 100% OFFLINE (critical for crowded holy sites)
- ✅ Fast query performance
- ✅ Type-safe with generated code
- ✅ Built-in encryption support
- ✅ Reactive streams with `watchPermit()`
- ✅ ACID compliance for data integrity
- ✅ Zero latency (no network required)

**Current Implementation:**
```dart
// Already implemented tables:
- Permits (id, permitNumber, fullName, permitType, dates, encryptedData)
- AppSettings (key-value storage)
```

---

### **2. Firebase Firestore - For REAL-TIME Family Tracking (Secondary)**
**Status:** ✅ Already Added to pubspec.yaml  
**Package:** `cloud_firestore: ^5.6.0`

**Use Cases:**
- ✅ Family group membership
- ✅ Real-time location sharing (FR-13, FR-20)
- ✅ Child distance alerts (FR-16, FR-17)
- ✅ Live family member positions

**Advantages:**
- ✅ Real-time synchronization across devices
- ✅ Automatic conflict resolution
- ✅ Built-in authentication with Firebase Auth
- ✅ Offline persistence (caches data locally)
- ✅ Scales automatically
- ✅ No server management required

**Why NOT SQLite for Family Tracking:**
- ❌ Requires custom backend server
- ❌ Complex WebSocket implementation
- ❌ Manual conflict resolution
- ❌ Student project time constraints

---

## 🏗️ Database Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Mobile App                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐         ┌────────────────────┐   │
│  │   Drift/SQLite  │         │  Firebase Firestore│   │
│  │   (LOCAL DB)    │         │   (CLOUD SYNC)     │   │
│  ├─────────────────┤         ├────────────────────┤   │
│  │ • Permits       │         │ • Family Groups    │   │
│  │ • Settings      │         │ • Live Locations   │   │
│  │ • Duas Library  │         │ • Distance Alerts  │   │
│  │ • Geofences     │         │ • Member Status    │   │
│  │ • Cache Data    │         │                    │   │
│  └─────────────────┘         └────────────────────┘   │
│         ↑                              ↑               │
│         │ Always Available             │ When Online   │
│         │ (Offline-First)              │ (Auto-Cache)  │
└─────────────────────────────────────────────────────────┘
```

---

## 📋 Data Storage Breakdown

### **Local Storage (Drift/SQLite)**

| Feature | Table/Collection | Reason |
|---------|-----------------|--------|
| **Permit Management** | `Permits` table | Personal data, requires encryption, offline access |
| **App Settings** | `AppSettings` table | User preferences, offline access |
| **Ritual Locations** | `GeofenceLocations` table | Static data, no sync needed |
| **Duas Library** | `Duas` table | Static content, offline access |
| **Location History** | `LocationHistory` table | Personal tracking log |

### **Cloud Storage (Firebase Firestore)**

| Feature | Collection | Reason |
|---------|-----------|--------|
| **Family Groups** | `family_groups` | Multi-device sharing |
| **Live Locations** | `family_groups/{id}/members` | Real-time updates (30s intervals) |
| **Distance Alerts** | `family_groups/{id}/alerts` | Cross-device notifications |
| **Device Registry** | `devices` | Device linking & verification |

---

## 🔐 Security Strategy

### **Local Data (SQLite):**
```dart
// Already Implemented:
- AES-256 encryption for permit data
- SHA-256 hashing for keys
- Encrypted storage in app_database.dart
```

### **Cloud Data (Firestore):**
```javascript
// Firestore Security Rules:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Family groups only accessible by members
    match /family_groups/{groupId} {
      allow read, write: if request.auth != null && 
                            request.auth.uid in resource.data.memberIds;
      
      // Live location updates
      match /members/{memberId} {
        allow write: if request.auth.uid == memberId;
        allow read: if request.auth != null && 
                       request.auth.uid in get(/databases/$(database)/documents/family_groups/$(groupId)).data.memberIds;
      }
    }
  }
}
```

---

## 📊 Tables/Collections Schema

### **Drift Tables (Already Implemented):**

```dart
// ✅ Permits Table
class Permits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get permitNumber => text().withLength(max: 20)();
  TextColumn get fullName => text().withLength(max: 50)();
  TextColumn get permitType => text()(); // 'Hajj' or 'Umrah'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get encryptedData => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// ✅ AppSettings Table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

### **Future Drift Tables (To Be Added):**

```dart
// 🔜 Duas Table - Ritual prayers
class Duas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locationName => text()();
  TextColumn get arabicText => text()();
  TextColumn get englishTranslation => text()();
  TextColumn get audioFilePath => text().nullable()();
  TextColumn get ritualType => text()(); // 'self' or 'behalf'
}

// 🔜 GeofenceLocations Table - Holy sites
class GeofenceLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get radiusMeters => real()();
  TextColumn get duaId => text()(); // Link to Duas table
}
```

### **Firestore Collections (To Be Implemented):**

```typescript
// 🔜 Family Groups Collection
family_groups/{groupId} {
  groupName: string
  adminId: string
  memberIds: string[]
  createdAt: timestamp
  
  // Subcollection: members/{memberId}
  members/{memberId} {
    name: string
    deviceId: string
    isChild: boolean
    safeDistanceMeters: number  // For children only
    lastLocation: {
      latitude: number
      longitude: number
      timestamp: timestamp
    }
  }
  
  // Subcollection: alerts/{alertId}
  alerts/{alertId} {
    childId: string
    childName: string
    distance: number
    timestamp: timestamp
    acknowledged: boolean
  }
}
```

---

## 🎯 Implementation Phases

### **Phase 1: Permit Feature (Current)** ✅
- [x] Drift setup
- [x] Permits table
- [x] AppSettings table
- [x] CRUD operations
- [x] Encryption service

### **Phase 2: Ritual Guidance** 🔜
- [ ] Add `Duas` table
- [ ] Add `GeofenceLocations` table
- [ ] Pre-populate static data
- [ ] Location tracking service

### **Phase 3: Family Safety** 🔜
- [ ] Firebase Authentication setup
- [ ] Firestore collections
- [ ] Real-time location sync
- [ ] Distance calculation service
- [ ] Alert notification system

---

## 🔧 Why NOT Other Options:

### ❌ SharedPreferences
- Only for simple key-value pairs
- No complex queries
- No encryption
- Limited storage

### ❌ Hive
- Good for offline, but...
- No SQL queries
- Less mature than Drift
- Manual encryption

### ❌ Realm/Isar
- Overkill for this project
- Steeper learning curve
- Less Flutter ecosystem support

### ❌ Full Cloud-Only (Firestore)
- ❌ Requires internet always
- ❌ Poor performance in crowded areas
- ❌ Privacy concerns for permits

---

## 📈 Performance Considerations

### **Local Database (Drift):**
- Query time: <10ms for simple queries
- Storage: ~2-5MB for full app data
- Encryption overhead: ~5-15ms per operation

### **Cloud Database (Firestore):**
- Real-time updates: 30-second intervals (configurable)
- Offline cache: 40MB default
- Sync when online: Automatic background
- Battery impact: Moderate (location + network)

---

## ✅ Final Recommendation

**Use the CURRENT hybrid approach:**

1. **Drift/SQLite** → All offline features (permits, settings, duas, geofences)
2. **Firebase Firestore** → Only for family tracking (requires multi-device sync)
3. **SharedPreferences** → Backup for critical settings (language preference)

This architecture:
- ✅ Maximizes offline capability
- ✅ Minimizes complexity
- ✅ Leverages existing implementation
- ✅ Meets all functional requirements
- ✅ Suitable for 4-month student project

---

## 🚀 Next Steps

1. ✅ Complete permit feature with current Drift setup
2. Add `Duas` and `GeofenceLocations` tables
3. Implement Firebase Authentication
4. Set up Firestore for family tracking
5. Test offline → online sync scenarios

---

**Status:** ✅ Database architecture approved and documented  
**Date:** January 29, 2026  
**Team Decision:** Proceed with hybrid Drift + Firestore approach
