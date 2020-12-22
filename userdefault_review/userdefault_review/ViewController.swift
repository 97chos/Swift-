//
//  ViewController.swift
//  userdefault_review
//
//  Created by sangho Cho on 2020/12/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let list = ["계정","이름","성별","결혼 여부"]
    var picker = UIPickerView()

    var account = UITextField()
    var name = UILabel()
    var sex = UISegmentedControl(items: ["남","여"])
    var married = UISwitch()

    var defaultPlist : NSDictionary!

    var accountList = [String]()

    let plist = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let defualtPlistPath = Bundle.main.path(forResource: "UserInfo", ofType: "Plist") {
            self.defaultPlist = NSDictionary(contentsOfFile: defualtPlistPath)
        }

        self.view.backgroundColor = .white
        self.navigationItem.title = "사용자 설정"

        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tv.tableFooterView = UIView()

        tv.delegate = self
        tv.dataSource = self

        self.view.addSubview(tv)

        if let account = plist.string(forKey: "seletedAccount") {
            self.account.text = account

            let customPlist = "\(account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)

            self.name.text = data?["name"] as? String
            self.sex.selectedSegmentIndex = data?["sex"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        accountList = self.plist.stringArray(forKey: "accountlist") ?? []

        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.sex.isEnabled = false
            self.married.isEnabled = false
        }

        picker.delegate = self

        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount))

        self.navigationItem.rightBarButtonItem = add
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField() {
                self.name.text = $0.text
            }
            alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
                guard alert.textFields?[0] != nil else { return }
                let value = (alert.textFields?[0].text)!

                let customPlist = "\(self.account.text!).plist"
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)

                self.plist.setValue(value, forKey: "name")
                self.plist.synchronize()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = list[indexPath.row]

            account.borderStyle = .none
            account.frame.size = CGSize(width: cell.frame.width * 0.25, height: cell.frame.height - 5)
            account.frame.origin = CGPoint(x: self.view.frame.width - account.frame.width - 20, y: 0)
            account.center.y = cell.frame.height / 2
            account.textAlignment = .right

            account.inputView = self.picker

            let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
            toolbar.barTintColor = .lightGray

            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount))
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            toolbar.setItems([add,flexSpace,done], animated: true)
            self.account.inputAccessoryView = toolbar

            account.placeholder = "계정 입력"
            cell.contentView.addSubview(account)

        case 1:
            cell.textLabel?.text = list[indexPath.row]

            name.text = self.plist.string(forKey: "name")
            name.sizeToFit()
            name.textAlignment = .right

            cell.contentView.addSubview(name)

            name.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(20)
                $0.centerY.equalToSuperview()
            }

        case 2:
            cell.textLabel?.text = list[indexPath.row]

            cell.contentView.addSubview(sex)
            sex.selectedSegmentIndex = self.plist.integer(forKey: "sex")
            sex.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)

            sex.frame.origin = CGPoint(x: self.view.frame.width - sex.frame.width - 20, y: 0)
            sex.center.y = cell.frame.height / 2

        case 3:
            cell.textLabel?.text = list[indexPath.row]

            cell.contentView.addSubview(married)
            married.isOn = self.plist.bool(forKey: "married")
            married.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)

            married.frame.origin = CGPoint(x: self.view.frame.width - married.frame.width - 20, y: 0)
            married.center.y = cell.frame.height / 2

        default: break
        }
        return cell
    }
}

extension ViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountList[row]
        self.account.text = account

        self.plist.setValue(account, forKey: "seletedAccount")
        self.plist.synchronize()
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accountList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }

}

extension ViewController {

    @objc func done() {
        self.view.endEditing(true)

        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)

            self.name.text = data?["name"] as? String
            self.sex.selectedSegmentIndex = data?["sex"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }

    @objc func newAccount() {
        self.view.endEditing(true)

        let alert = UIAlertController(title: "새 계정을 입력하세요.", message: nil, preferredStyle: .alert)

        alert.addTextField {
            $0.placeholder = "ex)abc@gmail.com"
        }

        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            if let text = alert.textFields?[0].text, text != "" {
                self.account.text = text
                self.accountList.append(text)

                self.plist.setValue(self.accountList, forKey: "accountlist")
                self.plist.synchronize()

                self.married.isOn = false
                self.sex.selectedSegmentIndex = 0
                self.name.text = ""

                self.plist.setValue(text, forKey: "seletedAccount")
                self.plist.synchronize()
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)

        self.sex.isEnabled = true
        self.married.isEnabled = true
    }

    @objc func changeValue(_ sender: Any) {
        if let sender = sender as? UISegmentedControl {

            let customPlist = "\(self.account.text!).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

            data.setValue(sender.selectedSegmentIndex, forKey: "sex")
            data.write(toFile: plist, atomically: true)

        } else if let sender = sender as? UISwitch {

            let customPlist = "\(self.account.text!).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPlist)

            data.setValue(sender.isOn, forKey: "married")
            data.write(toFile: plist, atomically: true)
        }
    }
}

