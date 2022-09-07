

import UIKit
import FirebaseAuth
import Firebase



class SignUpViewController: UIViewController {

    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var showPasswordlbl: UILabel!
    @IBOutlet weak var haveanacoountbutton: UIButton!
    @IBOutlet weak var errorlbl: UILabel!
    @IBOutlet weak var signupbutton: UIButton!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var lastnametextfield: UITextField!
    @IBOutlet weak var firstnametextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        self.appLogo.layer.cornerRadius = 50
        self.appLogo.layer.masksToBounds = true
        errorlbl.alpha = 0
        Constants.styleTextField(firstnametextfield)
        Constants.styleTextField(lastnametextfield)
        Constants.styleTextField(emailtextfield)
        Constants.styleTextField(passwordtextfield)
        Constants.stylehollowButton(signupbutton, cornerRadius: 20)
        Constants.stylehollowButton(haveanacoountbutton, cornerRadius: 20)
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
    
    //         MARK: validate then field
            func validateFields() -> String? {
                if firstnametextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                    lastnametextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                    emailtextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                    passwordtextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    return "Please Fill in all fields"
                }
    //            MARK: check password is secure
                let cleanedPassword = passwordtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                if Constants.isPasswordValid(cleanedPassword) == false{
    //                password isnt secure enough
                    return  Constants.alertmsg.passwordStrength
                }
                
                return nil
            }
    func showError(_ message: String) {
        errorlbl.text = message
        errorlbl.alpha = 1
    }
    @IBAction func signupaction(_ sender: UIButton) {
//        validate the fields
        let error = validateFields()
        if error != nil{
            showError(error!)
        }
        else{
//            create cleaned versions of the data
            let firstname = firstnametextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastnametextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordtextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //        MARK: create an user
            
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                
//        check for error
                if err != nil{
//                    there was an error creating an user
                    self.showError("Error Creating Account")
                }
                else{
// User was created successfully.now store the first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstname, "lastname": lastname, "uid": result!.user.uid]) { (error) in
                        if error != nil{
//                            show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
//                    MARK: TRANSITION TO THE HOME SCREEN.
                    self.transitionToHome()
                }
            }
        
        }
        
    }

    
    @IBAction func haveanAccount(_ sender: UIButton) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    func transitionToHome() {
        let homeNavVC = storyboard?.instantiateViewController(withIdentifier: "HomeNavigatinController") as! HomeNavigatinController
        view.window?.rootViewController = homeNavVC
        view.window?.makeKeyAndVisible()
    }
}
