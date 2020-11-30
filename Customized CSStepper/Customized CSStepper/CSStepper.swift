//
//  CSStepper.swift
//  Customized CSStepper
//
//  Created by sangho Cho on 2020/11/30.
//

import Foundation
import UIKit

// 인터페이스 빌더에서 확인 가능
@IBDesignable
class CSStepper: UIControl {

    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel()

    // 인터페이스 필더 내 속성 창에서 변경 설정 가능
    @IBInspectable
    public var value: Int = 0 {
        // 프로퍼티의 값이 바뀌면 자동으로 호출
        didSet {
            self.centerLabel.text = String(value)

            // 이 클래스를 상속받은 객체들에게 valueChanged 이벤트 신호를 보낸다.
            self.sendActions(for: .valueChanged)
        }
    }
    @IBInspectable
    public var leftTitle: String = "⬇" {
        didSet {
            self.leftBtn.setTitle(leftTitle, for: .normal)
        }
    }
    @IBInspectable
    public var rightTitle: String = "⬆" {
        didSet {
            self.rightBtn.setTitle(rightTitle, for: .normal)
        }
    }
    @IBInspectable
    public var bgColor:UIColor = UIColor.cyan {
        didSet {
            self.centerLabel.backgroundColor = backgroundColor
        }
    }
    @IBInspectable
    public var stepValue: Int = 1
    public var maximumValue: Int = 100
    public var minimumValue: Int = -100

    // 스토리보드에서 호출할 초기화 메소드
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    // 프로그래밍 방식으로 호출할 초기화 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    private func setup() {

        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        // 좌측 다운 버튼 속성 설정
        self.leftBtn.tag = -1
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor

        // 우측 업 버튼 속성 설정
        self.rightBtn.tag = 1
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor

        // 중앙 레이블 속성 설정
        self.centerLabel.text = String(value)
        self.centerLabel.font = UIFont.systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = self.bgColor
        self.centerLabel.layer.borderWidth = borderWidth
        self.centerLabel.layer.borderColor = borderColor

        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)

        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        // 버튼의 너비 = 뷰 높이
        let btnWidth = self.frame.height

        // 레이블의 너비 = 뷰 전체 크기 - 양쪽 버튼의 너비의 합
        let lblWidth = self.frame.width - btnWidth * 2

        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth + lblWidth, y: 0, width: btnWidth, height: btnWidth)

        self.addSubview(leftBtn)
        self.addSubview(centerLabel)
        self.addSubview(rightBtn)
    }

    @objc public func valueChange(_ sender: UIButton) {

        // 스테퍼의 값을 변경하기 전에, 미리 최소값과 최대값 범위를 벗어나지 않는지 확인
        let sum = self.value + (sender.tag * self.stepValue)

        if sum > self.maximumValue {
            return
        }
        if sum < self.maximumValue {
            return
        }

        self.value += sender.tag * self.stepValue
    }
}
