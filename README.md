Hotel Room Booking App

A production-grade, single-page Flutter application built using **Clean Architecture**, senior developer standards for code reusability, robust date validation, live price calculations, and a modern UI.

Features

- Clean Architecture**: Decoupled `domain`, `data`, `presentation`, and `core` layers.
- Sample Room Dataset**:
  - `R101` & `R102`: Deluxe Room (₹3,500/night, Max 2 guests)
  - `R201` & `R202`: Executive Suite (₹5,800/night, Max 3 guests)
  - `R301`: Family Room (₹4,200/night, Max 4 guests)
- Live Calculations & Validation**:
  - Live computation of nights (`checkOut - checkIn`) and total stay price (`nights × price_per_night`).
  - Strict date validation: check-in cannot be in the past, and check-out must be strictly after check-in.
  - Clear inline error banner messages for invalid input combinations.
- Bonus Features**:
  - Existing Booking Collisions**: Prevents selecting rooms that are already booked for chosen dates with a visual `BOOKED` badge.
  - Guest Count Filter**: Interactive filter bar for 1, 2, 3, or 4 guests.
  - Automated Unit Tests**: 100% domain logic test coverage for calculation and date validation edge cases.

Folder Structure

```
lib/
├── core/
│   ├── failure/          # ValidationFailure hierarchy
│   ├── theme/            # Color tokens, Typography & ThemeData
│   └── utils/            # Date & INR Currency formatters
└── features/
    └── hotel_booking/
        ├── domain/       # Entities, Repositories, Use Cases (CalculateBookingUseCase, GetHotelRoomsUseCase)
        ├── data/         # Models, Local Data Source, Repository Impl
        └── presentation/ # State Controller, Pages, Widgets (RoomCard, DateSelectionCard, BookingSummaryCard)
```

Running Tests

To run the unit and widget test suite:

```bash
flutter test
```

---

## Running the App

To launch the app locally:

```bash
flutter run
```
