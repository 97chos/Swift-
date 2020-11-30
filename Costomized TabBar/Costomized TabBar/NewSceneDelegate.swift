//
//  NewSceneDelegate.swift
//  Costomized TabBar
//
//  Created by sangho Cho on 2020/11/27.
//

import Foundation
import UIKit

class NewSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // 1. 탭 바 컨트롤러 생성 및 배경색 변경
        let tbC = UITabBarController()
        tbC.view.backgroundColor = .white

        // 2. 생성된 탭 바 컨트롤러를 루트 뷰 컨트롤러로 등록
        self.window?.rootViewController = tbC

        // 3. 탭 바 아이템에 연결될 뷰 컨트롤러 객체를 생성
        let view1 = ViewController()
        let view2 = SecondViewController()
        let view3 = ThirdViewContorller()

        // 4. 생성된 뷰 컨트롤러 객체들을 탭 바 컨트롤러에 등록
        tbC.setViewControllers([view1,view2,view3], animated: true)

        // 5. 개별 탭 바 아이템 속성 설정
        view1.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "calendar"), selectedImage: nil)
        view2.tabBarItem = UITabBarItem(title: "File", image: UIImage(named: "file-tree"), selectedImage: nil)
        view3.tabBarItem = UITabBarItem(title: "Photo", image: UIImage(named: "photo"), selectedImage: nil)

    }


}
