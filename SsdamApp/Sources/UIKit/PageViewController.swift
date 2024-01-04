//
//  PageViewController.swift
//  Ssdam
//
//  Created by 김재민 on 2023/11/13.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int
    let swipeable: Bool

    init(pages: [Page], currentPage: Binding<Int>, swipeable: Bool = true) {
        self.pages = pages
        self._currentPage = currentPage
        self.swipeable = swipeable
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers([context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
        pageViewController.dataSource = context.coordinator
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if !parent.swipeable {
            return nil
        }
        guard let index = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        if controllers.count == 1 {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        return controllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if !parent.swipeable {
            return nil
        }
        guard let index = controllers.firstIndex(of: viewController) else {
            return nil
        }
        if controllers.count == 1 {
            return nil
        }
        
        if index + 1 == controllers.count {
            return nil
        }
        
        return controllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
}
func makeCoordinator() -> Coordinator {
    Coordinator(self)
}
}
