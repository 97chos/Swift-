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
    // 새로고침 컨트롤에 들어갈 이미지 뷰, 컨테이너 뷰, 텍스트 레이블
    var loadingImg: UIImageView!
    var loadContainer: UIView!
    var loadTitle: UILabel!
    // 임계점에 도달했을 때 나타날 배경 뷰, 노란 원 형태
    var bgCircle: UIView!
    // 스크롤을 당기는 도중이 아닌 손가락을 뗴어 냈을 때 PTR이 동작하도록 하기 위한 변수
    var refreshActive = false

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
                    navTitle.text = "사원 목록 \n" + "총 \(self.empList.count)명"
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

        let navTitle = self.navigationItem.titleView as? UILabel
        navTitle?.text = "사원 목록 \n" + "총 \(self.empList.count)명"
    }

    override func viewDidLoad() {
        empList = empDAO.find()
        initUI()

        // MARK: - 당겨서 새로고침 기능 구현 (refreshControl & refreshControl 커스터마이징)

        // 1. refreshControl 사용
        // 테이블 뷰 컨트롤러의 refreshControl 속성에 UIRefreshControl() 객체 생성
        // self.refreshControl = UIRefreshControl()
        // refreshControl 동작 타이틀 설정
        // self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        // self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

        // 2. 커스터마이징
        // 테이블 뷰 컨트롤러의 refreshControl 속성에 UIRefreshControl() 객체 생성
        self.refreshControl = UIRefreshControl()
        // 로딩뷰 초기화 & 중앙 정렬
        self.loadContainer = UIView(frame: CGRect(x: 0, y: 0, width: (self.refreshControl?.frame.width)!,
                                                  height: 110))

        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.loadContainer?.frame.width)! / 2

        self.loadTitle = UILabel()
        self.loadTitle.text = "당겨서 새로고침"
        self.loadTitle.font = .systemFont(ofSize: 14)
        self.loadTitle.sizeToFit()
        self.loadTitle.center.x = (self.loadContainer?.frame.width)! / 2
        self.loadTitle.frame.origin.y = self.loadingImg.frame.height + 10
        self.loadTitle.textAlignment = .center

        self.loadContainer.addSubview(loadTitle)
        self.loadContainer.addSubview(loadingImg)

        // refreshControl 속성에 액션 메소드 추가
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)

        // 기존 생성되어 있는 refreshControl 뷰의 인디케이터 tintColor를 투명하게 설정하여 안 보이게 설정
        self.refreshControl?.tintColor = .clear
        self.refreshControl?.addSubview(self.loadContainer)

        // 1. 배경 뷰 초기화 및 노란 원 형태를 위한 속성 설정
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = .systemYellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2

        // 2. 배경 뷰를 refreshControll 객체에 추가하고, 로딩 이미지를 제일 위로 올림
        self.refreshControl?.addSubview(bgCircle)
        self.refreshControl?.bringSubviewToFront(self.loadContainer)

    }

    // 새로고침 시 동작되는 내용
    @objc func pullToRefresh(_ sender: Any) {
        self.refreshActive = true
        self.loadTitle.text = "손가락을 놓으면 업데이트가 시작됩니다."
        self.loadTitle.sizeToFit()
        self.loadTitle.center.x = self.loadContainer.frame.width / 2
        // 당겨서 새로고침 기능 종료
        self.refreshControl?.endRefreshing()

        // 노란 원이 로딩 이미지를 중심으로 커지는 애니메이션
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5) {
            self.bgCircle.frame.size = CGSize(width: 80, height: 80)
            self.bgCircle.center.y = distance / 2
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle.frame.size.width) / 2
        }
    }

    // 스크롤이 발생할 때마다 구현될 내용을 작성
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 당긴 거리 (max : 둘 중 큰 값을 반환)
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)

        print("subview frame : \(Int((self.refreshControl?.frame.origin.y)!))")
        print("superview bounds: \(Int(self.tableView.bounds.origin.y))")

        // center.y 좌표를 당긴 거리만큼수정
        self.loadContainer.center.y = distance / 2

        // 당긴 거리를 회전 각도로 반환하여 로딩 이미지에 설정한다.
        // CGAffineTransform : CGFloat 타입을 입력받아 회전 각도를 반환하는 메소드
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadingImg.transform = ts

        // 배경 뷰의 중심 좌표 설정
        bgCircle.center.y = distance / 2
    }

    // 스크롤 종료 시 호출되는 메소드
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshActive {
            self.empList = self.empDAO.find()
            self.tableView.reloadData()
            self.refreshActive = false
            self.loadTitle.text = "당겨서 새로고침"
            self.loadTitle.center.x = self.loadContainer.frame.width / 2
        }
        // 노란 원 초기화
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
    }

    // UI 초기화 함수
    func initUI() {
        // 네비게이션 타이틀용 레이블 속성 설정
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.text = "사원 목록 \n" + "총 \(self.empList.count)명"
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

        cell.textLabel?.text = rowData.empName + " (\(rowData.stateCd.desc()))"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)

        cell.detailTextLabel?.text = rowData.departTitle
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)

        return cell
    }
}
