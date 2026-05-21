# HCE ERP - Academic Portal Feature Documentation

## Overview
Comprehensive Academic Portal Module for Hindu College of Engineering (HCE) to manage:
- Student Attendance Tracking & Criteria
- Fee Management & Status
- Class Teacher Assignment & Management
- Exemption Management (Medical, Sports, Special Cases)
- Automated Notifications & Alerts

---

## 1. ATTENDANCE MANAGEMENT SYSTEM

### 1.1 Attendance Tracking Structure
```json
{
  "collection": "attendance",
  "document": {
    "id": "auto-generated",
    "branch": "CSE",
    "semester": "3rd",
    "subject": "Data Structures",
    "date": "2024-05-20",
    "period": "1st Period",
    "facultyId": "uid",
    "facultyName": "Dr. Sharma",
    "records": [
      {
        "rollNo": "CSE2024001",
        "studentId": "uid",
        "name": "Raj Kumar",
        "status": "present|absent|holiday|leave",
        "remarks": "Optional remarks"
      }
    ],
    "createdAt": "timestamp",
    "updatedAt": "timestamp"
  }
}
```

### 1.2 Attendance Percentage Calculation
- **Formula**: (Present Days / Total Working Days) × 100
- **Default Threshold**: 75% (configurable per branch)
- **Categories**:
  - `present` - Student marked present
  - `absent` - Unmarked/defaulter
  - `holiday` - National/college holiday
  - `leave` - Exempted/on approved leave
  - `sick_leave` - Medical exemption

### 1.3 Attendance Rules & Criteria

#### Global Rules:
| Rule | Condition | Action |
|------|-----------|--------|
| Regular | ≥ 75% | Eligible for exams |
| Warning | 65-74% | Advisory notice to HOD |
| Defaulter | < 65% | Not eligible to appear in exams |
| Medical Leave | Approved | Excluded from calculation |
| Sports/Cultural | Approved | Partial credit (50%) |

#### Branch-wise Override:
- **CSE/AIML**: 75% (strict policy)
- **ECE/EE**: 75% (standard)
- **Mechanical/Civil**: 70% (relaxed)
- **Diploma Programs**: 70% (practical focus)
- **M.Tech**: 80% (postgraduate standard)

---

## 2. FEE MANAGEMENT SYSTEM

### 2.1 Fee Structure Database
```json
{
  "collection": "fees",
  "document": {
    "id": "auto-generated",
    "studentId": "uid",
    "rollNo": "CSE2024001",
    "name": "Raj Kumar",
    "branch": "CSE",
    "semester": "3rd",
    "academicYear": "2024-25",
    "feeStructure": {
      "tuitionFee": 50000,
      "labFee": 5000,
      "libraryFee": 2000,
      "sportsFee": 1000,
      "miscellaneousFee": 2000,
      "totalDue": 60000
    },
    "payments": [
      {
        "transactionId": "TXN001",
        "amount": 30000,
        "date": "2024-05-10",
        "method": "bank_transfer|online|check|cash",
        "status": "completed|pending|failed",
        "remarks": "Semester fee advance"
      }
    ],
    "totalPaid": 30000,
    "outstandingAmount": 30000,
    "status": "partial|full|dues_pending",
    "exemptions": [
      {
        "type": "scholarship|financial_hardship|sports_quota",
        "amount": 5000,
        "approvedBy": "HOD_uid",
        "approvedDate": "timestamp"
      }
    ],
    "createdAt": "timestamp",
    "dueDate": "2024-07-31"
  }
}
```

### 2.2 Fee Exemption Criteria

#### Scholarship-Based:
- **Merit Scholarship**: Top 5% students → 25% waiver
- **Sports Quota**: Represent college → Full fee + stipend
- **NCC/NSS**: Active participants → 10% waiver
- **Staff Ward**: → 50% waiver
- **EWS Category**: → 25% waiver

#### Hardship-Based:
- **BPL Status**: → Full waiver (with certificate)
- **Single Parent**: → 25% waiver
- **Orphan**: → Full waiver
- **Differently Abled**: → 25% waiver
- **Flood/Natural Calamity**: → 50% waiver (temporary)

#### Conditions:
- **Academic Performance**: Minimum 50% aggregate
- **Attendance**: Minimum 65%
- **Good Conduct**: No disciplinary action
- **Verification**: Documents required within 30 days

### 2.3 Fee Status Alerts
```
RED ALERT: Outstanding amount > 50% (Exam eligibility at risk)
YELLOW ALERT: Outstanding amount 25-50% (Installment reminder)
GREEN: Fully paid or exempted
```

---

## 3. CLASS TEACHER ASSIGNMENT SYSTEM

### 3.1 Class Teacher Database
```json
{
  "collection": "classTeachers",
  "document": {
    "id": "auto-generated",
    "facultyId": "uid",
    "facultyName": "Dr. Priya Sharma",
    "designation": "Assistant Professor",
    "department": "Computer Science",
    "assignedBranch": "CSE",
    "assignedSemester": "3rd",
    "assignedSection": "A",
    "academicYear": "2024-25",
    "studentCount": 60,
    "studentList": [
      {
        "rollNo": "CSE2024001",
        "studentId": "uid",
        "name": "Raj Kumar",
        "mobileContact": "98765XXXXX",
        "fatherMobile": "98765XXXXX",
        "status": "active|inactive|transferred"
      }
    ],
    "responsibilities": [
      "attendance_monitoring",
      "academic_guidance",
      "disciplinary_oversight",
      "parent_communication",
      "placement_coordination"
    ],
    "officeHours": {
      "day": "Monday",
      "time": "2:00 PM - 3:00 PM",
      "location": "Room 205"
    },
    "assignedDate": "2024-05-01",
    "assignedBy": "HOD_uid",
    "status": "active|relieved",
    "createdAt": "timestamp"
  }
}
```

### 3.2 Class Teacher Responsibilities
1. **Attendance Monitoring**: Weekly attendance review
2. **Academic Guidance**: Performance counseling
3. **Disciplinary Action**: Conduct assessment
4. **Parent Communication**: Monthly contact
5. **Placement Coordination**: Company interactions
6. **Exemption Approval**: Preliminary review
7. **Leave Management**: Casual/medical leave approvals

### 3.3 Assignment Logic
```javascript
// Automatic Assignment Algorithm
1. Get unfilled sections for semester
2. For each section:
   - Find faculty with <= 100 current assignments
   - Prioritize faculty from same department
   - Balance workload (±5 students per faculty)
   - Avoid same person for consecutive semesters
3. Confirm with HOD
4. Generate assignment letter
5. Notify faculty & students
```

---

## 4. EXEMPTION MANAGEMENT SYSTEM

### 4.1 Exemption Types & Criteria

#### A. MEDICAL EXEMPTION
```json
{
  "type": "medical",
  "criteria": {
    "minDocuments": ["medical_certificate", "hospital_receipt"],
    "maxDuration": "14 days per semester",
    "requiresApproval": ["classTeacher", "HOD"],
    "attendanceImpact": "excluded_from_calculation",
    "allowedReasons": [
      "hospitalization",
      "surgery",
      "chronic_illness",
      "COVID-19",
      "disability_related"
    ]
  },
  "approval_workflow": {
    "step1": "Student uploads documents",
    "step2": "Class Teacher verifies (2 days)",
    "step3": "HOD approves (1 day)",
    "step4": "Academic records attendance as 'leave'",
    "step5": "System excludes from attendance calculation"
  }
}
```

#### B. SPORTS/CULTURAL EXEMPTION
```json
{
  "type": "sports_cultural",
  "criteria": {
    "minDocuments": ["permission_letter", "event_certificate"],
    "maxDuration": "4 days per semester",
    "requiresApproval": ["classTeacher", "sports_coordinator", "HOD"],
    "attendanceImpact": "counted_as_present",
    "allowedEvents": [
      "state_level_competition",
      "national_tournament",
      "college_event_representation",
      "inter_college_meet"
    ]
  },
  "condition": "Must maintain 75% in other subjects"
}
```

#### C. OFFICIAL DUTY EXEMPTION
```json
{
  "type": "official_duty",
  "criteria": {
    "minDocuments": ["official_letter", "attendance_sheet"],
    "examples": [
      "NCC_camp",
      "NSS_activity",
      "college_fest_coordination",
      "academic_conference",
      "industry_visit"
    ],
    "attendanceImpact": "counted_as_present",
    "requiresApproval": ["faculty_incharge", "HOD"]
  }
}
```

#### D. FAMILY/EMERGENCY EXEMPTION
```json
{
  "type": "emergency",
  "criteria": {
    "maxDuration": "5 days per semester",
    "maxPerYear": "10 days",
    "requiresApproval": ["classTeacher", "HOD"],
    "attendanceImpact": "counted_as_leave",
    "allowedReasons": [
      "death_in_family",
      "serious_accident",
      "natural_calamity",
      "father_hospitalization",
      "mother_critical_illness"
    ]
  },
  "condition": "Requires supporting documentation"
}
```

### 4.2 Exemption Request Workflow

```
┌─────────────────────────────────────────────────┐
│ STUDENT SUBMITS REQUEST                         │
│ - Reason category                               │
│ - From & To dates                               │
│ - Upload supporting documents                   │
│ - Fill description                              │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ CLASS TEACHER REVIEW (48 hours)                 │
│ - Verify documents                              │
│ - Check attendance impact                       │
│ - Approve/Reject with remarks                   │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ HOD FINAL APPROVAL (24 hours)                   │
│ - Cross-check with criteria                     │
│ - Approve or send back for revision             │
│ - Generate exemption certificate                │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ ACADEMIC SYSTEM UPDATE                          │
│ - Mark attendance as 'leave'/'present'          │
│ - Recalculate attendance %                      │
│ - Send notification to student & faculty       │
│ - Archive exemption request                     │
└─────────────────────────────────────────────────┘
```

### 4.3 Exemption Database Schema
```json
{
  "collection": "exemptions",
  "document": {
    "id": "auto-generated",
    "studentId": "uid",
    "rollNo": "CSE2024001",
    "studentName": "Raj Kumar",
    "branch": "CSE",
    "semester": "3rd",
    "type": "medical|sports|official|emergency",
    "subject": "Data Structures",
    "fromDate": "2024-05-15",
    "toDate": "2024-05-18",
    "reason": "Detailed reason text",
    "documents": [
      {
        "type": "certificate|letter|receipt",
        "url": "storage/path",
        "uploadedDate": "timestamp"
      }
    ],
    "status": "pending|approved|rejected",
    "workflow": {
      "classTeacher": {
        "reviewed": true,
        "reviewedBy": "teacher_uid",
        "reviewedDate": "timestamp",
        "remarks": "Documents verified",
        "decision": "approved"
      },
      "hod": {
        "reviewed": true,
        "reviewedBy": "hod_uid",
        "approvedDate": "timestamp",
        "remarks": "Approved as per policy",
        "decision": "approved"
      }
    },
    "attendanceImpact": {
      "excluded": true,
      "applicableToSubjects": ["Data Structures"],
      "recalculatedPercentage": 76.5
    },
    "createdAt": "timestamp",
    "expiryDate": "2024-05-18"
  }
}
```

---

## 5. AUTOMATIC ALERTS & NOTIFICATIONS SYSTEM

### 5.1 Alert Types

| Alert Type | Trigger | Recipient | Action |
|------------|---------|-----------|--------|
| **Attendance Warning** | < 70% | Student, Class Teacher | Counseling session required |
| **Exam Eligibility Risk** | < 65% attendance | Student, HOD, Academic | Cannot appear in exams |
| **Fee Outstanding** | Dues > 50% | Student, Class Teacher | Cannot appear in exams |
| **Exemption Expiry** | 1 day before expiry | Student, Faculty | Attendance tracking resumes |
| **Medical Certificate Expiry** | 30 days pending | Student, HOD | Request renewal of documents |
| **Marks Low** | < 40% in exam | Student, Class Teacher | Academic support needed |
| **Poor Performance** | GPA < 2.0 | Student, HOD | Probation status |

### 5.2 Notification Channels
- **In-App Notifications**: Real-time alerts
- **Email**: Official mail to college email
- **SMS**: Critical alerts (opt-in)
- **Dashboard**: Summary in student portal
- **Parent Portal**: Select notifications for parents

---

## 6. REPORTS & ANALYTICS

### 6.1 Academic Portal Reports

#### A. Student-Wise Report
```
- Roll No, Name, Branch, Semester
- Current Attendance: X/Y (Z%)
- Status: Regular/Warning/Defaulter
- Fee Status: Paid/Partial/Outstanding
- Class Teacher: Name
- Exemptions Availed: Count & Details
- Exam Eligibility: Yes/No
```

#### B. Class-Wise Report
```
- Total Students: 60
- Average Attendance: 76.3%
- Defaulters: 8 students
- Fee Collection Rate: 85%
- Outstanding Amount: ₹2,50,000
- Exemptions Approved: 12
- Class Teacher: Name & Contact
```

#### C. Branch-Wise Analytics
```
- Total Enrollment: 450
- Average Attendance: 74.8%
- Attendance Status Distribution:
  * Regular (≥75%): 380 students
  * Warning (65-74%): 55 students
  * Defaulters (<65%): 15 students
- Fee Collection: ₹42,50,000 / ₹50,00,000
- Exemptions by Type: Medical (45), Sports (28), Official (35)
```

#### D. Exemption Analytics
```
- Total Requests: 108
- Approved: 95 (87.96%)
- Rejected: 8 (7.41%)
- Pending: 5 (4.63%)
- Average Processing Time: 2.3 days
- By Type:
  * Medical: 45 (44%)
  * Sports: 28 (26%)
  * Official: 25 (23%)
  * Emergency: 10 (9%)
```

---

## 7. FIRESTORE RULES (Security)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Attendance Collection
    match /attendance/{id} {
      allow read: if request.auth != null;
      allow create: if hasRole('faculty', 'hod', 'academic', 'admin');
      allow update: if hasRole('hod', 'academic', 'admin');
      allow delete: if hasRole('admin');
    }
    
    // Fees Collection
    match /fees/{id} {
      allow read: if request.auth.uid == resource.data.studentId || hasRole('hod', 'academic', 'admin');
      allow create: if hasRole('academic', 'admin');
      allow update: if hasRole('academic', 'admin');
    }
    
    // Class Teachers
    match /classTeachers/{id} {
      allow read: if request.auth != null;
      allow write: if hasRole('hod', 'academic', 'admin');
    }
    
    // Exemptions
    match /exemptions/{id} {
      allow read: if request.auth.uid == resource.data.studentId || hasRole('faculty', 'hod', 'academic', 'admin');
      allow create: if request.auth.uid == request.resource.data.studentId;
      allow update: if hasRole('faculty', 'hod', 'academic', 'admin');
    }
    
    // Helper function
    function hasRole(roles) {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in roles;
    }
  }
}
```

---

## 8. IMPLEMENTATION CHECKLIST

- [ ] Create Firestore collections (attendance, fees, classTeachers, exemptions)
- [ ] Build attendance marking UI for faculty
- [ ] Implement attendance percentage calculation algorithm
- [ ] Create fee slip generation system
- [ ] Build exemption request form & workflow
- [ ] Implement class teacher assignment logic
- [ ] Set up automated alert system
- [ ] Create all reports & dashboards
- [ ] Configure email/SMS notifications
- [ ] Set up parent portal (read-only)
- [ ] Create admin configuration panel
- [ ] Write and deploy Firestore security rules
- [ ] Test all workflows end-to-end
- [ ] Deploy to production
- [ ] Train faculty & students

---

## 9. KEY FEATURES SUMMARY

✅ **Attendance Management**: Real-time tracking, branch-wise thresholds, automatic alerts
✅ **Fee Management**: Structured fees, exemption criteria, payment tracking
✅ **Class Teacher Assignment**: Automated logic, responsibility management, notification system
✅ **Exemption System**: Medical, Sports, Official, Emergency with multi-level approval
✅ **Automated Alerts**: Attendance warnings, fee reminders, exam eligibility status
✅ **Comprehensive Reports**: Student, class, branch, exemption analytics
✅ **Secure Access Control**: Role-based Firestore rules
✅ **Parent Communication**: Portal access for viewing student progress

---

**Last Updated**: May 21, 2026
**Version**: 1.0
**Prepared For**: Hindu College of Engineering, Sonipat
