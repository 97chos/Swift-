//
//  ReadViewController.swift
//  InputForm no SB
//
//  Created by sangho Cho on 2020/11/27.
//

import Foundation
import UIKit

class ReadViewController: UIViewController {
    var pEmail: String?
    var pUpdate: Bool?
    var pInterval: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        let email = UILabel()
        let update = UILabel()
        let interval = UILabel()

        email.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        update.frame = CGRect(x: 50, y: 150, width: 300, height: 30)
        interval.frame = CGRect(x: 50, y: 200, width: 300, height: 30)

        email.text = "이메일 : \(self.pEmail!)"
        update.text = "갱신 여부 : \(self.pUpdate == true ? "자동갱신" : "자동갱신 안함")"
        interval.text = "업데이트 주기 : \(self.pInterval!)분"

        self.view.addSubview(email)
        self.view.addSubview(update)
        self.view.addSubview(interval)
    }
}
