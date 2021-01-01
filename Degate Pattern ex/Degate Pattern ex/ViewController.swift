//
//  ViewController.swift
//  Degate Pattern ex
//
//  Created by sangho Cho on 2021/01/01.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    func showNumberSelector() {
        let viewContorller = NumberSelectorViewController(numbers: [0, 1, 2, 3])
        viewContorller.delegate = self
        present(viewContorller, animated: true)
    }
}
extension ViewController: NumberSelectorViewControllerDelegate {
    func didSelectedNumber(_ number: Int) {
        print("number selected : ", number)
    }
}

protocol NumberSelectorViewControllerDelegate: class {
    func didSelectedNumber(_ number: Int)
}

class NumberSelectorViewController: UIViewController {

    let numbers: [Int]
    weak var delegate: NumberSelectorViewControllerDelegate?

    init(numbers: [Int]) {
        self.numbers = numbers
    }


    func didClickedNumber(_ number: Int) {
        self.delegate?.didSelectedNumber(number)
    }

}
