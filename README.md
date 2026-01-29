# Smart Hajj & Umrah Companion Application
## Requirements Overview - Quick Reference Guide

---

## 📱 Project Overview

**What is it?**  
A smartwatch application that enhances the Hajj and Umrah experience through AI integration and wearable technology. It provides real-time guidance, digital permit display, and family safety features.

**Core Problem:**  
Pilgrims face challenges navigating rituals, carrying physical permits, and keeping track of family members in extremely crowded holy sites.

**Our Solution:**  
A smartwatch app that:
- Displays digital permits with a wrist raise
- Automatically delivers ritual guidance (duas) based on GPS location
- Tracks children and alerts parents if they exceed safe distances
- Works offline without internet connectivity

**Target Platform:**  
WearOS 2.0+ and watchOS 6.0+ smartwatches

**Project Type:**  
Student capstone project (4-5 months development)

---

## 👥 Stakeholders

| ID | Stakeholder | Role | Primary Interest |
|----|-------------|------|------------------|
| **ST-01** | Pilgrims | End users | Easy guidance, safety, convenience |
| **ST-02** | Development Team | Builders | Successful implementation, learning |
| **ST-03** | Academic Supervisors | Evaluators | Project quality, methodology |
| **ST-04** | Parents | Family safety users | Child tracking, reliable alerts |
| **ST-05** | Holy Site Management | Authorities | Permit verification, crowd management |
| **ST-06** | Device Manufacturers | Hardware providers | App compatibility with their devices |

---

## 💼 Business Requirements

These define **WHY** we're building the system.

| ID | Requirement | Description |
|----|-------------|-------------|
| **BR-01** | Digital Permit Management | Provide digital permit display to facilitate quick verification, reducing physical document handling |
| **BR-02** | Enhanced Pilgrim Experience | Improve pilgrimage experience by providing timely, context-aware guidance for correct ritual performance |
| **BR-03** | Family Safety Assurance | Enable families to stay connected and monitor children's locations, reducing anxiety during pilgrimage |
| **BR-04** | Accessibility for All Pilgrims | Accommodate different user preferences by offering multiple modes of guidance (audio, haptic, visual) |
| **BR-05** | Cost-Effective Solution | Utilize existing consumer smartwatch devices rather than requiring specialized hardware |
| **BR-06** | Scalable Foundation | Design with modular architecture that allows for future enhancements and potential official system integration |

---

## 👤 User Requirements

These define **WHAT** users need to do.

### Permit Management (UR-01 to UR-02)

| ID | User Need |
|----|-----------|
| **UR-01** | Users shall be able to **manually enter** their Hajj/Umrah permit information (permit number, name, validity dates) into the smartwatch |
| **UR-02** | Users shall be able to **display their permit** on the smartwatch screen by raising their wrist for security verification |

### Ritual Guidance (UR-03 to UR-06)

| ID | User Need |
|----|-----------|
| **UR-03** | Users shall be able to **select ritual type** (performing for self or on behalf of someone else) |
| **UR-04** | Users shall be able to **pair optional earphones** to receive audio guidance during rituals |
| **UR-05** | Users without earphones shall **receive vibration alerts** when reaching ritual locations |
| **UR-06** | Users shall **automatically receive the appropriate dua** when GPS detects their presence at specific ritual locations |

### Family Safety (UR-07 to UR-10)

| ID | User Need |
|----|-----------|
| **UR-07** | Users shall be able to **link their smartwatch with family members' devices** to enable location sharing |
| **UR-08** | Parents shall be able to **link children's smartwatches** and set a maximum safe distance (e.g., 1 km) |
| **UR-09** | Parents shall **receive immediate alerts** when a linked child exceeds the set safe distance |
| **UR-10** | Users shall be able to **view real-time locations** of linked family members within the holy mosque premises |

---

## ⚙️ Functional Requirements

These define **HOW** the system will work (technical details).

### 1️⃣ Permit Management (FR-01 to FR-04)

| ID | System Function |
|----|-----------------|
| **FR-01** | System shall provide a form interface allowing users to input permit number (max 20 chars), full name (max 50 chars), and validity period |
| **FR-02** | System shall securely store permit information locally on the smartwatch using encrypted storage |
| **FR-03** | System shall detect wrist-raise gesture using accelerometer and display permit information within 1 second |
| **FR-04** | System shall display permit with QR code (if applicable), name, permit number, and validity dates in a clear, readable format |

### 2️⃣ Location & Guidance Services (FR-05 to FR-11)

| ID | System Function |
|----|-----------------|
| **FR-05** | System shall continuously track user location using GPS with accuracy of ±10 meters when application is active |
| **FR-06** | System shall detect when user enters predefined geofenced areas (Maqam Ibrahim, Sa'i start/end points, Tawaf area, etc.) |
| **FR-07** | System shall allow users to select ritual type (self or on behalf of others) through a toggle interface |
| **FR-08** | System shall automatically trigger appropriate dua audio playback or text display when user enters a ritual location, based on selected ritual type |
| **FR-09** | System shall play dua audio files through connected Bluetooth earphones with volume control and pause/resume functionality |
| **FR-10** | System shall generate distinct vibration patterns on the smartwatch when users reach ritual locations |
| **FR-11** | System shall display brief text notifications on smartwatch screen indicating current ritual location and required action |

### 3️⃣ Family Safety Features (FR-12 to FR-20)

| ID | System Function |
|----|-----------------|
| **FR-12** | System shall allow users to create a family group by entering unique device IDs or scanning QR codes |
| **FR-13** | System shall enable real-time location sharing among family group members when activated by group administrator |
| **FR-14** | System shall allow parents to designate specific devices as "child devices" with enhanced monitoring |
| **FR-15** | System shall allow parents to set a safe distance radius (100m to 2000m in 100m increments) for each linked child device |
| **FR-16** | System shall continuously calculate distance between parent and child devices using GPS coordinates every 30 seconds |
| **FR-17** | System shall generate an alert notification on parent's smartwatch when child device exceeds configured safe distance |
| **FR-18** | System shall display alert notifications with child's name, current distance, and last known location |
| **FR-19** | System shall display a simple map view showing relative positions of all family members within the holy mosque area |
| **FR-20** | System shall update family member locations every 30 seconds when location sharing is active |

---

## 🎯 Feature Summary Matrix

Quick reference showing what features serve which needs:

| Feature | Business Need | User Need | Key Functions |
|---------|---------------|-----------|---------------|
| **Digital Permit** | BR-01 | UR-01, UR-02 | FR-01 to FR-04 |
| **Location-Based Guidance** | BR-02, BR-04 | UR-03, UR-06 | FR-05 to FR-08 |
| **Audio/Haptic Feedback** | BR-02, BR-04 | UR-04, UR-05 | FR-09 to FR-11 |
| **Family Tracking** | BR-03 | UR-07, UR-10 | FR-12, FR-13, FR-19, FR-20 |
| **Child Safety Alerts** | BR-03 | UR-08, UR-09 | FR-14 to FR-18 |

---

## 🔑 Key Design Decisions

**Why Smartwatch?**
- Hands-free operation during rituals
- Always visible with wrist raise
- More convenient than phone in crowds

**Why Offline-First?**
- Holy sites have poor/congested cellular networks
- Core features must work without internet
- GPS provides location without network

**Why Manual Permit Entry?**
- No official Nusuk API access available
- Student project constraints
- Still provides value through easy display

**Why 30-Second Location Updates?**
- Balance between real-time awareness and battery life
- Sufficient for family tracking in slow-moving crowds
- Reduces GPS power consumption

**Why Multiple Guidance Modes?**
- Audio: Best experience but requires earphones
- Haptic: Privacy and situational awareness
- Visual: Backup when others unavailable
- Accommodates different user preferences

---

## 📊 Requirements by Priority

### Must Have (MVP)
- ✅ Manual permit entry and display
- ✅ GPS-based location tracking
- ✅ Basic geofence detection for 5-10 key locations
- ✅ Haptic vibration notifications
- ✅ Single child tracking with distance alerts
- ✅ Basic family location map

### Should Have
- ✅ Audio guidance via Bluetooth earphones
- ✅ Multiple children tracking
- ✅ Ritual type selection (self vs. on behalf)
- ✅ Complete set of duas for all ritual stages
- ✅ Gesture-based permit display

### Could Have
- ⚪ Arabic and English language support
- ⚪ Location history tracking
- ⚪ Prayer times integration
- ⚪ Customizable safe distance per child
- ⚪ Visual dua text display

### Won't Have (Out of Scope)
- ❌ Official Nusuk API integration
- ❌ Cloud synchronization
- ❌ Social networking features
- ❌ Advanced AI recommendations
- ❌ Augmented reality features

---

## 🚀 Quick Implementation Checklist

For each requirement area:

**✅ Permit Management**
- [ ] Database table for permits
- [ ] Input form UI
- [ ] Wrist-raise gesture detection
- [ ] Display screen with QR code
- [ ] Encrypted local storage

**✅ Guidance System**
- [ ] GPS location service
- [ ] Geofence definitions (coordinates + radius)
- [ ] Dua library (database table)
- [ ] Audio playback controller
- [ ] Bluetooth connection manager
- [ ] Haptic feedback controller
- [ ] Notification display system

**✅ Family Safety**
- [ ] Family group database tables
- [ ] Device linking mechanism
- [ ] Location sharing protocol
- [ ] Distance calculation algorithm
- [ ] Alert generation system
- [ ] Map view UI
- [ ] Real-time location updates

---

## 📝 Testing Requirements Summary

Each requirement must be verified:

| Requirement Type | Testing Method | Success Criteria |
|------------------|----------------|------------------|
| **Permit Display** | Manual testing on device | Display appears within 1 second of wrist raise |
| **GPS Accuracy** | Field testing with known coordinates | ±10m accuracy in 90% of readings |
| **Geofence Triggers** | Simulated location testing | Correct dua triggered when entering area |
| **Audio Playback** | Bluetooth device testing | Clear audio without distortion |
| **Distance Calculation** | Automated testing with GPS coordinates | Accurate within ±20m |
| **Alert Delivery** | Distance violation simulation | Alert received within 5 seconds |

---

## 🔗 Traceability Quick Reference

| BR → UR → FR Flow |
|-------------------|
| BR-01 (Digital Permit) → UR-01, UR-02 → FR-01 to FR-04 |
| BR-02 (Enhanced Experience) → UR-03, UR-04, UR-05, UR-06 → FR-05 to FR-11 |
| BR-03 (Family Safety) → UR-07, UR-08, UR-09, UR-10 → FR-12 to FR-20 |
| BR-04 (Accessibility) → UR-04, UR-05 → FR-09, FR-10, FR-11 |
| BR-05 (Cost-Effective) → All URs → All FRs |
| BR-06 (Scalable) → All URs → Modular architecture |

---

## 📞 Quick Contact & Resources

**Team Lead:** Shumukh AlFalah  
**Requirements Owner:** Zainab Alawami  
**Architecture Owner:** Yasmine Alhoshani  
**Database Owner:** Hajar Alshammari  

**Project Repository:** [GitHub Link]  
**Documentation:** [Google Drive Link]  
**Task Board:** [Trello/Jira Link]

---

## 🎓 Academic Context

**Course:** [Course Name/Number]  
**Institution:** [University Name]  
**Semester:** [Current Semester]  
**Supervisor:** [Supervisor Name]  
**Duration:** 18 weeks (4.5 months)  
**Team Size:** 4 members

---

**Last Updated:** [Date]  
**Document Version:** 1.0  
**Status:** Requirements Approved ✅

---

*This is a quick reference guide. For complete detailed requirements specification, refer to the full IEEE SRS document.*