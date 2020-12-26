//
//  PickerViewController.swift
//  HRwithFMDB(programmically)
//
//  Created by sangho Cho on 2020/12/26.
//

import Foundation
import UIKit

class PickerViewController: UIViewController {
    let departDAO = DepartmentDAO()
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    var pickerView: UIPickerView!

    // 현재 피커뷰에 선택되어 있는 부서의 코드를 가져오는 연산 프로퍼티
    var selectedDepartCd: Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departList[row].departCd
    }

    override func viewDidLoad() {
        // 1. DB에서 부서 목록을 가져와 튜플 배열 초기화
        self.departList = self.departDAO.find()

        // 2. 피커뷰 객체 초기화
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.view.addSubview(pickerView)

        // 3. 외부에서 뷰 컨트롤러를 참조할 때를 위한 사이즈 지정
        let pWidth = self.pickerView.frame.width
        let pHeight = self.pickerView.frame.height
        self.preferredContentSize = CGSize(width: pWidth, height: pHeight)

    }
}

extension PickerViewController: UIPickerViewDataSource {

    // 피커뷰에 표시될 컴포넌트의 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // 컴포넌트 행의 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.departList.count
    }

    // 피커뷰 각 행의 타이틀 설정
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // view = 재사용 뷰 (default = UIView)
        var titleView = view as? UILabel

        // 캐스팅 실패 시 새로운 UILbel 객체 생성
        if titleView == nil {
            titleView = UILabel()
            titleView?.font = .systemFont(ofSize: 14)
            titleView?.textAlignment = .center
        }

        titleView?.text = "\(self.departList[row].departTitle)(\(self.departList[row].departAddr)"

        return titleView!
    }


}

extension PickerViewController: UIPickerViewDelegate {

}
