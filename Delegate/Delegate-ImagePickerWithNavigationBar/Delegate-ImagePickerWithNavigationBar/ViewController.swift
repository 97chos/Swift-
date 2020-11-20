//
//  ViewController.swift
//  Delegate-ImagePickerWithNavigationBar
//
//  Created by 조상호 on 2020/10/19.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        picker.delegate = self
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func addAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "사진", message: "원하는 위치를 선택하세요.", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "앨범", style: .default) {
            (action) in
            self.openLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default){(action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        picker.sourceType = .camera
        present(picker, animated: true)
        } else {
            print("카메라 사용 불가")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true){ () in
            let alert = UIAlertController(title: "선택 취소", message: "사진 선택이 취소되었습니다.", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.imageView.image = img
        
        self.dismiss(animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate{
    
}

