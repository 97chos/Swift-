//
//  LogVC.swift
//  MemoUseCoreDate
//
//  Created by sangho Cho on 2020/12/28.
//

import Foundation
import CoreData
import UIKit

enum LogType: Int16 {
    case create = 0
    case edit = 1
    case delete = 2
}

extension Int16 {
    func toLogType() -> String {
        switch self {
        case 0: return "생성"
        case 1: return "수정"
        case 2: return "삭제"
        default: return ""
        }
    }
}

class LogVC: UITableViewController {

    var board: BoardMO! // 전달받은 값

    var list: [LogMO]!

    override func viewDidLoad() {
        self.list = self.board.logs?.array as? [LogMO]
        self.navigationItem.title = self.board.title
        self.tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "logcell") ?? UITableViewCell(style: .default, reuseIdentifier: "logcell")

        cell.textLabel?.text = "\(row.regDate!)에 \(row.type.toLogType())되었습니다."
        cell.textLabel?.font = .systemFont(ofSize: 12)

        return cell
    }
}
