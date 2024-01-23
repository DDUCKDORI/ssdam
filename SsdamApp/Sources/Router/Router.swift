//
//  RouterObject.swift
//  vkdoc
//
//  Created by Данил Ломаев on 15.04.2022.
//

import Foundation
import SwiftUI
import UIKit
extension UIWindow {
    static var key: UIWindow? {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first else { return nil }
        
        return keyWindow
    }
}

public protocol ScreenProtocol {
    var isHiddenNavigation: Bool { get }
    var title: String { get }
}

public protocol RouterObject: AnyObject {
    associatedtype Screen = ScreenProtocol
    associatedtype Body = View
    
    var rootViewController: UINavigationController? { get }
    
    func start(window: UIWindow, rootView: some View)
    func change(root screen: Screen)
    func routeTo(_ screen: Screen, animated: Bool)
    func presentSheet(_ screen: Screen, animated: Bool)
    func presentFullScreen(_ screen: Screen, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
}

public class Router<ScreenType, Factory: RouterFactory>: ObservableObject, RouterObject where Factory.Screen == ScreenType {
    public var rootViewController: UINavigationController?
    private var factory: Factory
    
    public init(factory: Factory) {
        self.factory = factory
    }
}

public extension Router {
    func start(window: UIWindow, rootView: some View) {
        let hostingViewController = UIHostingController(rootView: rootView)
        let navigationViewController = UINavigationController(rootViewController: hostingViewController)
        navigationViewController.hideNavigationByOS()
        window.rootViewController = navigationViewController
        self.rootViewController = navigationViewController
    }
    
    func change(root screen: ScreenType) {
        let navigationViewController = UINavigationController(rootViewController: factory.makeViewController(for: screen))
        navigationViewController.hideNavigationByOS()
        guard let window = UIWindow.key else {
            UIWindow.key?.rootViewController = navigationViewController
            self.rootViewController = navigationViewController
            return
        }
        window.rootViewController = navigationViewController
        self.rootViewController = navigationViewController
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
    
    func routeTo(_ screen: ScreenType, animated: Bool = true) {
        //        let baseVC = UIWindow.key?.rootViewController
        //        guard let naviController = baseVC as? UINavigationController else { return }
        rootViewController?.isHiddenNavigation(screen.isHiddenNavigation)
        rootViewController?.navigationBar.topItem?.backButtonTitle = screen.title
        rootViewController?.setNeedsStatusBarAppearanceUpdate()
        rootViewController?.pushViewController(factory.makeViewController(for: screen), animated: animated)
    }
    
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.popViewController(animated: animated)
        completion?()
    }
    
    func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.popToRootViewController(animated: animated)
        completion?()
    }
    
    func presentFullScreen(_ screen: ScreenType, animated: Bool = true) {
        let viewController = factory.makeViewController(for: screen)
        viewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
    
    func presentSheet(_ screen: ScreenType, animated: Bool = true) {
        rootViewController?.present(factory.makeViewController(for: screen), animated: animated)
    }
}

private extension UINavigationController {
    func isHiddenNavigation(_ isHidden: Bool) {
        self.setNavigationBarHidden(isHidden, animated: false)
        self.isNavigationBarHidden = isHidden
        self.navigationBar.isHidden = isHidden
    }
    
    func hideNavigationByOS() {
        if #available(iOS 16.0, *) {
            self.setToolbarHidden(true, animated: false)
        } else {
            self.hideNaviagationBar()
        }
    }
    
    private func hideNaviagationBar() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationBar.isHidden = true
            self?.view.setNeedsLayout()
        }
    }
}
