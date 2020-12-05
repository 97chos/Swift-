//
//  ViewController.swift
//  SQLite3
//
//  Created by sangho Cho on 2020/12/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        // sqlite 파일 경로 획득
        let dbPath = self.getDBPath()
        // sqlite 테이블 생성 메소드
        dbExecute(dbPath: dbPath)
    }

    func getDBPath() -> String {
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일 탐색
        // FileManager() = 파일과 관련된 여러가지 작업을 처리하는데 필요한 객체
        let fileMgr = FileManager()

        // FileManager 객체를 통해 앱 내부 범위에서 문서 디렉터리 위치를 URL형태로 반환. 조건을 만족하는 모든 경로를 배열 형태로 제공하지만, 문서 디렉터리는 무조건 첫 번째 값을 객체로 지정
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!

        // 얻은 문서 디렉터리 정보에 SQLite 파일 이름인 db.splite를 덧붙여 SQLite3 데이터베이스 파일의 전체 경로 획득
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path

        // 앱 최초 실행 시 한 번만 실행
        // dbPath 경로에 db.sqlite 파일이 없다면 해당 경로에 앱 번들에 만들어 둔 데이터 템플릿인 db.sqlite를 가져와서 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "splite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        return dbPath
    }

    func dbExecute(dbPath: String) {

        var db: OpaquePointer? = nil        // SQLite 연결 정보를 담을 객체

        // 테이블을 생성하는 DDL 구문
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"

        // 데이터 베이스가 연결 확인
        // 획득한 경로로 데이터 베이스 파일을 찾고, 구조체 타입(OpaquePointer)인 db 변수를 참조 타입으로 변경하여 연결 정보 결과를 담아 인자값을 전달
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("Database Connect Fail")
            return
        }

        // 지연 함수를 통해 함수 종료 직전 데이터베이스 연결 종료
        defer {
            print("Close Database Connection")
            sqlite3_close(db)                               // DB 연결 해제
        }

        var stmt: OpaquePointer? = nil      // 컴파일된 SQL을 담을 객체

        // SQL 컴파일이 잘 끝났는지 확인
        // db: 현재 연결된 데이터 베이스 객체 정보, sql: 컴파일할 SQL 구문, stmt: 컴파일된 SQL을 데이터 베이스에 전달될 수 있는 stmt 객체로 생성하여 &stmt 인자값에 담아 반환
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK  else {
            print("Prepare Statement Fail")
            return
        }

        // 지연 함수를 통해 함수 종료 직전 stmt 변수 연결 해제
        defer {
            print("Finalize Statement")
            sqlite3_finalize(stmt)                  // SQL 컴파일 객체 해제
        }

        // 컴파일된 SQL 객체를 받아 데이터 베이스에 전달, 함수 실행 완료 시점에서 테이블 생성 완료
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Create Table Success!")
        }
    }
}

