//
//  ViewController.swift
//  OnboardingPage
//
//  Created by sangho Cho on 2020/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func show(_ sender: UIButton) {

        UserDefaults.standard.setValue(false, forKey: "Check")
        let vc = self.instanceTutorial(name: "MasterVC")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "Check") == false {
            let vc = self.instanceTutorial(name: "MasterVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true)
        } else {
            print(UserDefaults.standard.bool(forKey: "check"))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
