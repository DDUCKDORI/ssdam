//
//  WebViewRepresentable.swift
//  Ssdam
//
//  Created by 김재민 on 1/9/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
