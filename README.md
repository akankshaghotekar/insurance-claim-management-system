# Insurance Claim Management System (Flutter)

A Flutter-based application for managing **hospital insurance claims**, built as part of a technical assignment for a Flutter Intern role.

The app allows hospitals or insurance desks to **create, track, and manage insurance claims**, including bills, advances, settlements, pending amounts, and claim status workflows.

---

## Features

### Claim Management
- Create a new insurance claim with patient, insurance, and hospital details
- Save claims as **Draft**
- Submit claims for processing
- Update claim status:
  - Draft
  - Submitted
  - Approved
  - Partially Settled
  - Rejected

---

### Bill Management
- Add multiple bills to a claim
- Edit existing bills
- Delete bills with confirmation
- Bill categories:
  - Room
  - Medicine
  - Lab
  - Surgery
  - Consultation
- Mandatory validation for:
  - Bill date
  - Positive bill amount

---

### Automatic Calculations
- **Total Bill Amount**
- **Pending Amount**
- **Refund Amount** (shown only when advance + settlement exceeds total bill)

All calculations are handled using computed properties in the model layer.

---

### Dashboard
- View all claims in a tabular dashboard
- Search claims by:
  - Patient name
  - Contact number
  - Claim status
  - Serial number
- Color-coded claim status indicators
- Quick access to:
  - View claim details
  - Edit claim status and settlement

---

### Local Persistence
- Claims are stored locally using **SharedPreferences**
- Data remains available after app restart (demo purpose)

---

## Architecture & Tech Stack

- **Flutter**
- **Provider** (State Management)
- **SharedPreferences** (Local storage)
- Clean separation of:
  - Models
  - Providers
  - Screens
  - Widgets




