import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultEmail: UILabel!
    
    @IBOutlet var resultUpdate: UILabel!
    
    @IBOutlet var resultInterval: UILabel!
    
    @IBAction func regist(_ sender: Any) {
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    
    override func viewWillAppear(_  animated: Bool) {
        
        print("oo")
        
        let ud = UserDefaults.standard
        
        if let email = ud.string(forKey: "email") {
            resultEmail.text = email
        }
        
        let update = ud.bool(forKey: "isUpdate")
        resultUpdate.text = (update == true ? "자동갱신" : "자동갱신 해제")
        
        let interval = ud.double(forKey: "interval")
        resultInterval.text = "\(Int(interval))분마다"
    }
}

