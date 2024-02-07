//
//  AdInterstitialView.swift
//  Ssdam
//
//  Created by 김재민 on 2/7/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import GoogleMobileAds
import SwiftUI

// MARK: - Helper to present Interstitial Ad
struct AdViewControllerRepresentable: UIViewControllerRepresentable, Equatable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

public final class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    func loadAd() {
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()) { ad, error in
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            print("Error: \(error)")
        }
    }
    
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
    }
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            return print("Ad wasn't ready")
        }
        
        interstitial.present(fromRootViewController: viewController)
    }
}
