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
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mvo: MovieVO!
    
    override func viewDidLoad() {
        // WKNavigationDeleagte의 델리게이트 객체를 지정
        self.wv.navigationDelegate = self
        
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

// MARK: - WKNavigationDelegate 프로토콜 구현
extension DetailViewController: WKNavigationDelegate {
    // 웹뷰가 컨텐츠를 불러오기 시작하는 시점에 호출되는 메소드
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating() // 인디케이터 뷰의 애니메이션 실행
    }
    // 웹뷰 로딩 완료시 호출되는 메소드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating() // 인디케이터 뷰의 애니메이션 중지
    }
    // 웹뷰 로딩 실패시 호출되는 메소드
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating() // 인디케이터 뷰의 애니메이션 중지
        
        // 오류 경고창 표시
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel) { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    // 오류 처리에 따라 웹뷰 로딩 실패 시 호출되는 메소드
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        
        // 오류 경고창 표시
        let alert = UIAlertController(title: "오류", message: "상세페이지를 읽어오지 못했습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel) { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
