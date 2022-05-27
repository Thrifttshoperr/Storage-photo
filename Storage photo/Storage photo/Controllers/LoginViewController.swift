import UIKit
import SwiftyKeychainKit

class LoginViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var presentPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var addNewPasswordButton: UIButton!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recognizer)
        
        presentPassword.becomeFirstResponder()
        
        loginButton.roundCorners(radius: 25)
        addNewPasswordButton.roundCorners(radius: 25)
                
    }
    
    //MARK: - IBActions
    
    @IBAction func pressLogin(_ sender: UIButton) {
        
        let key = KeychainClass.shared.key
        let keychain = KeychainClass.shared.keychain
       
        let password = try? keychain.get(key)
        guard let checkpassword = presentPassword.text else {return}
        if checkpassword == password {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewContoller") as? MainViewContoller else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            print("incorrect")
            alertXib()
        }
    }
    
    @IBAction func pressAddNewPassword(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - Flow funcs

    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func alertXib() {
        let alertView = Alert.instanceFromNib()
        alertView.frame = CGRect(x: 0, y: 0, width: 500, height: 1000)
        alertView.center = view.center
        self.view.addSubview(alertView)
    }
    
}

