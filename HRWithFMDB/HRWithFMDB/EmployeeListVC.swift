//
//  EmployeeListVC.swift
//  HRWithFMDB
//
//  Created by sangho Cho on 2020/12/06.
//

import Foundation
import UIKit

class EmployeeListVC: UITableViewController {
    // 데이터 소스를 저장할 멤버 변수
    var empList : [EmployeeVO]!
    // SQLite 처리를 담당할 DAO 클래스
    var empDAO = EmployeeDAO()

    @IBAction func add(_ sender: Any) {

        let alert = UIAlertController(title: "사원 등록",
                                      message: "등록할 사원 정보를 입력하세요.",
                                      preferredStyle: .alert)

        alert.addTextField() {
            $0.placeholder = "사원명"
        }

        // contentViewController 영역에 부서 선택 피커 뷰 삽입
        let pickerVC = PickerController()
        alert.setValue(pickerVC, forKey: "contentViewController")

        // 등록창 버튼 처리
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in

            // 1. 알림창의 입력 필드에서 값을 읽어온다.
            var param = EmployeeVO()
            param.departCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!

            // 2. 가입일은 오늘로 한다.
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())

            // 3. 재직 상태는 '재직중'으로 한다.
            param.stateCd = EmpStateType.ING

            // 4. DB 처리
            if self.empDAO.create(param: param) {
                // 4-1. 결과가 성공하면 다시 읽어들여 테이블 뷰를 갱신
                self.empList = self.empDAO.find()
                self.tableView.reloadData()

                // 4-2. 네비게이션 타이틀 갱신
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원 목록 \n" + " 총 : \(self.empList.count)"
                }
            }
        })

        self.present(alert, animated: true)
    }

    @IBAction func editting(_ sender: Any) {
        if self.isEditing == false {                            // 현재 편집 모드가 아닐 때
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {                                                // 현재 편집 모드일 때
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    // 목록 편집 형식을 결정하는 메소드 (삽입 / 삭제)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         // 1. 삭제할 행의 empCd를 구한다.
        let empCd = self.empList[indexPath.row].empCd

        // 2. DB, 데이터소스, 테이블 뷰에서 차례대로 삭제
        if empDAO.remove(empCd: empCd) {
            empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

    override func viewDidLoad() {
        empList = empDAO.find()
        initUI()
    }

    

    // UI 초기화 함수
    func initUI() {
        // 네비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.text = "사원 목록 \n" + " 총 : \(self.empList.count)"
        navTitle.font = .systemFont(ofSize: 14)
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center

        self.navigationItem.titleView = navTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "EMP_CELL")

        cell.textLabel?.text = rowData.empName + "\(rowData.stateCd.desc())"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

        cell.detailTextLabel?.text = rowData.departTitle
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)

        return cell
    }
}
