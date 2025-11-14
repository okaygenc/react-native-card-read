export interface ScannedCard {
    number: string;
    expiryMonth?: string;
    expiryYear?: string;
    holderName?: string;
}
export interface ScanOptions {
    enableExpiryExtraction?: boolean;
    enableNameExtraction?: boolean;
    /** Custom title text displayed in the header center. Default: "Scan the Credit Card" */
    headerTitle?: string;
    /** Custom instruction text displayed below the card frame. Default: "Hold your card inside the frame" */
    instructionText?: string;
    /** Show flash/torch button in the top-right corner. Default: false */
    showFlashButton?: boolean;
}
export declare function scanCard(options?: ScanOptions): Promise<ScannedCard | null>;
declare const _default: {
    scanCard: typeof scanCard;
};
export default _default;
//# sourceMappingURL=index.d.ts.map