package com.cardread

import android.app.Activity
import android.content.Intent
import com.facebook.react.bridge.*
import com.stripe.android.stripecardscan.cardscan.CardScanSheet
import com.stripe.android.stripecardscan.cardscan.CardScanSheetResult
import com.stripe.android.stripecardscan.cardscan.CardScanConfiguration

class CardReadModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var scanCardPromise: Promise? = null
    private var cardScanSheet: CardScanSheet? = null

    override fun getName(): String {
        return "CardRead"
    }

    @ReactMethod
    fun scanCard(options: ReadableMap?, promise: Promise) {
        val currentActivity = currentActivity

        if (currentActivity == null) {
            promise.reject("NO_ACTIVITY", "Activity doesn't exist")
            return
        }

        scanCardPromise = promise

        try {
            // Create CardScanSheet
            cardScanSheet = CardScanSheet.create(
                from = currentActivity,
                callback = object : CardScanSheet.CardScanResultCallback {
                    override fun onCardScanSheetResult(result: CardScanSheetResult) {
                        handleScanResult(result)
                    }
                }
            )

            // Parse options
            val enableExpiryExtraction = options?.getBoolean("enableExpiryExtraction") ?: true
            val enableNameExtraction = options?.getBoolean("enableNameExtraction") ?: true

            // Create configuration
            val config = CardScanConfiguration(
                enableExpiryExtraction = enableExpiryExtraction,
                enableNameExtraction = enableNameExtraction
            )

            // Present the scanner
            cardScanSheet?.present(config)

        } catch (e: Exception) {
            scanCardPromise?.reject("SCAN_FAILED", "Failed to start card scanner: ${e.message}", e)
            scanCardPromise = null
        }
    }

    private fun handleScanResult(result: CardScanSheetResult) {
        when (result) {
            is CardScanSheetResult.Completed -> {
                val scannedCard = result.scannedCard
                val resultMap = Arguments.createMap().apply {
                    putString("number", scannedCard.pan)
                    scannedCard.expiryMonth?.let { putString("expiryMonth", it.toString().padStart(2, '0')) }
                    scannedCard.expiryYear?.let {
                        // Convert 2-digit year to 4-digit if needed
                        val yearStr = it.toString()
                        val fullYear = if (yearStr.length == 2) {
                            "20$yearStr"
                        } else {
                            yearStr
                        }
                        putString("expiryYear", fullYear)
                    }
                    scannedCard.cardholderName?.let { putString("holderName", it) }
                }
                scanCardPromise?.resolve(resultMap)
            }
            is CardScanSheetResult.Canceled -> {
                scanCardPromise?.resolve(null)
            }
            is CardScanSheetResult.Failed -> {
                scanCardPromise?.reject("SCAN_FAILED", result.error.message ?: "Card scanning failed", result.error)
            }
        }
        scanCardPromise = null
    }
}
