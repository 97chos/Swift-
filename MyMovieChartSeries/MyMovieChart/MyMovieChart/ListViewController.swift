import UIKit

class ListViewController:UITableViewController {

    // 튜플 아이템을 가진 배열로 정의된 데이터 세트
/*
    var dataset = [
    ("다크나이트","마침내, 최강의 적을 만나다.","2008-09-04",8.95, "darknight.jpg"),
    ("호우시절","때를 알고 내리는 좋은 비","2009-10-08",7.31, "rain.jpg"),
    ("말할 수 없는 비밀","이제 사라지지마, 오직 너를 위해 연주할게.","2015-05-07",9.19, "secret.jpg")
    ]
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        for (title, desc, opendate, rating, thumbnail) in self.dataset {
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            
            datalist.append(mvo)
        }
        return datalist
    }()
  */
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        callMovieAPI()
        
        // 테이블 뷰를 갱신한다.
        self.tableView.reloadData()
    }
    
    var page = 1
    
    var list = [MovieVO]()
    
    override func viewDidLoad() {
       callMovieAPI()
    }
    
    @IBOutlet var moreBtn: UIButton!
    
    
    // 테이블 뷰 객체 및 행 갯수 생성값 반환 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 행 각각에 대한 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 읽어온다.
        let row = self.list[indexPath.row]
        
        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MoiveCell
        
        // 데이터 소스에 저장된 값을 각 아울렛 변수에 할당
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        // 로컬 이미지를 읽어오는 방식
        // cell.thumbnail?.image = UIImage(named: row.thumbnail!)
        
        // 이미지 객체 대입
        cell.thumbnail.image = row.thumbnailImage
        
        NSLog("제목:\(row.title!), 호출된 행번호: \(indexPath.row)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행 입니다.")
    }
    
    func callMovieAPI() {
        
        // 호핀 API 호출을 위한 URI를 생성
        let url = "http://115.68.183.178:2029/hoppin/movies?order=releasedateasc&count=30&page=\(self.page)&version=1&genreId="
        let apiURI: URL! = URL(string: url)

        //  REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        // JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            // 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
            for row in movie {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 테이블 뷰 리스트를 구성할 데이터 형식
                let mvo = MovieVO()
                
                // movie 배열의 각 데이터를 mvo 상수의 속성에 대입
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                //웹 상에 있는 이미지를 읽어와 UIImage 객체로 생성
                let url: URL! = URL(string: mvo.thumbnail!)
                let imagedata = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imagedata)
                // list 배열에 추가
                self.list.append(mvo)
                
                // 전체 데이터 카운트 획득
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                // totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
                if (self.list.count >= totalCount) {
                    self.moreBtn.setTitle("마지막 목록입니다.", for: .normal)
                }
            }
            
        } catch {
            NSLog("Parse Error!")
        }
    }
}

