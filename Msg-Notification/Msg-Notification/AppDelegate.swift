import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    //앱이 처음 실행될 때 실행되는 메소드
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            // 경고창, 배지, 사운드를 사용하는 알림 환경 정보를 생성하고, 사용자 동의 여부 창을 실행
            let notiCenter = UNUserNotificationCenter.current()
            notiCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { didAllow, e in })
            notiCenter.delegate = self
        } else {
            
        }
        return true
    }

    // 앱이 종료되기 직전 실행되는 메소드
    func applicationWillResignActive(_ application: UIApplication) {
        if #available(iOS 10.0, *) {                // UserNotifications 프레임워크를 이용한 로컬 알림
            // 알림 동의 여부를 확인
            // setting 값
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {                        // 사용자가 알림 수신을 동의했다면
                    // 알림 콘텐츠 객체
                    let nContent = UNMutableNotificationContent()
                    nContent.badge = 1
                    nContent.title = "로컬 알림 메세지"
                    nContent.subtitle = "알림 메세지 서브타이틀입니다."
                    nContent.body = "알림 메세지 본문입니다."
                    nContent.sound = UNNotificationSound.default
                    nContent.userInfo = ["name" : "홍길동"]

                    // 알림 발송 조건 객체
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    // 알림 요청 객체
                    let request = UNNotificationRequest(identifier: "wakeUp", content: nContent, trigger: trigger)

                    // 노티피케이션 센터에 추가
                    UNUserNotificationCenter.current().add(request)
                } else {
                    print("사용자가 동의하지 않음")
                }
            }
        } else {
        }
    }

    
    // 앱 실행 도중 알림 메세지가 도착한 경우
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        if notification.request.identifier == "wakeUp" {
            let userInfo = notification.request.content.userInfo
            print("open 상태: \(userInfo["name"]!)")
        }

        // 알림 배너 띄워주기
        completionHandler([.alert, .badge, .sound])
    }

    // 사용자가 알림 메세지를 클릭했을 경우
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "wakeUp" {
            let userInfo = response.notification.request.content.userInfo
            print("clicked: \(userInfo["name"])")
        }
        completionHandler()
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

