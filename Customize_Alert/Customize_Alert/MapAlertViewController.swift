//
//  MapAlertViewController.swift
//  Customize_Alert
//
//  Created by sangho Cho on 2020/11/28.
//

import Foundation
import UIKit
import MapKit

class MapAlertViewController: UIViewController {
    override func viewDidLoad() {

        let alertBtn = UIButton(type: .system)
        let imageBtn = UIButton(type: .system)
        let sliderBtn = UIButton(type: .system)
        let listBtn = UIButton(type: .system)

        alertBtn.frame = CGRect(x: 0, y: 150, width: 100, height: 30)
        alertBtn.center.x = self.view.frame.width / 2
        alertBtn.setTitle("Map Alert", for: .normal)
        alertBtn.addTarget(self, action: #selector(mapAlert(_:)), for: .touchUpInside)

        imageBtn.frame = CGRect(x: 0, y: 200, width: 100, height: 30)
        imageBtn.center.x = self.view.frame.width / 2
        imageBtn.setTitle("Image Alert", for: .normal)
        imageBtn.addTarget(self, action: #selector(imageAlert(_:)), for: .touchUpInside)

        sliderBtn.frame = CGRect(x: 0, y: 250, width: 100, height: 30)
        sliderBtn.center.x = self.view.frame.width / 2
        sliderBtn.setTitle("Slider Alert", for: .normal)
        sliderBtn.addTarget(self, action: #selector(sliderAlert(_:)), for: .touchUpInside)

        listBtn.frame = CGRect(x: 0, y: 300, width: 100, height: 30)
        listBtn.center.x = self.view.frame.width / 2
        listBtn.setTitle("List Alert", for: .normal)
        listBtn.addTarget(self, action: #selector(listAlert(_:)), for: .touchUpInside)


        self.view.addSubview(alertBtn)
        self.view.addSubview(imageBtn)
        self.view.addSubview(sliderBtn)
        self.view.addSubview(listBtn)

    }

    @objc func mapAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "위치를 확인하세요.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        // 콘텐츠 뷰 영역에 들어갈 뷰 컨트롤러를 생성한다.
        let contentVC = MapKitViewController()

        // 뷰 컨트롤러를 알림창의 콘텐츠 뷰 컨트롤러 속성에 등록한다
        alert.setValue(contentVC, forKey: "contentViewController")

        self.present(alert, animated: true)
    }

    @objc func imageAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil,
                                      message: "이번 글의 평점은 다음과 같습니다.",
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)

        let contentVC = ImageViewController()
        alert.setValue(contentVC, forKey: "ContentViewController")

        self.present(alert, animated: true)

    }

    @objc func sliderAlert(_ sender: UIButton) {

        let contentVC = ControlViewContoller()
        let alert = UIAlertController(title: nil,
                                      message: "이번 글의 평점을 입력해주세요.",
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            print(">>> sliderValue = \(contentVC.sliderValue)")
        }

        alert.addAction(okAction)

        alert.setValue(contentVC, forKey: "ContentViewController")

        self.present(alert, animated: true)
    }

    @objc func listAlert(_ sender: UIButton) {

        let contentVC = ListViewController()
        contentVC.delegate = self

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)

        alert.setValue(contentVC, forKey: "ContentViewController")

        self.present(alert, animated: true)

    }

    func didSelectRowAt(indexPath: IndexPath) {
        print(">>> 선택된 행은 \(indexPath.row)입니다.")
    }

}
