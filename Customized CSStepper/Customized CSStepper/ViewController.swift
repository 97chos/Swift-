//
//  ViewController.swift
//  Customized CSStepper
//
//  Created by sangho Cho on 2020/11/30.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        self.view.addSubview(stepper)
    }


}

