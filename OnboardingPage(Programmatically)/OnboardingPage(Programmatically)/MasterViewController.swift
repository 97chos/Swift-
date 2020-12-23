//
//  MasterViewController.swift
//  OnboardingPage(Programmatically)
//
//  Created by sangho Cho on 2020/12/23.
//

import Foundation
import UIKit

class MasterViewController: UIViewController {

    var pageVC: UIPageViewController!
    var close: UIButton!

    let contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    let contentImage = ["Page0","Page1", "Page2", "Page3"]

    override func viewDidLoad() {

        self.view.backgroundColor = .white

        close = UIButton(type: .system)
        close.setTitle("Close", for: .normal)
        close.sizeToFit()
        close.frame.origin = CGPoint(x: 0, y: self.view.frame.height * 0.85)
        close.center.x = self.view.frame.width / 2

        close.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        self.view.addSubview(close)

        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = self

        pageVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.8)

        let startContent = self.getContent(atIndex: 0)!
        pageVC.setViewControllers([startContent], direction: .forward, animated: true)

        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }

    func getContent(atIndex idx: Int) -> UIViewController? {

        guard idx < contentTitles.count && contentTitles.count > 0 else {
            return nil
        }

        let ContentVC = ContentViewController()

        ContentVC.titleText = contentTitles[idx]
        ContentVC.imageData = contentImage[idx]
        ContentVC.pageIndex = idx
        ContentVC.imgViewSize = self.pageVC.view.frame.size
    
        return ContentVC
    }

    @objc func close(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)

        let ud = UserDefaults.standard
        ud.setValue(true, forKey: "checkOnboard")
        ud.synchronize()
    }
}

extension MasterViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard var index = (viewController as! ContentViewController).pageIndex else {
            return nil
        }

        guard index > 0 else {
            return nil
        }

        index -= 1

        return getContent(atIndex: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard var index = (viewController as! ContentViewController).pageIndex else {
            return nil
        }

        guard index < self.contentTitles.count else {
            return nil
        }

        index += 1

        return getContent(atIndex: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentTitles.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
