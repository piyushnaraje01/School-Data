
import UIKit
import FirebaseAuth
import Firebase
class ForgetPasswordViewController: UIViewController {

    @IBOutlet var btnCancle: UIButton!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var appLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    private func setUpUI(){
        self.appLogo.layer.cornerRadius = 50
        self.appLogo.layer.masksToBounds = true
        Constants.stylehollowButton(self.sendMailButton, cornerRadius: 20)
        Constants.styleTextField(emailTextField)
        Constants.stylehollowButton(self.btnCancle, cornerRadius: 15)

    }
    
    @IBAction func btnActionCancle(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func sendMailAction(_ sender: UIButton) {
        
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil{
                let alrt = UIAlertController(title: "Result", message: "Password reset mail is sent to your Email successfull!", preferredStyle: .alert)
                let secondAction = UIAlertAction(title: "Ok", style: .destructive) { action in
                    self.emailTextField.text = ""
                    let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.view.window?.rootViewController = LoginViewController
                    self.view.window?.makeKeyAndVisible()
                }
              
                self.errorlbl.textColor = .black
                self.errorlbl.text = "Check your mail address after clicking Send Mail button and reset your password"
                            alrt.addAction(secondAction)
                    self.present(alrt, animated: true, completion: nil)
            }
            else{
                self.errorlbl.textColor = .red
                self.errorlbl.text = "Error somewhere sending email to you"
            }

        }
        }
        
        
    }

