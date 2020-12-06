//
//  DepartmentDAO.swift
//  HRWithFMDB
//
//  Created by sangho Cho on 2020/12/06.
//

import Foundation

class DepartmentDAO {
    // 부서 정보를 담을 튜플 타입 정의
    typealias DepartRecord = (Int, String, String)

    // SQLite 연결 및 초기화
    lazy var fmdb : FMDatabase! = {
        // 1. 파일 매니저 객체를 전달
        let fileMgr = FileManager.default

        // 2. 샌드박스 내 문서 디렉터리에서 데이터 베이스 파일 경로를 획득
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path

        // 3. 샌드박스 경로에 파일이 없다면 메인 번들에 만들어 둔 hr.sqlite를 가져와 해당 경로에 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }

        // 4. 준비된 데이터베이스 파일을 바탕으로 FMDatebase 객체를 갱신
        let db = FMDatabase(path: dbPath)
        return db

    }()

    init() {
        self.fmdb.open()
    }
    deinit {
        self.fmdb.close()
    }

    // 가져온 DB에게 데이터 쿼리를 요청하여 결과 집합을 반환받는 메소드
    func find() -> [DepartRecord] {
        // 반환할 데이터를 담을 [DepartRecord] 타입의 객체 정의
        var departList = [DepartRecord]()

        do {
            // 1. 부서 정보 목록을 가져올 SQL 작성 및 쿼리 실행
            let sql = """
                SELECT depart_cd, depart_title, depart_addr FROM department
                ORDER BY depart_cd ASC
            """

            let rs = try self.fmdb.executeQuery(sql, values: nil)

            // 2. 결과 집합 추출
            while rs.next() {
                let departCd = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                let departAddr = rs.string(forColumn: "depart_addr")

                departList.append((Int(departCd),departTitle!,departAddr!))
            }
        } catch let error as NSError {
            print("Failed: \(error.localizedDescription)")
        }
        return departList
    }

    // departCd를 이용하여 단일 테이블 지정 반환
    func get(departCd: Int) -> DepartRecord? {
        // 1. 질의 실행
        let sql = """
            SELECT depart_cd, depart_title, depart_addr FROM department
            WHERE depart_cd = ?
        """

        // executeQuery(_:withArgumentsIn:) = 옵셔널 타입 반환
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])

        // 2. 결과 집합 처리
        if let _rs = rs {           // 결과 집합이 옵셔널 타입으로 반환되므로 이를 상수에 대입하여 옵셔널 해제
            //MARK: - .next() 구문 동작 확인
            _rs.next()

            let departId = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr = _rs.string(forColumn: "depart_addr")

            return ((Int(departId),departTitle!,departAddr!))
        } else {
            return nil
        }
    }

    // 부서 정보 생성 메소드
    func create(title: String, addr: String) -> Bool {
        guard title != "" && addr != "" else {
            return false
        }

        do {
            let sql = """
                INSERT INTO department (depart_title, depart_addr)
                VALUES (?,?)
            """
            try self.fmdb.executeUpdate(sql, values: [title,addr])
            return true
        } catch let error as NSError {
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }

    // 부서 정보 삭제 메소드
    func remove(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [departCd])
            return true
        } catch let error as NSError {
            print("DELETE Error = \(error.localizedDescription)")
            return false
        }
    }
}
