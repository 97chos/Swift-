import UIKit

class ViewController: UIViewController {

    @IBOutlet var uiTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func seyHello(_ sender: Any) {
         self.uiTitle.text = "Hello, World!"
        
    }
}

