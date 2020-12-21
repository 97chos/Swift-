//
//  ViewController.swift
//  userdefault_review
//
//  Created by sangho Cho on 2020/12/21.
//

import UIKit

class ViewController: UIViewController {

    let list = ["계정","이름","성별","결혼 여부"]
    var picker = UIPickerView()
    var name: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.view.backgroundColor = .white

        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tv.tableFooterView = UIView()

        tv.delegate = self
        tv.dataSource = self

        self.view.addSubview(tv)

        picker.delegate = self

    }
}

extension ViewController: UITableViewDelegate {

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
            let account = UITextField()

            account.borderStyle = .none
            account.inputView = self.picker
            account.frame.size = CGSize(width: cell.frame.width * 0.25, height: cell.frame.height - 5)
            account.frame.origin = CGPoint(x: self.view.frame.width - account.frame.width - 20, y: 0)
            account.center.y = cell.frame.height / 2
            account.textAlignment = .right

            account.placeholder = "계정 입력"
            cell.contentView.addSubview(account)

        case 1:
            cell.textLabel?.text = list[indexPath.row]

            self.name = UILabel()
            name.text = "홍길동"
            name.sizeToFit()
            name.textAlignment = .right
            name.isUserInteractionEnabled = true

            name.frame.origin = CGPoint(x: self.view.frame.width - name.frame.width - 20, y: 0)
            name.center.y = cell.frame.height / 2

            cell.contentView.addSubview(name)

            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapping(_:)))
            name.addGestureRecognizer(gesture)

        case 2:
            cell.textLabel?.text = list[indexPath.row]
            let sex = UISegmentedControl(items: ["남","여"])

            cell.contentView.addSubview(sex)
            sex.selectedSegmentIndex = 0

            sex.frame.origin = CGPoint(x: self.view.frame.width - sex.frame.width - 20, y: 0)
            sex.center.y = cell.frame.height / 2

        case 3:
            cell.textLabel?.text = list[indexPath.row]
            let married = UISwitch()

            cell.contentView.addSubview(married)
            married.isOn = true

            married.frame.origin = CGPoint(x: self.view.frame.width - married.frame.width - 20, y: 0)
            married.center.y = cell.frame.height / 2

        default: break
        }
        return cell
    }
}

extension ViewController: UIPickerViewDelegate {

}

extension ViewController {
    @objc func tapping(_ sender: UILabel) {

        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
        alert.addTextField() {
            self.name.text = $0.text
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            guard alert.textFields?[0] != nil else { return }
            let value = (alert.textFields?[0].text)!
            self.name.text = value
            self.name.sizeToFit()
            self.name.frame.origin.x = self.view.frame.width - self.name.frame.width - 20
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
}

