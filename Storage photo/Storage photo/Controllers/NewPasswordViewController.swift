import UIKit
import SwiftyKeychainKit

class NewPasswordViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var createPasswordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var savePassword: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recognizer)
        
        createPasswordField.becomeFirstResponder()
        savePassword.roundCorners(radius: 25)
        
    }
    
    //MARK: - IBActions
    
    @IBAction func pressSavePassword(_ sender: UIButton) {
        
        let keychain = KeychainClass.shared.keychain
        let key = KeychainClass.shared.key
        
        guard let creation = createPasswordField.text,
              let confirmation = confirmPasswordField.text else {return}
        
        if creation == confirmation {
            
            try? keychain.set(confirmation, for: key)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            print("nonono")
        }
    }
    
    @IBAction func pressDismissVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Flow funcs
    
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}


