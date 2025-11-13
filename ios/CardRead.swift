import Foundation
import UIKit
import StripeCardScan
import React

@objc(CardRead)
class CardRead: NSObject {

  private var cardScanSheet: CardScanSheet?
  private var pendingResolve: RCTPromiseResolveBlock?
  private var pendingReject: RCTPromiseRejectBlock?

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func scanCard(_ options: NSDictionary,
                resolver resolve: @escaping RCTPromiseResolveBlock,
                rejecter reject: @escaping RCTPromiseRejectBlock) {
    NSLog("CardRead.scanCard called from Swift")
    DispatchQueue.main.async { [weak self] in
      self?.scanCardOnMainThread(options: options, resolve: resolve, reject: reject)
    }
  }

  private func scanCardOnMainThread(options: NSDictionary,
                                    resolve: @escaping RCTPromiseResolveBlock,
                                    reject: @escaping RCTPromiseRejectBlock) {
    // Store the promise handlers
    self.pendingResolve = resolve
    self.pendingReject = reject

    // Get the root view controller using modern API
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
      reject("NO_ROOT_VC", "Could not find root view controller", nil)
      return
    }

    // Find the presented view controller if there is one
    var presentingViewController = rootViewController
    while let presented = presentingViewController.presentedViewController {
      presentingViewController = presented
    }

    // Create and present the card scan sheet
    let cardScanSheet = CardScanSheet()
    self.cardScanSheet = cardScanSheet

    // NEW: Extract customizable UI text from options
    if let headerTitle = options["headerTitle"] as? String {
      cardScanSheet.headerTitle = headerTitle
    }
    if let instructionText = options["instructionText"] as? String {
      cardScanSheet.instructionText = instructionText
    }

    cardScanSheet.present(from: presentingViewController) { [weak self] result in
      self?.handleScanResult(result)
    }
  }

  private func handleScanResult(_ result: CardScanSheetResult) {
    guard let resolve = pendingResolve else {
      return
    }

    defer {
      pendingResolve = nil
      pendingReject = nil
      cardScanSheet = nil
    }

    switch result {
    case .completed(let card):
      var cardData: [String: Any] = [
        "number": card.pan
      ]

      if let expiryMonth = card.expiryMonth {
        cardData["expiryMonth"] = expiryMonth
      }

      if let expiryYear = card.expiryYear {
        cardData["expiryYear"] = expiryYear
      }

      if let name = card.name {
        cardData["holderName"] = name
      }

      resolve(cardData)

    case .canceled:
      resolve(NSNull())

    case .failed(let error):
      if let reject = pendingReject {
        reject("SCAN_FAILED", error.localizedDescription, error)
      }
    }
  }
}
