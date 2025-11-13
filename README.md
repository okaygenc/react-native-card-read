### 1. Install the npm package

```bash
npm install ../react-native-card-read
# or
yarn add ../react-native-card-read
```

### 2. Configure iOS Podfile

Add the following to your iOS app's `Podfile` to reference the local card-reader modules:

```ruby
# Path to the local card-reader fork
card_reader_path = File.expand_path('../../card-reader', __dir__)

# Add local pod dependencies
pod 'StripeCore', :path => "#{card_reader_path}"
pod 'StripeCameraCore', :path => "#{card_reader_path}"
pod 'StripeCardScan', :path => "#{card_reader_path}"

# The react-native-card-read library will be linked automatically
```

### 3. Install iOS dependencies

```bash
cd ios
pod install
cd ..
```

### 4. Add Camera Permission to Info.plist

Add the following key to your `ios/YourApp/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to scan your credit card</string>
```

## Usage

```typescript
import { scanCard } from 'react-native-card-read';

// Scan a card
const result = await scanCard({
  enableExpiryExtraction: true,
  enableNameExtraction: true,
});

if (result) {
  console.log('Card Number:', result.number);
  console.log('Expiry Month:', result.expiryMonth);
  console.log('Expiry Year:', result.expiryYear);
  console.log('Holder Name:', result.holderName);
} else {
  console.log('User canceled the scan');
}
```

## API

### `scanCard(options?: ScanOptions): Promise<ScannedCard | null>`

Opens the card scanning interface.

#### Parameters

- `options` (optional): Configuration options
  - `enableExpiryExtraction` (boolean): Enable extraction of expiry date
  - `enableNameExtraction` (boolean): Enable extraction of cardholder name

#### Returns

Returns a Promise that resolves to:
- `ScannedCard` object if scan was successful
- `null` if user canceled
- Throws an error if scanning failed

#### ScannedCard Interface

```typescript
interface ScannedCard {
  number: string;
  expiryMonth?: string;
  expiryYear?: string;
  holderName?: string;
}
```

## Development Setup

The library references the local card-reader fork. Make sure the card-reader directory is at the same level as your project:

```
Development/
  ├── card-reader/           # The forked StripeCardScan repository
  └── your-app/
      └── react-native-card-read/  # This library
```

