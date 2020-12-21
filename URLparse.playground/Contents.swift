import UIKit

// 1. URL 생성
let url = "https://www.genie.co.kr/search/searchMain"

// 1-1. BaseURL을 기반으로 매번 쿼리를 변경하여 전송할 때
let baseURL = URL(string: url)
let relativeURL = URL(string: "query=lilboi", relativeTo: baseURL)

// 1-2. 쿼리 아이템을 인코딩할 때 사용
var urlComponents = URLComponents(string: url)!
var queryItem = URLQueryItem(name: "query", value: "릴보이")
urlComponents.queryItems?.append(queryItem)

urlComponents.url
urlComponents.string
urlComponents.queryItems

// 통신을 위한 URLSession 객체 생성
// 쿠키, 캐시 저장 안할 때
let epgmeral = URLSessionConfiguration.ephemeral
// 기본 세션
let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)

let requestURL = urlComponents.url

session.dataTask(with: requestURL!) { data, response, error in
    // 클라이언트에서의 에러
    guard error == nil else { return }

    // 서버 에러
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
    let successRange = 200..<300
    guard successRange.contains(statusCode) else {
        // 서버 에러 핸들링
        return
    }

    guard let resultData = data else { return }
    // JsonData > JsonObject
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: resultData, options: [])
        if let jsonDic = jsonObject as? [String:Any] {
            print(jsonDic["results"]!)
        }
    } catch {

    }
}

// 파싱 함수 리팩토링 1차 예시 ver
// Json 구조는 실제 API 링크와 다름
struct Track {
    let title: String
    let artistName: String
    let thumbnail: String
}

func parse(data: Data) -> [Track]? {
    do {
        let JsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        var parsedTrackList = [Track]()

        if let dictionary = JsonObject as? [String:Any], let tracks = dictionary["result"] as? [[String:Any]] {
            tracks.forEach({ (track: [String:Any]) in
                if let title = track["title"] as? String,
                   let artistname = track["artistName"] as? String,
                   let thumbnail = track["artworkUrl30"] as? String {
                    let track = Track(title: title, artistName: artistname, thumbnail: thumbnail)
                    parsedTrackList.append(track)
                }
            })
        }
        return parsedTrackList
    } catch{
        print(error)
        return nil
    }
}

// 파싱 함수 리팩토링 2차 예시 ver (failiable init 이용)
// Json 구조는 실제 API 링크와 다름
struct Track2 {
    let title: String
    let artistName: String
    let thumbnail: String

    init?(Json: [String:Any]) {
        guard let title = Json["trackName"] as? String,
              let artistName = Json["artistName"] as? String,
              let thumbnail = Json["artworkUrl30"] as? String else {
            return nil
        }
        self.title = title
        self.artistName = artistName
        self.thumbnail = thumbnail
    }
}

func parse2(data: Data) -> [Track2]? {
    do {
        let JsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        var parsedTrackList = [Track2]()

        if let dictionary = JsonObject as? [String:Any],
           let tracks = dictionary["result"] as? [[String:Any]] {
            // compactMap = 2차원 배열에서 옵셔널 바인딩, 1차원 배열에서 nil을 제거하고 옵셔널 바인딩 해제
            parsedTrackList = tracks.compactMap({ json in
                return Track2(Json: json)
            })
        }
        return parsedTrackList
    } catch{
        print(error)
        return nil
    }
}



// URLSessionTask
// dataTask
let dataTask = session.dataTask(with: URL(string: "http:www.google.com")!)
// uploadTask
// downloadTask
