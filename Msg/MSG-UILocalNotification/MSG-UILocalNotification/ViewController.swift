//
//  ViewController.swift
//  MSG-UILocalNotification
//
//  Created by 조상호 on 2020/10/15.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var msg: UITextField!
    
    @IBOutlet var datepicker: UIDatePicker!
    
    @IBAction func save(_ sender: Any) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                
            } else {
                let alert = UIAlertController(title: "알림 등록", message: "알림이 허용되어 있지 않습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true)
                return
            }
        }
    } else {
         
    }
    }
}

