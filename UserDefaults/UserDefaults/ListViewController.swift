//
//  ListViewController.swift
//  UserDefaults
//
//  Created by sangho Cho on 2020/12/02.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!

    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex //////// 0이면 남자, 1이면 여자

        let plist = UserDefaults.standard       // 기본 저장소 객체를 가져온다.
        plist.set(value, forKey: "gender")      // "gender"라는 키로 값을 저장
        plist.synchronize()                     // 동기화 처리
    }
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn                 // true면 기혼, false면 미혼

        let plist = UserDefaults.standard       // 기본 저장소 객체를 가져온다.
        plist.set(value, forKey: "married")     // "married"라는 키로 값을 저장
        plist.synchronize()                     // 동기화 처리
    }

    

    @IBAction func edit(_ sender: UITapGestureRecognizer) {
           let alert = UIAlertController(title: nil, message: "이름을 입력하세요.", preferredStyle: .alert)

           // 입력 필드 추가
           alert.addTextField() {
               // 현재 이름에 입력된 레이블 text를 입력폼에 기본값으로 삽입
               $0.text = self.name.text
           }

           // 버튼 및 액션 추가
           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in

               // 사용자가 OK 버튼을 누르면 입력 필드에 입력된 값을 저장한다.
               let value = alert.textFields?[0].text

               let plist = UserDefaults.standard
               plist.setValue(value, forKey: "name")
               plist.synchronize()

               // 수정된 값을 이름 레이블에도 적용한다.
               self.name.text = value
               self.name.sizeToFit()
           })
           // 알림창을 띄운다.
           self.present(alert, animated: true)

    }

    override func viewDidLoad() {
        self.navigationItem.title = "사용자 정보"

        let plist = UserDefaults.standard

        // 저장된 값을 꺼내어 각 컨트롤에 설정한다.
        self.name.text = plist.string(forKey: "name")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        self.married.isOn = plist.bool(forKey: "married")
    }

}
