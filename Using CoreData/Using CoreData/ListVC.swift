//
//  ListVC.swift
//  Using CoreData
//
//  Created by sangho Cho on 2020/12/12.
//

import Foundation
import UIKit
import CoreData

class ListVC: UITableViewController {

    // 데이터 소스 역할을 할 배열 지연 프로퍼티
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()

    // 화면 및 로직 초기화 메소드
    override func viewDidLoad() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = addBtn

        self.navigationItem.title = "게시판"
        self.tableView.tableFooterView = UIView()
    }

    // 데이터를 읽어올 메소드
    func fetch() -> [NSManagedObject] {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 요청 객체 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")

        // 3-1. 정렬 속성 설정
        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]

        // 4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest)

        return result
    }

    // 데이터를 저장할 메소드
    func save(title: String, contents: String) -> Bool {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 참조한 관리 객체 컨텍스트에 관리 객체 인스턴스 생성 & 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")

        // 4. 영구 저장소에 커밋되고 나면 list 프로퍼티에 추가
        do {
            try context.save()
            self.list.insert(object, at: 0)
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    // 데이터 저장 버튼에 대한 액션 메소드
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)

        // 입력 필드 추가
        alert.addTextField{
            $0.placeholder = "제목"
        }
        alert.addTextField{
            $0.placeholder = "내용"
        }

        // 버튼 추가
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default){ _ in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
                return
            }

            if self.save(title: title, contents: contents) {
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: true)
    }

    // 데이터를 삭제할 메소드
    func delete(object: NSManagedObject) -> Bool {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 컨텍스트로부터 해당 객체 삭제
        context.delete(object)

        // 4. 영구 저장소에 커밋
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    // 편집 모드를 삭제로 지정
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // 삭제 기능 구현
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        // 삭제할 대상 객체
        let object = self.list[indexPath.row]

        if self.delete(object: object) {
            // 코어 데이터에서 삭제되고 나면 배열목록과 테이블 뷰의 행도 삭제
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // 데이터 수정 메소드
    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 관리 객체 값 수정
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")

        do {
            try context.save()
            self.list = self.fetch()
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    // 셀 선택 후 액션
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 1. 선택된 객체에 해당하는 데이터 가져오기
        let object = self.list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String

        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)

        // 2. 입력 필드 추가
        alert.addTextField{
            $0.text = title
        }
        alert.addTextField{
            $0.text = contents
        }

        // 3. 버튼 추가
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let contents = alert.textFields?.last?.text else {
                return
            }

            // 4. 값 수정 메소드 호출 및 성공 시 테이블 뷰 리로드
            if self.edit(object: object, title: title, contents: contents) {
                // self.tableView.reloadData()

                // 1. 셀 내용 직접 수정
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents

                // 2. 수정된 셀을 첫 번째 행으로 이동
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        })
        self.present(alert, animated: true)
    }

    // 테이블 뷰 데이터 소스용 프로토콜 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 해당하는 데이터 가져오기
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String

        // 셀을 생성하고, 값을 대입한다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents

        return cell
    }

}
