//
//  ViewController.swift
//  UseSQLite3
//
//  Created by sangho Cho on 2020/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var db: OpaquePointer? = nil            // SQLite 연결 정보를 담을 객체
        var stmt: OpaquePointer? = nil          // 컴파일 된 SQL를 담을 객체

        // 앱 내 데이터베이스 파일 경로 획득 메소드
        let dbPath = self.getDBPath()

        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"           // TABLE IF NOT EXISTS : 앱 실행 시마다 테이블이 생성되는 것을 방지

        // DB 객체 생성 및 연결 햠수 / 첫 번째 인자값: DB 경로, 두 번째 인자값: 생성된 DB 객체를 전달받을 변수
        if sqlite3_open(dbPath, &db) == SQLITE_OK {

            // SQL 구문 작성 및 컴파일 함수 / 첫 번째 인자값: 생성된 DB 객체, 두 번째 인자값: 실행할 SQL 구문 텍스트, 네 번째 인자값: 반환할 컴파일된 SQL 객체
            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
                // 컴파일된 SQL 구문 실행
                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Cerate Table Success!")
                }
                // stmt 해제
                sqlite3_finalize(stmt)
            } else {
                print("Prepare Statement Fail")
            }
            // db 해제
            sqlite3_close(db)
        } else {
            print("Database Connect Fail")
            return
        }

    }

    func getDBPath() -> String {
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일 검색
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .userDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path

        // dbPath 경로에 파일이 없다면(최초 실행 시) 앱 번들에 만들어 둔 db.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }

        return dbPath
    }


}

