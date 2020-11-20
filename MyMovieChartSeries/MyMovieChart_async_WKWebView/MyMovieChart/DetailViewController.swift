//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by 조상호 on 2020/10/27.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet var wv: WKWebView!

    var mvo: MovieVO!
    
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo.detail!), title=\(self.mvo.title!)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        if let url = self.mvo.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            } else { // URL 형식이 잘못되었을 경우에 대한 예외처리
                // 경고창 형식으로 오류메세지 표시
                let alert = UIAlertController(title: "오류", message: "잘못된 URL 입니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        } else { // URL 값이 전달되지 않았을 경우에 대한 예외처리
            // 경고창 형식으로 오류메세지를 표시해준다.
            let alert = UIAlertController(title: "확인", message: "함수 파라미터가 누락되었습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
