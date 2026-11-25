# RideShare

**Better Rides. Together.**

A carpooling app that connects drivers and riders heading the same way. Drivers publish rides with pickup points along their route, riders join from the point that suits them, and fares are split by distance — making daily travel cheaper and more social.

Built with Flutter and Supabase.

![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A5%203.47.4-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-%5E3.13.3-0175C2?logo=dart)
![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%C2%B7%20iOS%20%C2%B7%20Web%20%C2%B7%20Desktop-lightgrey)

---

## Features

### Authentication & Profiles
- Passwordless sign-in with a 6-digit email OTP (Supabase Auth)
- Profile setup with name, Egyptian phone-number validation, and a profile photo
- Photos are compressed client-side (WebP, capped at 300 KB) before upload
- Edit profile, change or remove avatar, sign out

### Driver Verification
- In-app application to become a driver: vehicle type, model, color, and license plate (supports Arabic-Indic numerals)
- Secure document upload: national ID, criminal record, driving license, and up to 3 vehicle photos
- Approval workflow with `under_review` / `approved` / `rejected` statuses tracked in the database
- Approved drivers can delete their application, which also cleans up stored documents

### Ride Creation (Driver Mode)
- Place search with autocomplete, localized to Egypt (Geoapify)
- Multi-stop routes: departure, destination, and unlimited pickup points along the way
- Real driving-distance calculation across the full route (Geoapify Routing)
- Live earnings preview: 5 EGP per km, minus a 10% platform fee
- Date & time pickers, available-seats selector, and driver notes

### Rider Experience
- Rider/Driver mode switch in the app bar (Driver mode unlocks after approval)
- Home screen with time-aware greeting and destination search
- Trips screen with status filters (active, completed, cancelled) and pull-to-refresh
- Notifications screen with swipe-to-dismiss
- Offline detection with a dedicated no-connection screen and retry

---

## Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | Flutter (≥ 3.47.4) |
| Language | Dart ^3.13.3 (uses Dart 3.13 primary-constructor syntax) |
| Backend | Supabase — Auth, Postgres, Storage |
| Maps & Geo | Geoapify — Autocomplete + Routing APIs |
| State Management | Provider + `ValueNotifier` |
| Key packages | `supabase_flutter`, `http`, `image_picker`, `flutter_image_compress`, `permission_handler`, `internet_connection_checker_plus`, `easy_localization`, `intl`, `timeago`, `google_fonts`, `remixicon`, `phosphor_icons`, `circle_nav_bar`, `cherry_toast`, `flutter_screenutil`, `shared_preferences`, `package_info_plus`, `device_info_plus`, `flutter_phoenix` |

### Backend schema (Supabase)

| Table | Purpose |
| --- | --- |
| `users` | Public profiles: full name, email, phone, avatar URL, rating |
| `driver_profiles` | Driver applications: document URLs, vehicle info, approval status, rating, ride count |

| Storage bucket | Contents |
| --- | --- |
| `profile-pictures` | User avatars (WebP) |
| `driver-documents` | ID card, criminal record, driving license |
| `car-images` | Vehicle photos |

---

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── core/
│   ├── constants/                 # Colors, image paths, route names, storage keys
│   ├── data/                      # ID generation, mock data
│   ├── extension/                 # BuildContext & enum helpers (screen size, keyboard, statuses)
│   ├── models/                    # User, Ride, RidePoint, DriverProfile, Vehicle, Location, Notification
│   ├── providers/                 # Auth, driver profile, loading, network, app info, current page
│   ├── services/                  # Geoapify, permissions, image compression, driver storage
│   ├── supabase_services/         # Auth, ride, and driver-profile database services
│   ├── theme/                     # App-wide ThemeData
│   ├── urils/                     # Date formatting
│   └── widgets/                   # Reusable UI (buttons, text fields, app bar, cards, sheets)
└── screens/
    ├── splash/                    # Splash with session-based routing
    ├── auth/                      # Login, OTP verification, profile setup
    ├── rider/                     # Rider home, my trips, ride details
    ├── driver/                    # Driver home, create ride
    └── shared/                    # Profile, notifications, loading, error, no-internet
```

---

## Getting Started

### Prerequisites

- **Flutter 3.47.4 or newer** (Dart 3.13.3+). The codebase uses Dart 3.13 primary constructors, so older Flutter versions will not build it.
- A [Supabase](https://supabase.com) project
- A [Geoapify](https://www.geoapify.com) API key

### Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/soliman512/RideShare.git
   cd RideShare
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Supabase**

   In your Supabase project:

   - Enable **Email OTP** under Authentication → Providers
   - Create the `users` and `driver_profiles` tables (see schema above)
   - Create the storage buckets `profile-pictures`, `driver-documents`, and `car-images`
   - Enable Row Level Security with appropriate policies

4. **Provide your credentials**

   Add your Supabase URL, Supabase anon key, and Geoapify API key where the app expects them, and never commit real keys to git. The recommended approach is `--dart-define`:

   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key \
     --dart-define=GEOAPIFY_API_KEY=your-geoapify-key
   ```

   > The Supabase **anon** key is safe to ship in a client app when Row Level Security is enabled. The **service-role** key must never be included in the app or the repository.

5. **Run**

   ```bash
   flutter run
   ```

---

## Roadmap

- [ ] Persist created rides to the database (rides + stop points)
- [ ] Ride search and seat booking for riders
- [ ] Ride details screen with driver, vehicle, and stop information
- [ ] Trip lifecycle management (in progress, completed, cancelled)
- [ ] Real-time notifications backed by the database
- [ ] Driver and rider ratings
- [ ] Arabic localization (`easy_localization` is already integrated)

---

## License

No license has been specified yet. All rights reserved by the repository owner until one is chosen.
