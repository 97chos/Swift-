//
//  ListViewController.swift
//  CustomPlist
//
//  Created by sangho Cho on 2020/12/02.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!

    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex                                                         // 0이면 남자, 1이면 여자

        // MARK: - custom plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist"                                                 // 읽어올 파일명
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)      // 경로 탐색 및 링크 반환
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!

        // 저장된 커스텀 plist 파일이 없을 때, nil을 방지하기 위해 표준 템플릿 딕셔너리를 이용하여 객체를 생성하는 구문
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }

    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn

        // MARK: - custom plist 저장 로직 시작
        let customPlist = "\(self.account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)

        print("custom plist = \(plist)")
    }
    
    var accountList = [String]()

    // 메인 번들에 정의된 UserInfo.plist 내용을 저장할 딕셔너리
    var defaultPlist: NSDictionary!

// MARK: - ViewDidLoad
    override func viewDidLoad() {

        // 매인 번들에 UserInfo.plist가 포함되어 있으면 이를 읽어와 딕셔너리에 담는다.
        if let defaultPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: defaultPlistPath)
        }
        let picker = UIPickerView()

        // 피커뷰의 델리게이트 객체 지원
        picker.delegate = self
        // account 텍스트 필드 입력 방식을 가상 키보드 대신 피커뷰로 설정
        self.account.inputView = picker

        // 툴 바 객체 정의
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolBar.barTintColor = .lightGray

        // 액세서리 뷰 영역에 툴 바를 표시
        self.account.inputAccessoryView = toolBar

        // 툴 바에 들어갈 닫기 버튼
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)

        // 툴 바에 들어갈 신규 계정 추가 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))

        // 가변 폭 버튼 정의
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)

        // 버튼을 툴 바에 추가
        toolBar.setItems([new,flexSpace,done], animated: true)

        // 기본 저장소 객체 불러오기
        let plist = UserDefaults.standard

        // 불러온 값을 설정
        self.account.text = plist.string(forKey: "account")
        self.name.text = plist.string(forKey: "name")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        self.married.isOn = plist.bool(forKey: "married")

        // plist에 저장된 계정 목록을 현재 내부 변수에 대입하여 동기화
        let PlistAccountList = plist.array(forKey: "accountList") as? [String] ?? [String]()
        self.accountList = PlistAccountList

        // 이전에 마지막으로 선택한 계정 정보를 불러와서 현재 계정에 대입하여 동기화
        if let selectAccount = plist.string(forKey: "selectedAccount") {
            self.account.text = selectAccount

            // MARK: - custom plist 불러오기 로직 시작
            let customPlist = "\(account.text!).plist"  // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)

            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }

        // 사용자의 계정 값이 비어있다면 값을 설정하는 것을 막는다.
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }

        // 네비게이션 바에 newAccount 메소드와 연결된 버튼을 추가한다.
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add,target: self, action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
    }
// MARK: - 계정 선택 버튼
    @objc func pickerDone(_ sender : UIBarButtonItem) {
        // 입력뷰 종료
        self.view.endEditing(true)

        // MARK: - custom plist 불러오기 로직 시작
        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)

            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }

    }

// MARK: - 계정 추가 버튼
    @objc func newAccount(_ sender : UIBarButtonItem) {
        self.view.endEditing(true)

        let alert = UIAlertController(title: "새 계정을 입력하세요.", message: nil, preferredStyle: .alert)

        // 입력폼 추가
        alert.addTextField(configurationHandler: {$0.placeholder = "ex) abc@apple.com"})

        // 버튼 및 액션 정의
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default) { _ in
            if let account = alert.textFields?[0].text {
                if account != "" {
                    // 계정 목록에 배열을 추가한다
                    self.accountList.append(account)
                    // 계정 텍스트 필드에 표시한다.
                    self.account.text = account

                    // 컨트롤 값을 모두 초기화한다.
                    self.name.text = ""
                    self.gender.selectedSegmentIndex = 0
                    self.married.isOn = false

                    // 계정 정보를 통쨰로 저장한다.
                    let plist = UserDefaults.standard
                    plist.set(self.accountList, forKey: "accountList")
                    plist.set(account, forKey: "selectedAccount")
                    plist.synchronize()

                    // 입력 항목 활성화
                    self.gender.isEnabled = true
                    self.married.isEnabled = true
                }
            }
        })
        self.present(alert, animated: true)
    }

// MARK: - 테이블 뷰 델리게이트 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 두 번째 셀이 클릭되고, 계정이 입력된 상태일 때만 입력이 가능한 알림창을 띄워 이름을 수정할 수 있도록 한다.
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)

            alert.addTextField() {
                $0.text = self.name.text
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let value = alert.textFields?[0].text

                // MARK: - custom plist 저장 로직 시작
                let CustomPlist = "\(self.account.text!).plist"    // 읽어올 파일명
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [CustomPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)

                self.name.text = value
            })
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UIPickerView 델리게이트 메소드
extension ListViewController: UIPickerViewDelegate {

    // 지정된 컴포넌트의 목록 각 행에 출력될 내용을 정의
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }

    // 지정된 컴포넌트의 목록 강 행을 사용자가 선택했을 때 실행할 액션을 정의
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if self.accountList.isEmpty {
            return
        } else {
            // 1. 선택된 계정값을 텍스트 필드에 입력
            let account = self.accountList[row]
            self.account.text = account

            // 사용자가 계정을 선택하면 이 계정을 선택한 것으로 간주하고 저장
            let plist = UserDefaults.standard
            plist.set(account, forKey: "selectedAccount")
            plist.synchronize()
        }
    }
    
}

extension ListViewController: UIPickerViewDataSource {

    // 생성할 컴포넌트의 개수를 정의
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // 지정된 컴포넌트가 가질 목록의 길이를 정의
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count
    }

}
