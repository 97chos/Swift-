//
//  EmployeeDAO.swift
//  HRwithFMDB(programmically)
//
//  Created by sangho Cho on 2020/12/26.
//

import Foundation

enum EmpStateType: Int {
    case ING = 0
    case STOP = 1
    case OUT = 2

    // 재직 상태를 문자열로 변환
    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .OUT:
            return "퇴사"
        case .STOP:
            return "휴직중"
        }
    }
}

// 데이터베이스 칼럼에 맞는 ValueObject 생성
struct EmployeeVO {
    var empCd = 0                       // 사원 코드
    var empName = ""                    // 사원명
    var joinDate = ""                   // 입사일
    var stateCd = EmpStateType.ING      // 재직 상태
    var departCd = 0                    // 소속 부서 코드
    var departTitle = ""                // 소속 부서명
}

class EmployeeDAO {
    // FMDataBase 객체 생성 및 초기화
    lazy var fmdb: FMDatabase! = {
        // 1. 파일 매니저 객체 생성
        let fileMgr = FileManager()
        // 2. 샌드박스 내 문서 디렉터리 경로에서 데이터베이스 파일 경로 획득
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPath.appendingPathComponent("hr2.sqlite").path

        // 3. 만약 해당 경로에 파일이 없다면 번들 내에 있는 데이터베이스 파일을 복사하여 해당 경로에 추가
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr2", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }

        // 4. FMDB 객체 생성 후 반환
        let db = FMDatabase(path: dbPath)
        return db
    }()

    init() {
        self.fmdb.open()
    }

    deinit {
        self.fmdb.close()
    }

    // 사원 목록 가져오는 메소드
    func find(departCd: Int = 0) -> [EmployeeVO] {
        // 반환할 데이터를 담을 [EmployeeVO] 타입 객체 정의
        var employeeList = [EmployeeVO]()

        do {

            // 1. 조건절 정의 (매개변수가 입력되지 않을 경우 0이 입력)
            let condition = departCd == 0 ? "" : "WHERE Employee.depart_cd = \(departCd)"

            let sql = """
            SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
            FROM employee
            JOIN department ON department.depart_cd = employee.depart_cd
            \(condition)
            ORDER BY employee.depart_cd ASC
            """

            let rs = try self.fmdb.executeQuery(sql, values: nil)

            while rs.next() {
                var record = EmployeeVO()

                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!

                let cd = Int(rs.int(forColumn: "state_Cd"))
                record.stateCd = EmpStateType(rawValue: cd)!

                employeeList.append(record)
            }
        } catch let error as NSError{
            print("failed : \(error.localizedDescription)")
        }
        return employeeList
    }

    // 단일 사원 레코드를 읽어오는 메소드
    func get(empCd: Int) -> EmployeeVO? {
        // 1. 질의 실행
        let sql = """
        SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
        FROM department
        JOIN department ON department.depart_cd = employee.depart_cd
        WHERE emp_cd = ?
        """

        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])

        // 2. 결과 집합 처리 (옵셔널 구문 해제)
        if let _rs = rs {
            _rs.next()

            var record = EmployeeVO()
            record.empCd  = Int(_rs.int(forColumn: "emp_cd"))
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!

            let cd = Int(_rs.int(forColumn: "state_cd"))
            record.stateCd = EmpStateType(rawValue: cd)!

            return record
        } else {
            return nil
        }
    }

    // 사원 정보 추가 메소드
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = """
            INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
            VALUES (?, ?, ?, ?)
            """

            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)

            try self.fmdb.executeUpdate(sql, values: params)
            return true
        } catch let error as NSError{
            print("Insert Error : \(error.localizedDescription)")
            return false
        }
    }

    // 사원 정보 삭제 메소드
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [empCd])

            return true
        } catch let error as NSError {
            print("Delete Error : \(error.localizedDescription)")
            return false
        }
    }

    // 재직 상태 변경 메소드
    func editState(empCd: Int, stateCd: EmpStateType) -> Bool {

        do {
            let sql = "UPDATE Employee SET state_cd = ? WHERE emp_cd = ?"

            // 인자값 배열
            var params = [Any]()
            params.append(stateCd.rawValue)
            params.append(empCd)

            // 업데이트 실행
            try self.fmdb.executeUpdate(sql, values: params)
            return true
        } catch let error as NSError {
            print("Update error : \(error.localizedDescription)")
            return false
        }
    }
}
