import Foundation

func download(url: String, completionHandler: @escaping (String) -> ()) {
    print("다운로드 중")
    print("다운로드 중.")
    print("다운로드 중..")
    print("다운로드 중...")

    DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1) {
        let result: String = "<html>완료</html>"
        print("다운로드 완료", result)

        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1) {
            completionHandler(result)
        }
    }
}

download(url: "https://facebook.com") { downloaded in
    print("다운 받은 결과는", downloaded, "입니다.")
}
