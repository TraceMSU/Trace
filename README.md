# README
# T.R.A.C.E.

**T.R.A.C.E.** (Teaching Responsible And Conscious Expenditures) is an **Android-only** Flutter application backed by a Rails API. It allows users to search a curated dataset of products (e.g., cereals) and view ownership details in a visual "heap" format.

---

## Features

- **Instant search suggestions** powered by Excel/CSV data
- **Full-text search** returning ownership details grouped by brand, owner, and ownership type
- **Visual result display** using a hierarchical heap chart
- **Recent search history** stored locally on the device

---

## Architecture

1. **Frontend**: Flutter Android app (uses `flutter_typeahead` for live suggestions)
2. **Backend**: Rails API hosted on Heroku (provides `/ping`, `/suggestions`, and `/search` endpoints)
3. **Data**: A local Excel/CSV file (`lib/data/testdata.xls`) parsed via `roo` in Rails

---

## Installation (Android Only)

### 1. Scan the QR Code

Scan the QR code below with your Android device to download and install the APK directly.

![QR Code](path/to/qr-code.png)

### 2. Visit the Download Page

Open this URL on your Android device's browser and follow the prompts:

```
https://tracemsu.github.io/Trace/
```

> **Note:** Be sure to enable "Install unknown apps" or "Allow from this source" in your device settings to install the APK.

---

## Usage

1. Launch the T.R.A.C.E. app on your Android device.
2. Use the search bar to type a product name; live suggestions will appear.
3. Select a suggestion or hit **Search** to view the heap visualization and details.
4. Access recent searches via the **History** tab.

---

## Development

### Running the Backend Locally

```bash
# Clone the Rails API
git clone https://github.com/TraceMSU/Trace.git
cd Trace

# Install dependencies
bundle install

# Set up credentials
cp config/master.key.example config/master.key
# Add any ENV vars (e.g., NEO4J_URL, RAILS_MASTER_KEY)

# Start the server
rails server
```

Endpoints:
- `GET /ping` → returns `pong`
- `GET /suggestions?q=<term>` → returns live suggestions
- `GET /search?q=<term>` → returns full search results

### Running the Flutter App

```bash
# From the Flutter project root
flutter pub get
flutter run --release  # on an Android device or emulator
```

---

## Contributing

Contributions are welcome! Please open issues and submit pull requests on the [GitHub repository](https://github.com/TraceMSU/Trace).

---

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.

