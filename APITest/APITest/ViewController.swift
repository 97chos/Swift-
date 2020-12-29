//
//  ViewController.swift
//  APITest
//
//  Created by sangho Cho on 2020/12/29.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - GET 방식의 API 호출
    @IBOutlet weak var currentTime: UILabel!
    @IBAction func callCurrentTime(_ sender: Any) {

        do {
            // 1. URL 설정 및 GET 방식으로 API 호출
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")

            let response = try String(contentsOf: url!)

            // 2. 읽어온 값을 레이블에 표시
            self.currentTime.text = response
            self.currentTime.sizeToFit()
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }

    @IBOutlet weak var UserId: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var responsView: UITextView!

    //MARK: - POST 방식의 API 호출
    @IBAction func post(_ sender: Any) {
        // 1. 전송할 값 준비
        let userId = (self.UserId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8)            // 한글, 특수문자 인코딩 작업 (data 메소드)

        // 2. URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")

        // 3. URLRequest 객체를 정의하고, 요청 내용을 담는다.
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData

        // 4. HTTP 메세지 헤더 설정
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 실행
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 5-1. 서버가 응답이 없거나 통신 실패 시
            if let e = error {
                NSLog("An error has occured : \(e.localizedDescription)")
                return
            }
            // 5-2. 응답 처리 로직
            // 메인 스레드에서 비동기로 처리
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary

                    guard let jsonObject = object else { return }

                    let result = jsonObject["result"] as? String
                    let timeStamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String

                    if result == "SUCCESS" {
                        self.responsView.text = "아이디 : \(userId!)" + "\n" + "이름 : \(name!)" + "\n" + "응답결과 : \(result!)" + "\n" + "응답시간 : \(timeStamp!)" + "\n" + "요청방식 : x-www-form-urlencoded)"
                    }
                } catch let e as NSError {
                    print("An error has occured while parsing JSONObject : \(e.localizedDescription)")
                }
            }
        }
        // 6. POST 전송
        task.resume()
    }

    // MARK: - JSON 방식의 API 호출

    @IBAction func json(_ sender: Any) {
        // 1. 전송할 값 준비
        let userId = (self.UserId.text)!
        let name = (self.name.text)!
        let param = ["userId" : userId, "name" : name]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

        // 2. URL 객체 정의
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")

        // 3. URLRequest 객체 정의 및 요청 내용 정리
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData

        // 4. HTTP 메세지에 포함될 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")

        // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            // 서버와 통신 실패 (클라이언트 에러)
            guard error == nil else { return }

            // 서버 에러
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            let successRange = 200..<500
            guard successRange.contains(statusCode) else { return }

            guard let resultData = data else { return }

            DispatchQueue.main.async {
                do {
                    let _jsonObject = try JSONSerialization.jsonObject(with: resultData, options: []) as? NSDictionary

                    guard let jsonObject = _jsonObject else { return }

                    let result = jsonObject["result"] as? String
                    let timeStamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String

                    if result == "SUCCESS" {
                        self.responsView.text = "아이디 : \(userId!)" + "\n" + "이름 : \(name!)" + "\n" + "응답결과 : \(result!)" + "\n" + "응답시간 : \(timeStamp!)" + "\n" + "응답 코드 : \(statusCode)" + "\n" + "요청방식 : application/json"
                    }
                } catch let e as NSError {
                    print("An error has occured while parsing JSONObject : \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

