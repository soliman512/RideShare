# RideShare 🚗

**Share the ride. Split the cost.**

A carpool platform connecting drivers and riders on shared routes in Cairo, Egypt. Riders board along a driver's route and pay a distance-based fare; the platform takes a 10% commission on every ride.

Built with **Flutter** (frontend) and **Supabase** (backend: PostgreSQL + PostGIS + Auth + Storage).

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Pricing Model](#pricing-model)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Approving a Driver (Admin)](#approving-a-driver-admin)
- [Roadmap](#roadmap)
- [Known Issues](#known-issues)

---

## Overview

Daily commuters in Cairo spend significant money on fuel, tolls, and car maintenance, while public transport is often overcrowded or unavailable for specific routes. RideShare lets drivers offer seats on their daily commute and split the cost with riders traveling along the same route, using real road-distance fare splitting rather than flat pricing.

## Key Features

- **Distance-based fare splitting** — riders farther from the destination pay more, closer riders pay less; all individual fares always sum exactly to the total ride price.
- **One pickup stop = one seat** — each stop becomes unavailable once booked, and available again if the booking is cancelled.
- **Real road distances** — via the Geoapify Routing API, not straight-line estimates (with a straight-line × 1.3 fallback if the API call fails).
- **Driver identity verification** — National ID card + criminal record clearance required before a driver is approved.
- **Single account, dual role** — every user can toggle between Rider mode and Driver mode.
- **Address autocomplete** — Geoapify-powered, Egypt-biased search for all location inputs.
- **Passwordless auth** — email OTP via Supabase Auth.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3.x (Dart) — single codebase for iOS & Android |
| Backend | Supabase — PostgreSQL + PostGIS + Auth + Storage |
| Authentication | Supabase Auth — Email OTP (passwordless) |
| Address Search | Geoapify Autocomplete API |
| Road Distances | Geoapify Routing API |
| GPS Location | `geolocator` package |
| State Management | Provider (`ChangeNotifier`, one provider per feature/domain) |
| OTP Delivery | Custom SMTP via Resend.com (recommended for production) |
| File Upload | Supabase Storage — `driver-documents` bucket |

**Key Flutter packages:** `supabase_flutter`, `provider`, `geolocator`, `http`, `image_picker`, `google_fonts`, `flutter_secure_storage`, `intl`.

## Architecture

```
Flutter App (Frontend)  <──REST + WS──>  Supabase (Backend)  <──>  PostgreSQL + PostGIS
        │                                       │
        │                                       ├── Auth (Email OTP)
        │                                       ├── RPC Functions (search_rides, book_ride, ...)
        │                                       └── Storage (driver-documents)
        │
        ├──> Geoapify (Autocomplete + Routing)
        └──> Device GPS
```

The app is organized in layers (not feature-first / not full Clean Architecture — chosen for the current project size):

- **Presentation** — `screens/`, `widgets/`
- **State** — `providers/` (one `ChangeNotifier` per domain: `AuthProvider`, and later `RideSearchProvider`, `DriverRidesProvider`)
- **Data** — `services/` (stateless: `SupabaseService`, `LocationService`)
- **Domain models** — `models/` (one file per model)

## Pricing Model

Constants are hardcoded in the app and never shown to users:

```
PRICE_PER_KM        = 5.0 EGP
PLATFORM_COMMISSION = 10%
DRIVER_SHARE         = 90%
```

**Total ride value:**

```
total_route_km  = road distance from the FURTHEST pickup stop to the destination
total_price     = total_route_km × PRICE_PER_KM
driver_earns    = total_price × 0.90
platform_earns  = total_price × 0.10
```

**Per-rider fare (proportional split):**

```
sum_ratios = Σ (stop_km / total_route_km)  for all stops
my_fare    = total_price × (my_stop_km / total_route_km) / sum_ratios
```

Prices are fixed once a ride is created — they do not change as riders book or cancel.

<details>
<summary>Worked example (61 km route, 3 stops)</summary>

| Item | Calculation | Result |
|---|---|---|
| Total price | 61 × 5 EGP | 305.00 EGP |
| Driver earns | 305 × 90% | 274.50 EGP |
| Platform earns | 305 × 10% | 30.50 EGP |
| sum_ratios | (61+50+45)/61 | 2.557 |
| Rider 1 fare (61 km) | 305 × (61/61) / 2.557 | 119.28 EGP |
| Rider 2 fare (50 km) | 305 × (50/61) / 2.557 | 97.77 EGP |
| Rider 3 fare (45 km) | 305 × (45/61) / 2.557 | 87.95 EGP |
| **Total collected** | | **305.00 EGP** ✓ |

</details>

## Database Schema

PostgreSQL on Supabase with the **PostGIS** extension enabled for GPS proximity queries, and **RLS** policies so users can only access their own data.

| Table | Purpose |
|---|---|
| `users` | Core profile: name, email, phone, `current_mode` (rider/driver), rating |
| `driver_profiles` | Verification docs, approval status, driver rating |
| `vehicles` | Plate, make, model, color, year, linked to a driver |
| `rides` | Destination, departure time, seats, `total_route_km`, status |
| `pickup_points` | One row per stop; ordered, with distance to destination |
| `bookings` | A rider's reservation of a specific pickup point on a ride |
| `reviews` | Post-ride ratings between driver and rider |
| `notifications` | In-app notifications (booking confirmed, ride cancelled, etc.) |

**Key RPC functions:** `search_rides`, `book_ride`, `cancel_booking`, `complete_ride`, `cancel_ride`, `get_ride_details`, `get_rider_bookings`, `get_driver_rides`, `switch_mode`, `register_driver`, `mark_notifications_read`.

## Project Structure

```
rideshare_flutter/
  lib/
    main.dart
    constants/
      app_constants.dart
      api_constants.dart
      app_routes.dart
    theme/
      app_theme.dart
    routing/
      app_router.dart
    providers/
      auth_provider.dart
    models/
      user_model.dart
      driver_profile_model.dart
      vehicle_model.dart
      ride_model.dart
      pickup_point_model.dart
      booking_model.dart
      review_model.dart
      notification_model.dart
    services/
      supabase_service.dart
      location_service.dart
    widgets/
      app_button.dart
      app_text_field.dart
      app_card.dart
      user_avatar.dart
      status_chip.dart
      empty_state.dart
      address_search_field.dart
    screens/
      main_scaffold.dart
      auth/
        login_screen.dart
        verify_otp_screen.dart
        profile_setup_screen.dart
      rider/
        rider_home_screen.dart
        ride_detail_screen.dart
        my_trips_screen.dart
      driver/
        driver_home_screen.dart
        create_ride_screen.dart
      shared/
        profile_screen.dart
        notifications_screen.dart
  assets/
    images/
    fonts/
  .env
  .gitignore
  pubspec.yaml
```

> API keys and secrets (Supabase URL, Geoapify key) are **not** hardcoded — they're loaded via `--dart-define` or `flutter_dotenv` with `.env` excluded from version control.

## Getting Started

### Prerequisites

- Flutter 3.x
- Xcode (for iOS builds)
- Android Studio (for Android builds)
- A Supabase project with PostGIS enabled

### Setup

```bash
git clone <this-repo-url>
cd rideshare_flutter
flutter pub get
```

### Run

```bash
flutter run              # auto-detects connected device
flutter run -d chrome    # quick testing in the browser
```

## Environment Variables

Create a `.env` file at the project root (kept out of version control):

```
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEOAPIFY_API_KEY=your_geoapify_api_key
```

## Approving a Driver (Admin)

There is currently no admin UI — approvals are done manually via the Supabase SQL Editor:

```sql
UPDATE public.driver_profiles
SET approval_status = 'approved', approved_at = NOW()
WHERE approval_status = 'under_review';
```

## Roadmap

**High priority**
- [ ] Payment gateway (Fawry / Paymob) for real EGP payments
- [ ] Push notifications via Firebase Cloud Messaging
- [ ] Admin dashboard (web) for driver approvals, ride management, analytics
- [ ] Post-ride reviews UI (schema already exists)
- [ ] Map view for pickup stops in Ride Detail

**Medium priority**
- [ ] In-app chat (driver ↔ passenger) via Supabase Realtime
- [ ] Live ride tracking on map
- [ ] Recurring rides (daily/weekly schedules)
- [ ] Shareable deep links for rides
- [ ] Arabic language support (RTL)
- [ ] Ride search history

**Infrastructure**
- [ ] Configure Resend.com SMTP in Supabase to remove the free-tier 3/hour OTP limit
- [ ] Tighten RLS policies before production launch
- [ ] Enable Supabase Realtime on the `bookings` table
- [ ] Server-side pricing validation via Supabase Edge Functions

## Known Issues

| Issue | Fix |
|---|---|
| OTP limited to 3/hour on Supabase free tier | Configure custom SMTP via Resend.com under Supabase → Auth → SMTP |
| `search_rides` RPC needs an update | Run `search_rides_fix.sql` in the Supabase SQL Editor to enable pickup-point-based search |
| iOS requires code signing | Open `ios/Runner.xcworkspace` in Xcode and add an Apple ID under Signing & Capabilities |
| GPS permission denied | Falls back to Cairo center (30.0444, 31.2357) |
| Geoapify free tier: 3,000 requests/day | Upgrade the plan for production, or cache frequent queries |

---

*Confidential — internal project documentation.*
