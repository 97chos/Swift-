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
}
