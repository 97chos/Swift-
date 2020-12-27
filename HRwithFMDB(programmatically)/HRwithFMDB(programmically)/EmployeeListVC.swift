//
//  EmployeeListVC.swift
//  HRwithFMDB(programmically)
//
//  Created by sangho Cho on 2020/12/25.
//

import Foundation
import UIKit

class EmployeeListVC: UITableViewController {

    // 데이터 소스를 저장할 멤버 변수
    var empList: [EmployeeVO]!
    // SQLite 처리를 담당할 DAO 클래스
    var empDAO = EmployeeDAO()
    var subtitle: UILabel!
    var loadImage: UIImageView!

    override func viewDidLoad() {
        self.empList = empDAO.find()
        initUI()

        // PTR 기능
        self.refreshControl = UIRefreshControl()
        // self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.loadImage = UIImageView(image: UIImage(named: "refresh"))
        self.loadImage.center.x = (self.refreshControl?.frame.width)! / 2
        print((self.refreshControl?.frame.width)!)

        self.refreshControl?.tintColor = .clear
        self.refreshControl?.addSubview(loadImage)
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }

    func initUI() {

        self.tableView.tableFooterView = UIView()

        // 네비게이션 타이틀용 레이블 속성 설정
        let navTitle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: (self.navigationController?.navigationBar.frame.height)!))
        let title = UILabel()
        self.subtitle = UILabel()

        title.text = "사원 목록"
        title.font = .systemFont(ofSize: 16)
        title.sizeToFit()

        subtitle.text = "총 \(self.empList.count)명"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.sizeToFit()

        navTitle.addSubview(title)
        navTitle.addSubview(subtitle)
        navTitle.sizeToFit()

        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        self.navigationItem.titleView = navTitle

        NSLayoutConstraint.activate([
            navTitle.centerXAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!),
            title.topAnchor.constraint(equalTo: navTitle.topAnchor),
            title.centerXAnchor.constraint(equalTo: navTitle.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            subtitle.centerXAnchor.constraint(equalTo: title.centerXAnchor)
        ])

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "EMP_CELL")

        cell.textLabel?.text = "\(rowData.empName) : \(rowData.stateCd.desc())"
        cell.detailTextLabel?.text = rowData.departTitle

        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)

        return cell
    }

    // 편집 버튼 클릭 시 호출되는 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let empCd = self.empList[indexPath.row].empCd

        // 2. DB, 데이터 소스, 테이블 뷰에서 삭제
        if self.empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }

    @objc func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "사원 등록", message: "등록할 사원 정보를 입력하세요.", preferredStyle: .alert)

        alert.addTextField {
            $0.placeholder = "사원명"
        }

        // contentViewController 영역에 부서 선택 피커 뷰 삽입
        let pickerVC = PickerViewController()
        alert.setValue(pickerVC, forKey: "contentViewController")

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in

            // 1. 알림창의 입력 필드에서 값 읽어오기
            var param = EmployeeVO()
            param.departCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!

            // 2. 가입일은 현재 날짜로 생성
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())

            // 3. 재직 상태는 '재직중'으로 설정
            param.stateCd = EmpStateType.ING

            // 4. DB 처리
            if self.empDAO.create(param: param) {
                // 4-1. 결과가 성공하면 데이터를 다시 읽어 테이블 뷰를 갱신
                self.empList = self.empDAO.find()
                self.tableView.reloadData()

                // 4-2. 네비게이션 타이틀 갱신
                self.subtitle.text = "총 \(self.empList.count)명"
            }
        })

        self.present(alert, animated: true)
    }

    @objc func pullToRefresh(_ sender: Any) {
        self.empList = self.empDAO.find()
        self.tableView.reloadData()

        self.refreshControl?.endRefreshing()
    }

    // 스크롤 할 때마다 호출되는 메소드
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 당긴 거리
        let distance = max(0, -(self.refreshControl?.frame.origin.y)!)

        self.loadImage.center.y = distance / 2

        // 당긴 거리만큼 회전 각도로 반환하여 로딩 이미지에 설정
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadImage.transform = ts
    }
}

