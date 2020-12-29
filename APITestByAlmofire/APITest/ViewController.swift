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
        let param: Parameters = ["userId" : userId, "name" : name]

        // 2. URL 객체 정의
        let url = "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON"

        // 3. URLRequest 객체 정의 및 요청 내용 정리
        let alamo = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)

        alamo.responseJSON { res in
            print("res : \(res)")
            let value = res.value
            let result = res.result
            let get = try! res.result.get()

            print("value: \(value)")
            print("result: \(result)")
            print("get: \(get)")

            if let jsonObject = try! res.result.get() as? [String : Any] {
                self.responsView.text = "userId : \(jsonObject["userId"] as! String) \nname : \(jsonObject["name"] as! String) \ntimestamp : \(jsonObject["timestamp"] as! String)"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

