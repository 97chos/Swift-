//
//  ListVC.swift
//  MemoUseCoreDate
//
//  Created by sangho Cho on 2020/12/27.
//

import Foundation
import UIKit
import CoreData

class ListVC: UITableViewController {

    // 데이터 소스 역할을 할 배열 변수
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "메모"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 해당하는 데이터 가져오기
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String

        // 셀 생성 및 값 대입
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents

        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let object = self.list[indexPath.row]

        if self.delete(object: object) {
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension ListVC {

    // 데이터를 읽어올 메소드
    func fetch() -> [NSManagedObject] {

        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 요청 객체 참조
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")

        // 4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest)
        return result
    }

    // 데이터 저장 메소드
    func save(title: String, contents: String) -> Bool {

        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 관리 객체 생성 & 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)

        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regDate")

        // 4, 영구 저장소에 커밋되고 나면 list 프로퍼티에 추가
        do {
            try context.save()
            self.list.append(object)
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    // 데이터 삭제 메소드
    func delete(object: NSManagedObject) -> Bool {
        // 1. 앱 델리게이트 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // 2. 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext

        // 3. 컨텍스트로부터 해당 객체 상제
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

    @objc func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)

        alert.addTextField() { $0.placeholder = "제목" }
        alert.addTextField() { $0.placeholder = "내용" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
                return
            }

            // 값을 저장하고, 성공이면 테이블 뷰 리로드
            if self.save(title: title, contents: contents) {
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: true)
    }
}
