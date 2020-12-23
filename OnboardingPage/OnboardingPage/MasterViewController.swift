//
//  MasterViewController.swift
//  OnboardingPage
//
//  Created by sangho Cho on 2020/12/23.
//

import Foundation
import UIKit


class MasterViewController: UIViewController {

    @IBAction func close(_ sender: UIButton) {

        UserDefaults.standard.setValue(true, forKey: "Check")
        UserDefaults.standard.synchronize()
        self.presentingViewController?.dismiss(animated: true)
    }


    var pageVC: UIPageViewController!

    // 콘텐츠 뷰 컨트롤러에 들어갈 타이틀과 이미지
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImage = ["Page0","Page1", "Page2", "Page3"]

    func getContentVC(atIndex idx: Int) -> UIViewController? {
        // 인덱스가 데이터 배열 크기 범위를 벗어나면 nil 반환
        guard self.contentTitles.count > idx && self.contentTitles.count > 0 else {
            return nil
        }

        // "ContentVC"라는 StoryBoard ID를 가진 뷰 컨트롤러의 인스턴스를 생성하고 캐스팅
        guard let cvc = self.instanceTutorial(name: "ContentVC") as? OnboardContentVC else {
            return nil
        }

        // 콘텐츠 뷰 컨트롤러 내용 구성
        cvc.titleText = self.contentTitles[idx]
        cvc.imageFile = self.contentImage[idx]
        cvc.pageIndex = idx

        return cvc

    }

    override func viewDidLoad() {

        // 1. 페이지 뷰 컨트롤러 객체 생성
        self.pageVC = self.instanceTutorial(name: "PageVC") as? UIPageViewController
        self.pageVC.dataSource = self

        // 2. 페이지 뷰 컨트롤러의 기본 페이지 지정
        let starContentVC = self.getContentVC(atIndex: 0)!          // 최초 노출될 뷰 컨트롤러
        self.pageVC.setViewControllers([starContentVC], direction: .forward, animated: true)

        // 3. 페이지 뷰 컨트롤러의 출력 영역 설정
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 70

        // 4. 페이지 뷰 컨트롤러를 마스터 뷰 컨트롤러의 자식 뷰 컨트롤러로 설정
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)

    }
}

extension MasterViewController: UIPageViewControllerDataSource {

    // 현재의 콘텐츠 뷰 컨트롤러보다 앞쪽에 올 콘텐츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // 현재 페이지 인덱스
        guard var index = (viewController as! OnboardContentVC).pageIndex else {
            return nil
        }

        // 현재 인덱스가 맨 앞이라면 nil을 반환하고 종료
        guard index > 0 else {
            return nil
        }

        index -= 1
        return self.getContentVC(atIndex: index)
    }

    // 현재의 콘텐츠 뷰 컨트롤러보다 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // 현재 페이지 인덱스
        guard var index = (viewController as! OnboardContentVC).pageIndex else {
            return nil
        }

        guard index < self.contentTitles.count else {
            print("ll")
            return nil
        }

        index += 1
        return self.getContentVC(atIndex: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentTitles.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }


}


extension UIViewController {
    var onboardSB: UIStoryboard {
        return UIStoryboard(name: "Onboard", bundle: Bundle.main)
    }

    func instanceTutorial(name: String) -> UIViewController? {
        return self.onboardSB.instantiateViewController(withIdentifier: name)
    }
}
