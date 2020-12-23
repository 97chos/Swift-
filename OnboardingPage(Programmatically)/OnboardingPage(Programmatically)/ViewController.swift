//
//  ViewController.swift
//  OnboardingPage(Programmatically)
//
//  Created by sangho Cho on 2020/12/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let show = UIButton(type: .system)

        show.setTitle("Show", for: .normal)
        show.sizeToFit()

        show.center.x = self.view.frame.width / 2
        show.center.y = self.view.frame.height / 2
        show.addTarget(self, action: #selector(show(_:)), for: .touchUpInside)

        self.view.addSubview(show)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: "checkOnboard") == false {
            let vc = MasterViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

extension ViewController {

    @objc func show(_ shender: UIButton) {
        let vc = MasterViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
