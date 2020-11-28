//
//  ControlViewController.swift
//  Customize_Alert
//
//  Created by sangho Cho on 2020/11/28.
//

import Foundation
import UIKit

class ControlViewContoller: UIViewController {
    let slider = UISlider()

    var sliderValue: Float {
        return self.slider.value
    }

    override func viewDidLoad() {
        // 슬라이더의 최소값 / 최대값 설정
        slider.minimumValue = 0
        slider.maximumValue = 100

        // 슬라이더의 영역과 크기를 정의하고 루트 뷰에 추가
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)

        // 뷰 컨트롤러의 콘텐츠 사이즈 지정
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)

    }
}
