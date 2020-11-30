//
//  ThirdViewController.swift
//  Costomized TabBar
//
//  Created by sangho Cho on 2020/11/27.
//

import Foundation
import UIKit

class ThirdViewContorller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))

        title.text = "세 번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 14)

        title.sizeToFit()
        title.center.x = self.view.frame.size.width/2

        self.view.addSubview(title)
    }
}
