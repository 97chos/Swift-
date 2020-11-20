//
//  ViewController.swift
//  Delegate-ImagePicker
//
//  Created by 조상호 on 2020/10/19.
//  Copyright © 2020 조상호. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet var imgView: UIImageView!
    
    @IBAction func picker(_ sender: Any) {
        
        // 이미지 피커 컨트롤러 인스턴스 생성
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        // 이미지 피커 컨트롤러 실행
        self.present(picker, animated: true)
        
        // 추가된 부분) 델리게이트 지정
        picker.delegate = self
    }
}

// MARK:- 이미지 피커 컨트롤러 델리게이트 메소드
extension ViewController: UIImagePickerControllerDelegate {
    
    // 이미지 피커에서 이미지를 선택하지 않고 취소했을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // 이미지 피커 컨트롤러 창 종료
        picker.dismiss(animated: true) {
            () in // 알림창 호출
        let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        self.present(alert, animated: true)
        }
    }
    
    // 이미지 피커에서 이미지를 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 이미지 컨트롤러 창 닫기
        
        picker.dismiss(animated: true) {
            () in
            // 이미지를 이미지 뷰에 표시
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }
    }
}

// MARK:- 네비게이션 컨트롤러 데리게이트 메소드
extension ViewController: UINavigationControllerDelegate{
    
}


