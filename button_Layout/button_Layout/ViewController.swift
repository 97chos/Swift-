//
//  ViewController.swift
//  button_Layout
//
//  Created by sangho Cho on 2020/11/26.
//

import UIKit

class ViewController: UIViewController {

    var subject: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 버튼 객체 생성
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트버튼", for: .normal)

        // Label 객체 생성
        self.subject = UILabel()
        self.subject.frame = CGRect(x: 50, y: 150, width: 150, height: 30)
        self.subject.text = "Label 객체 생성"

        // 버튼, 레이블 수평 중앙 정렬
        btn.center = CGPoint(x: self.view.frame.size.width/2, y: 100)
        self.subject.center = CGPoint(x: self.view.frame.size.width/2, y: 150)
        self.subject.textAlignment = .center

        // 루트뷰에 버튼,레이블 추가
        self.view.addSubview(btn)
        self.view.addSubview(subject)

        // 버튼 이벤트와 btnClick 메소드 연결
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
    }

    @objc func btnClick(_ sender: UIButton) {
        sender.setTitle("클릭되었습니다.", for: .normal)
    }


}

