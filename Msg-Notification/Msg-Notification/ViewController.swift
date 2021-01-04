//
//  ViewController.swift
//  Msg-Notification
//
//  Created by 조상호 on 2020/10/15.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var msg: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!

    @IBAction func save(_ sender: Any) {

        // iOS 10 이상만 UserNotification 프레임워크 활용 가능
        if #available(iOS 10, *) {
            // UserNotification 프레임워크를 사용한 로컬 알림
            // 사용자 동의 여부 리턴 메소드
            UNUserNotificationCenter.current().getNotificationSettings{ settings in

                // 사용자가 알림을 허용했다면 settings의 속성 값인 authorizationStatus가 .authorized로 설정됨
                guard settings.authorizationStatus == UNAuthorizationStatus.authorized else {
                    self.alert(title: "알림 등록", msg: "알림이 허용되지 않았습니다.")
                    return
                }

                DispatchQueue.main.async {
                    // 알림 콘텐츠 관리
                    let nContent = UNMutableNotificationContent()
                    nContent.body = (self.msg.text)!
                    nContent.title = "미리 알림"
                    nContent.sound = UNNotificationSound.default

                    // 만약 설정된 시간이 현재 시간보다 같거나 이전이라면 리턴
                    if self.datepicker.date.timeIntervalSinceNow > 0 {

                        // 발송 시각을 '지금부터 데이트 피커 선택된 시간까지 *초'형식으로 변환
                        let time = self.datepicker.date.timeIntervalSinceNow

                        // 발송 조건 정의 (timeInterval: x초 후 발송)
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)

                        // 발송 요청 객체 정의
                        let request = UNNotificationRequest(identifier: "alarm", content: nContent, trigger: trigger)

                        self.addNotificationCenter(request: request)

                    } else {
                        self.alert(title: nil, msg: "현재보다 이후의 시간대만 설정 가능합니다.")
                        return
                    }
                }
            }
        } else {
            // iOS 9.0 이하 버전에서 LocalNotification 객체를 사용한 로컬 알림
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController {

    // 노티피케이션센터에 발송 요청 객체 추가 메소드
    func addNotificationCenter(request: UNNotificationRequest) {

        // 노티피케이션 센터에 추가
        UNUserNotificationCenter.current().add(request) { _ in

            DispatchQueue.main.async {

                let date = self.datepicker.date

                let df = DateFormatter()
                df.locale = Locale(identifier: "ko")
                df.dateFormat = "yyyy년 MM월 dd일 HH:mm"
                let dated = df.string(from: date)

                let message = "알림이 등록되었습니다.\n등록된 알림은 \(dated)에 발송됩니다."

                self.alert(title: "등록 완료", msg: message)
            }
        }
    }

    func alert(title: String?, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))

        self.present(alert, animated: true)
    }

}
