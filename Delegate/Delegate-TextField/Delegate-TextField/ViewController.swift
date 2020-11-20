import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf: UITextField!
    
    @IBOutlet var lockSw: UISwitch!
    
    override func viewDidLoad() {
        self.tf.placeholder = "값을 입력하세요."
        self.tf.keyboardType = UIKeyboardType.alphabet
        self.tf.keyboardAppearance = UIKeyboardAppearance.dark
        self.tf.returnKeyType = UIReturnKeyType.join
        self.tf.enablesReturnKeyAutomatically = true
        self.tf.clearsOnBeginEditing = true
        
        /**
         * 스타일 설정
         */
        // 테두리 스타일 - 직선
        self.tf.borderStyle = UITextField.BorderStyle.line
        //  배경 색상
        self.tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        // 수직 방향으로 텍스트가 가운데 정렬되도록
        self.tf.contentVerticalAlignment = .center
        // 수평 방향으로 텍스트가 가운데 정렬되도록
        self.tf.contentHorizontalAlignment = .center
        // 테두리 색상을 회색으로
        self.tf.layer.borderColor = UIColor.darkGray.cgColor
        // 테두리 두께 설정 (단위 : pt)
        self.tf.layer.borderWidth = 2.0
        
        self.tf.becomeFirstResponder()
        
        self.tf.delegate = self
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.tf.resignFirstResponder()
    }
    
    @IBAction func input(_ sender: Any) {
        if lockSw.isOn == true {
            self.tf.becomeFirstResponder()
        } else {
            self.tf.resignFirstResponder()
        }
    }
    
    // 텍스트 필드 편집이 시작된 후 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("텍스트 빌드 편집 시작")
        
        if lockSw.isOn == true {
            self.tf.becomeFirstResponder()
        } else {
            self.tf.resignFirstResponder()
        }
    }
    
    // 텍스트 필드의 내용이 삭제될 때 호출
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if lockSw.isOn == true {
            print("텍스트 내용 삭제")
            return true
        } else {
            return false
        }
    }
    
    // 텍스트 필드의 내용이 변경될 때 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("텍스트 필드의 내용이 \(string)으로 변경")
        
            if Int(string) == nil {
            // 현재 텍스트 필드에 입력된 길이와 더해질 문자열 길이의 합이 10을 넘는다면 반영하지 않음
                if (textField.text?.count)! + string.count > 10 {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    
    // 텍스트 필드의 리턴키가 눌러졌을 때 호출
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 리턴키가 눌러졌습니다")
        return true
    }
    
    // 텍스트 필드 편집이 종료될 때 호출
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 종료 예정")
        return true
    }
    
    //텍스트 필드의 편집이 종료되었을 때 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집 종료 완료")
    }
}

