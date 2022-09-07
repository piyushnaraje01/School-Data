
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    

   
    @IBOutlet weak var forgetPasswordButtpn: UIButton!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var showPasswordlbl: UILabel!
    @IBOutlet weak var newaccountbutton: UIButton!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showPasswordAction(_ sender: UISwitch) {
        if sender.isOn{
            passwordtextfield.isSecureTextEntry = false
            showPasswordlbl.text = "Hide Password"
        }
        else{
            passwordtextfield.isSecureTextEntry = true
            showPasswordlbl.text = "Show Password"
        }
        
    }
    
    func setUpElements(){
        Constants.stylehollowButton(self.forgetPasswordButtpn, cornerRadius: 20)
        self.appLogo.layer.cornerRadius = 50
        self.appLogo.layer.masksToBounds = true
        errorlbl.alpha = 0
        Constants.styleTextField(emailtextfield)
        Constants.styleTextField(passwordtextfield)
        Constants.stylehollowButton(loginbutton, cornerRadius: 20)
        
        Constants.stylehollowButton(newaccountbutton, cornerRadius: 20)

    }
    
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(nextViewController, animated:true, completion:nil)

    }

    @IBAction func loginaction(_ sender: UIButton) {
        
//        validate the text field
        let email = emailtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if result != nil{
                self.transitionToHome()

            }
            else{
                self.errorlbl.text = error!.localizedDescription
                self.errorlbl.alpha = 1
            }
        }

    }
    
    @IBAction func newAccount(_ sender: UIButton) {
        let signupViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        view.window?.rootViewController = signupViewController
        view.window?.makeKeyAndVisible()
    }
    func transitionToHome() {
        let homeNavVC = storyboard?.instantiateViewController(withIdentifier: "HomeNavigatinController") as! HomeNavigatinController
        view.window?.rootViewController = homeNavVC
        view.window?.makeKeyAndVisible()
    }
}
