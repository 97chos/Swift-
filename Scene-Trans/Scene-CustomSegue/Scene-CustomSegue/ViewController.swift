//
//  ViewController.swift
//  Scene-CustomSegue
//
//  Created by 조상호 on 2020/10/14.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("seguewat identifier: \(segue.identifier)")
    }
    
    @IBAction func gotoPage1(_ sender: UIStoryboardSegue) {
        
    }

}

