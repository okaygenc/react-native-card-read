import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-card-read' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- Run 'pod install' in the ios/ directory\n", default: '' }) +
  '- Rebuild the app after installing the package\n' +
  '- If you are using Expo, ensure you have run prebuild\n';

// Debug: Use console.warn so it shows in simulator Yellow Box
console.warn('[react-native-card-read] Module loading...');
console.warn('[react-native-card-read] Available native modules:', Object.keys(NativeModules));
console.warn('[react-native-card-read] CardRead module:', NativeModules.CardRead);

const CardRead = NativeModules.CardRead;

function ensureModuleLoaded() {
  if (!CardRead) {
    console.error('[react-native-card-read] ERROR:', LINKING_ERROR);
    throw new Error(LINKING_ERROR);
  }
}

export interface ScannedCard {
  number: string;
  expiryMonth?: string;
  expiryYear?: string;
  holderName?: string;
}

export interface ScanOptions {
  enableExpiryExtraction?: boolean;
  enableNameExtraction?: boolean;
}

export function scanCard(options?: ScanOptions): Promise<ScannedCard | null> {
  console.log('[react-native-card-read] scanCard() called with options:', options);
  ensureModuleLoaded();
  console.log('[react-native-card-read] Calling native CardRead.scanCard...');
  return CardRead.scanCard(options || {});
}

export default {
  scanCard,
};
