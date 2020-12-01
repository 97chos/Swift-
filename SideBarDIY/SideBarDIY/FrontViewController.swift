//
//  FrontViewController.swift
//  SideBarDIY
//
//  Created by sangho Cho on 2020/12/01.
//

import Foundation
import UIKit

class FrontViewController: UIViewController {

    // 사이드바 오픈 기능을 위임할 델리게이트
    var delegate: RevealViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 사이드 바 오픈 버튼 정의
        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(moveSide(_:)))

        // 버튼을 내비게이션 바 왼쪽 영역에 추가
        self.navigationItem.leftBarButtonItem = btnSideBar

        // 화면 끝에서 다른 쪽으로 패닝하는 제스처를 정의
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(moveSide(_:)))
        // 스와이프 제스쳐 정의
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(moveSide(_:)))

        dragLeft.edges = UIRectEdge.left            // 시작 모서리는 왼쪽
        dragRight.direction = .left          // 진행 방향은 왼쪽

        self.view.addGestureRecognizer(dragLeft)    // 뷰에 제스쳐 객체를 등록
        self.view.addGestureRecognizer(dragRight)   // 뷰에 제스쳐 객체를 등록
    }

    @objc func moveSide(_ sender: Any) {
        if sender is UIScreenEdgePanGestureRecognizer {                 // 패닝했을 경우
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {                  // 스와이프했을 경우
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {                           // 버튼 클릭했을 경우
            if delegate?.isSideBarShowing == true {
                delegate?.closeSideBar(nil)
            } else {
                delegate?.openSideBar(nil)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate?.isSideBarShowing == true {
            delegate?.closeSideBar(nil)
        }
    }
}
