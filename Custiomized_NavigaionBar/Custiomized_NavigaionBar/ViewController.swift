//
//  ViewController.swift
//  Custiomized_NavigaionBar
//
//  Created by sangho Cho on 2020/11/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //initTitle()
        //initTitleImage()
        initTitleInput()
    }

    func initTitle() {
        // 1. 복합적인 레이아웃 구성을 위한 컨테이너뷰 설정
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 361))

        // 2. 상단 레이블 정의
        let topTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 18))
        topTitle.numberOfLines = 1
        topTitle.font = .systemFont(ofSize: 15)
        topTitle.textColor = .white
        topTitle.text = "58개 숙소"
        topTitle.textAlignment = .center

        // 3. 하단 레이블 정의
        let subTitle = UILabel(frame: CGRect(x: 0, y: 18, width: 200, height: 18))
        subTitle.numberOfLines = 1
        subTitle.font = .systemFont(ofSize: 12)
        subTitle.textColor = .white
        subTitle.text = "1박(1월 10일 ~ 1월 11일)"
        subTitle.textAlignment = .center

        // 4. 상하단 레이블을 컨테이버 뷰에 추가
        containerView.addSubview(topTitle)
        containerView.addSubview(subTitle)

        // 5. 내비게이션 타이블 뷰에 컨테이너 뷰 대입
        self.navigationItem.titleView = containerView

        // 4. 배경 색상 설정
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.backgroundColor = color
    }

    func initTitleImage() {
        let image = UIImage(named: "swift_logo")
        let imageV = UIImageView(image: image)

        self.navigationItem.titleView = imageV
    }

    func initTitleInput() {
        let back = UIImage(named: "arrow-back")
        let leftItem = UIBarButtonItem(image: back, style: .plain, target: self, action: nil)

        let rv = UIView()
        rv.frame = CGRect(x: 0, y: 0, width: 70, height: 37)
        let rItem = UIBarButtonItem(customView: rv)

        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rItem

        let cnt = UILabel()
        cnt.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        cnt.font = UIFont.boldSystemFont(ofSize: 10)
        cnt.textColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
        cnt.text = "12"
        cnt.textAlignment = .center
        cnt.layer.borderWidth = 2
        cnt.layer.cornerRadius = 3
        cnt.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor

        let more = UIButton(type: .system)
        more.frame = CGRect(x: 50, y: 10, width: 16, height: 16)
        more.setImage(UIImage(named: "more"), for: .normal)

        rv.addSubview(cnt)
        rv.addSubview(more)
    }

}

