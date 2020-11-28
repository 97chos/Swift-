//
//  ListViewController.swift
//  Customize_Alert
//
//  Created by sangho Cho on 2020/11/28.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    var delegate: MapAlertViewController?

    override func viewDidLoad() {
        self.preferredContentSize.height = 220
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)번 째 옵션입니다."
        cell.textLabel?.font = .systemFont(ofSize: 13)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRowAt(indexPath: indexPath)
    }
}
