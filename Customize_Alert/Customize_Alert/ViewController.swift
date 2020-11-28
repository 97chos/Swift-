//
//  ViewController.swift
//  Customize_Alert
//
//  Created by sangho Cho on 2020/11/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaultAlertBtn = UIButton(type: .system)
        defaultAlertBtn.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
        defaultAlertBtn.center.x = self.view.frame.width/2
        defaultAlertBtn.setTitle("기본 알림창", for: .normal)
        defaultAlertBtn.addTarget(self,
                                  action: #selector(defaultAlert),
                                  for: .touchUpInside)
        self.view.addSubview(defaultAlertBtn)
    }

    @objc func defaultAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "알림창",
                                      message: "기본 메세지가 들어가는 곳",
                                      preferredStyle: .actionSheet)
        let v = UIViewController()
        v.view.backgroundColor = .red
        alert.setValue(v, forKey: "contentViewController")

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }


}

