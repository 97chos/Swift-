//
//  DepartmentInfoVC.swift
//  HRwithFMDB(programmically)
//
//  Created by sangho Cho on 2020/12/26.
//

import Foundation
import UIKit

class DepartmentInfoVC: UITableViewController {

    // 부서 정보를 저장할 데이터 타입
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)

    // 부서 목록으로부터 넘겨 받을 코드
    var departCd: Int!

    // DAO 객체
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()

    // 부서 정보와 사원 목록을 담을 멤버 변수
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!

    override func viewDidLoad() {
        self.departInfo = self.departDAO.get(departCd: self.departCd)
        self.empList = self.empDAO.find(departCd: departCd)
        self.navigationItem.title = self.departInfo.departTitle

        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return self.empList.count
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1. 헤더에 들어갈 객체 정의
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 2.5))
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 0.71, alpha: 1.0)

        // 2. 헤더에 들어갈 이미지 뷰 관리
        let icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))

        // 3. 섹션에 따라 타이틀과 이미지를 다르게 설정
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "소속 사원"
            icon.image = UIImage(named: "employee")
        }

        // 4. 레이블과 이미지 뷰를 담을 컨테이너 뷰 객체 정의
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.0)

        // 5. 뷰에 레이블과 이미지 뷰 추가
        v.addSubview(textHeader)
        v.addSubview(icon)

        return v
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "depart_cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "depart_cell")
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.detailTextLabel?.font = .systemFont(ofSize: 12)

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "부서코드"
                cell.detailTextLabel?.text = "\(self.departInfo.departCd)"

            case 1:
                cell.textLabel?.text = "부서명"
                cell.detailTextLabel?.text = self.departInfo.departTitle

            case 2:
                cell.textLabel?.text = "부서 주소"
                cell.detailTextLabel?.text = self.departInfo.departAddr

            default:
                ()
            }

            return cell
        } else {
            let row = self.empList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "emp_cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "emp_cell")

            cell.textLabel?.text = "\(row.empName) (입사일: \(row.joinDate))"
            cell.textLabel?.font = .systemFont(ofSize: 12)

            let state = UISegmentedControl(items: [(EmpStateType(rawValue: 0)?.desc())!, (EmpStateType(rawValue: 1)?.desc())!, (EmpStateType(rawValue: 2)?.desc())!])
            state.selectedSegmentIndex = row.stateCd.rawValue

            cell.contentView.addSubview(state)
            state.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                state.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10),
                state.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
            ])

            // 액션 메소드에서 참조할 수 있도록 사원 코드 저장
            state.tag = row.empCd
            state.addTarget(self, action: #selector(self.changeState(_:)), for: .valueChanged)

            return cell
        }
    }

    @objc func changeState(_ sender : UISegmentedControl) {

        let empCd = sender.tag
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex)

        // 재직 상태 업데이트
        if self.empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직 상태가 변경되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
}
