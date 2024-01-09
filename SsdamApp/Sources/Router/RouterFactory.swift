//
//  RouterFactory.swift
//  vkdoc
//
//  Created by Данил Ломаев on 18.04.2022.
//

import Foundation
import SwiftUI

public protocol RouterFactory {
    associatedtype Body: View
    associatedtype Screen: ScreenProtocol

    @ViewBuilder func makeBody(for screen: Screen) -> Self.Body
    func makeViewController(for screen: Screen) -> UIViewController
}
