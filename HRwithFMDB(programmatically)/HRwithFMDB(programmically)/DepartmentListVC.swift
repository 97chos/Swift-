//
//  DepartmentListVC.swift
//  HRwithFMDB(programmically)
//
//  Created by sangho Cho on 2020/12/25.
//

import UIKit

class DepartmentListVC: UITableViewController {

    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!         // 데이터 소스용 멤버 변수
    let departDAO = DepartmentDAO()                                                     // SQLite 처리를 담당할 DAO 객체
    var subTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.departList = self.departDAO.find()
        self.initUI()
    }

    func initUI() {
        // footerView 설정
        self.tableView.tableFooterView = UIView()

        // 1. 네비게이션 타이틀용 레이블 속성 설정
        let navTitle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: (self.navigationController?.navigationBar.frame.height)!))
        let title = UILabel()
        self.subTitle = UILabel()

        title.text = "부서 목록"
        title.sizeToFit()
        title.font = .systemFont(ofSize: 16)

        subTitle.text = "총 \(self.departList.count)개"
        subTitle.sizeToFit()
        subTitle.font = .systemFont(ofSize: 14)

        navTitle.addSubview(title)
        navTitle.addSubview(subTitle)

        self.navigationItem.titleView = navTitle

        title.translatesAutoresizingMaskIntoConstraints = false
        subTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navTitle.centerXAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!),
            title.topAnchor.constraint(equalTo: navTitle.topAnchor),
            title.centerXAnchor.constraint(equalTo: navTitle.centerXAnchor),
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            subTitle.centerXAnchor.constraint(equalTo: navTitle.centerXAnchor)
        ])

        // 2. 네비게이션 바 편집 모드 버튼 설정
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        // 3. 스와이프 시 편집모드 동작되도록 수정
        // self.tableView.allowsSelectionDuringEditing = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath 매개변수가 가리키는 행에 대한 데이터를 읽어온다.
        let rowData = self.departList[indexPath.row]

        // 셀 객체를 생성하고 데이터를 배치
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DEPART_CELL")

        cell.textLabel?.text = rowData.departTitle
        cell.detailTextLabel?.text = rowData.departAddr

        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.departDAO.remove(departCd: departList[indexPath.row].departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            // 네비게이션 타이틀에 변경된 부서 정보 반영
            let navTitle = self.subTitle
            navTitle?.text = "총 \(self.departList.count)개"
        }
    }

    // 신규 버튼 추가 메소드
    @objc func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "신규 부서 등록",message: "신규 부서를 등록해주세요.", preferredStyle: .alert)

        alert.addTextField { $0.placeholder = "부서명" }
        alert.addTextField { $0.placeholder = "주소"}

        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text

            if self.departDAO.create(title: title!, addr: addr!) {
                // 신규 부서가 등록되면 DB에서 목록을 다시 읽어온 후, 테이블을 갱신
                self.departList = self.departDAO.find()
                self.tableView.reloadData()

                // 네비게이션 타이틀에 변경된 부서 정보 반영
                let navTitle = self.subTitle
                navTitle?.text = "총 \(self.departList.count)개"

            }
        })

        self.present(alert, animated: true)
    }

}

