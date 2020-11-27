//
//  ViewController.swift
//  InputForm no SB
//
//  Created by sangho Cho on 2020/11/27.
//

import UIKit

class ViewController: UIViewController {

    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let font = UIFont(name: "Thonburi-Bold", size: 14)

        self.navigationItem.title = "설정"

        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"

        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"

        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"

        lblEmail.font = font
        lblUpdate.font = font
        lblInterval.font = font

        self.view.addSubview(lblEmail)
        self.view.addSubview(lblUpdate)
        self.view.addSubview(lblInterval)

        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = .systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect
        self.paramEmail.placeholder = "이메일을 입력하세요."
        self.paramEmail.autocapitalizationType = .none

        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true)

        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0

        self.view.addSubview(paramEmail)
        self.view.addSubview(paramUpdate)
        self.view.addSubview(paramInterval)

        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = .systemFont(ofSize: 12)
        self.txtUpdate.textColor = .red
        self.txtUpdate.text = "갱신함"

        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        self.txtInterval.font = .systemFont(ofSize: 12)
        self.txtInterval.textColor = .red
        self.txtInterval.text = "0분마다"

        self.view.addSubview(txtUpdate)
        self.view.addSubview(txtInterval)

        self.paramUpdate.addTarget(self, action: #selector(presentUpdate(_:)), for: .valueChanged)
        self.paramInterval.addTarget(self, action: #selector(presentInterval(_:)), for: .valueChanged)

        self.paramEmail.delegate = self

        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose,
                                        target: self,
                                        action: #selector(submit(_:)))

        self.navigationItem.rightBarButtonItem = submitBtn

    }

    @objc func presentUpdate(_ sender: UISwitch) {
        self.txtUpdate.text = paramUpdate.isOn ? "갱신함" : "갱신하지 않음"
    }

    @objc func presentInterval(_ sender: UIStepper) {
        self.txtInterval.text = "\(Int(paramInterval.value))분 마다"
    }

    @objc func submit(_ sender: UIBarButtonItem) {
        let vc = ReadViewController()
        vc.pEmail = self.paramEmail.text
        vc.pUpdate = self.paramUpdate.isOn
        vc.pInterval = self.paramInterval.value

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

