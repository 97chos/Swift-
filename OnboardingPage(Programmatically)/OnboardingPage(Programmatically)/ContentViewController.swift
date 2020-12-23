//
//  ContentViewController.swift
//  OnboardingPage(Programmatically)
//
//  Created by sangho Cho on 2020/12/23.
//

import Foundation
import UIKit


class ContentViewController: UIViewController {

    var titleLabel: UILabel!
    var imageView: UIImageView!

    var titleText: String!
    var imageData: String!
    var pageIndex: Int!

    var imgViewSize: CGSize!

    override func viewDidLoad() {

        self.titleLabel = UILabel()

        self.titleLabel.text = self.titleText
        
        self.titleLabel.sizeToFit()

        self.titleLabel.center.x = self.view.frame.width / 2
        self.titleLabel.frame.origin.y = self.view.frame.height / 3

        self.imageView = UIImageView()
        self.imageView.frame.size = imgViewSize
        self.imageView.image = UIImage(named: imageData)
        self.imageView.contentMode = .scaleAspectFill

        self.view.addSubview(titleLabel)
        self.view.addSubview(imageView)
    }

}
