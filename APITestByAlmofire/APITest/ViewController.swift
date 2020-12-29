//
//  ViewController.swift
//  APITest
//
//  Created by sangho Cho on 2020/12/29.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    //MARK: - GET 방식의 Alamofire 호출
    @IBAction func callCurrentTime(_ sender: Any) {

        // 1. URL 설정 및 GET 방식으로 API 호출
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")

        AF.request(url!).responseString() { response in
            self.responsView.text = """
                response result :\n\(response.result) \n
                response value :\n\(response.value!) \n
                response requset :\n\(response.request!) \n
                response URLresponse :\n\(response.response!)
                """
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
        let param: Parameters = [
            "userId" : userId,
            "name" : name
        ]

        // 2. URL 객체 정의
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/echo"

        let alamo = AF.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody)

        alamo.responseJSON { response in
            print("JSON value= \(response.value!)")
            print("JSON result get=\(try! response.result.get())")
            if let jsonObject = try! response.result.get() as? [String: Any] {
                self.responsView.text = "userId : \(jsonObject["userId"] as! String) \n name : \(jsonObject["name"] as! String)"
            }
        }
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

