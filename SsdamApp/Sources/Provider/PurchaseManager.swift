//
//  PurchaseManager.swift
//  Ssdam
//
//  Created by 김재민 on 6/1/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import StoreKit

class PurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = PurchaseManager()

    @Published var products: [SKProduct] = []
    @Published var transactionState: SKPaymentTransactionState?

    private var productsRequest: SKProductsRequest?
    
    func fetchProducts(productIdentifiers: Set<String>) {
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            DispatchQueue.main.async {
                self.transactionState = transaction.transactionState
            }

            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction: transaction)
            case .failed:
                failedTransaction(transaction: transaction)
            case .restored:
                restoreTransaction(transaction: transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                fatalError()
            }
        }
    }

    private func completeTransaction(transaction: SKPaymentTransaction) {
        // Handle successful transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restoreTransaction(transaction: SKPaymentTransaction) {
        // Handle restored transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func failedTransaction(transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError?,
           error.code != SKError.paymentCancelled.rawValue {
            // Handle error
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
