import UIKit

class FormViewContller: UIViewController {
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var isUpdate: UISwitch!
    
    @IBOutlet var interval: UIStepper!
    
    @IBOutlet var setUpdate: UILabel!
    
    @IBOutlet var setInterval: UILabel!
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.setUpdate.text = "자동갱신"
        } else {
            self.setUpdate.text = "자동갱신해제"
        }
    }
    
    @IBAction func changeStepper(_ sender: UIStepper) {
        setInterval.text = "\(Int(sender.value))분 마다"
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        
        let ud = UserDefaults.standard
        
        ud.set(self.email.text, forKey: "email")
        ud.set(self.isUpdate.isOn, forKey: "isUpdate")
        ud.set(self.interval.value, forKey: "interval")
        		
        self.presentingViewController?.dismiss(animated: true)
    }
}
