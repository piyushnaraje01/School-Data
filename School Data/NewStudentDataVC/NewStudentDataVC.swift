

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class NewStudentDataVC: UIViewController {
    @IBOutlet weak var imgLoader: UIImageView!
    @IBOutlet var bgview: UIView!
    @IBOutlet weak var vwLoader: UIView!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var txtFieldClass: UITextField!
    @IBOutlet weak var btnSaveData: UIButton!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldAge: UITextField!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var imgStudentPic: UIImageView!
    @IBOutlet weak var vwProfileImg: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet var btnSelectImg: UIButton!
    
    var pickerView = UIPickerView()
    let imagePicker = UIImagePickerController()
    var dataClass = ["1st", "2nd", "3rd", "4th", "5th", "6th","7th", "8th", "9th","10th"]
    var valueName: String = ""
    var isStudentImageSelected: Bool = false
    var refDB : DatabaseReference!
    var isNewStudent: Bool = true
    var arrOldStudentData = [StudentDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldAge.delegate = self
        Constants.stylehollowButton(self.btnCancel, cornerRadius: 15)
        Constants.stylehollowButton(self.btnSaveData, cornerRadius: 25)
        //        hide loader
        self.vwLoader.isHidden = true
        //        gif
        self.imgLoader.loadGif(name: "gifLoader")
        //        realtimedb ref
        self.refDB = Database.database().reference()
        //        student class  text picker
        self.txtFieldClass.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        self.setOldStudentData()
    }
    @IBAction func btnActionCancle(_ sender: Any) {
        self.backToHomePage()
    }
    func backToHomePage(){
        dismiss(animated: true)
    }
    
    @IBAction func btnActionSelectImage(_ sender: UIButton) {
        self.setypImagePicker()
    }
    @IBAction func btnActionSaveData(_ sender: UIButton) {
        if isNewStudent == true{
            self.bgview.isHidden = true
            self.saveNewDataTOFirebase()
            
        }else{
            
            self.updateDataToFirebase()
        }
    }
    //    save new data in firebase
    func saveNewDataTOFirebase(){
        self.valueName = "\(self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespaces) ?? "")_\(self.txtFieldLastName.text?.trimmingCharacters(in: .whitespaces) ?? "")"
        if self.isStudentImageSelected == false{
            self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sSelectImg, actionTittle: "Ok")
        }else{
            if self.txtFieldFirstName.text == ""{
                self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sFirstNameFill, actionTittle: "Ok")
            }else{
                if self.txtFieldLastName.text == ""{
                    self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sLastNameFill, actionTittle: "Ok")
                }else{
                    if self.txtFieldAge.text == ""{
                        self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sAgeFill, actionTittle: "Ok")
                    }else{
                        if self.txtFieldAddress.text == ""{
                            self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sAddressFill, actionTittle: "Ok")
                        }else{
                            if self.txtFieldClass.text == ""{
                                self.showAlrt(tittle: "Error", msg: Constants.txtFieldError.sClassFill, actionTittle: "Ok")
                            }else{
                                if Reachability.isConnectedToNetwork(){
                                    //                                call save data func
                                    self.vwLoader.isHidden = false
                                    self.bgview.isHidden = true
                                    self.saveFIRData()
                                }else{
                                    self.showAlrt(tittle: "Result", msg: Constants.alertmsg.noInternetConnection, actionTittle: "Ok")
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    //    update student data to firebase
    func updateDataToFirebase(){
        let dict = ["name": arrOldStudentData[0].name ?? "", "age": Int(self.txtFieldAge.text?.trimmingCharacters(in: .whitespaces) ?? "0") ?? "0", "profileImageURL": self.arrOldStudentData[0].profileImageURL ?? "", "address": self.txtFieldAddress.text ?? "", "stu_class": self.txtFieldClass.text ?? "","first_name": self.txtFieldFirstName.text?.capitalized.trimmingCharacters(in: .whitespaces) ?? "","last_name": self.txtFieldLastName.text?.capitalized.trimmingCharacters(in: .whitespaces) ?? ""] as [String: Any]
        self.refDB.child("students").queryOrderedByKey()
        refDB.child("students").child(self.arrOldStudentData[0].name ?? "").updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if(error != nil){
                
                self.showAlrt(tittle: "Error", msg: error?.localizedDescription ?? "", actionTittle: "Ok")
                return
            }
            //            self.showAlrt(tittle: "Result", msg: Constants.alertmsg.sDataUpdated, actionTittle: "Ok")
            let alrt = UIAlertController(title: "Result", message: Constants.alertmsg.sDataUpdated, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .destructive) { _ in
                NotificationCenter.default.post(name: .dataUpdated, object: nil)
                self.dismiss(animated: true)
            }
            alrt.addAction(action)
            self.present(alrt, animated: true)
        })
        
    }
    //    set old student data to textFields
    func setOldStudentData(){
        if isNewStudent == false{
            self.isStudentImageSelected = true
            self.imgStudentPic.contentMode = .scaleAspectFill
            let url = URL(string: "\(arrOldStudentData[0].profileImageURL ?? "")")
            self.imgStudentPic.kf.setImage(with: url, placeholder: UIImage(named: Constants.studentDefaultPic.rawPicName), options: .none) { _ in
                
            }
            self.txtFieldFirstName.text = arrOldStudentData[0].first_name ?? ""
            self.txtFieldLastName.text = arrOldStudentData[0].last_name
            self.txtFieldAge.text = "\(arrOldStudentData[0].age ?? 0)"
            self.txtFieldAddress.text = arrOldStudentData[0].address ?? ""
            self.txtFieldClass.text = arrOldStudentData[0].stu_class ?? ""
        }
    }
    
    func saveFIRData(){
        self.uploadImage(self.imgStudentPic.image ?? imgStudentPic.image ?? UIImage(named: "ImgStudentPic")!){ url in
            self.saveDataToRef(name: self.valueName, profileImageURL: url! ){ success in
                if success == true{
                    self.vwLoader.isHidden = true
                    self.bgview.isHidden = false
                    self.dismiss(animated: true)
                    self.showAlrt(tittle: "", msg: "", actionTittle: "")
                }else{
                    //                    Retry saving
                    self.showAlrt(tittle: "Result", msg: Constants.alertmsg.sDataFailed, actionTittle: "Ok")
                }
            }
            
        }
    }
    //    upload image to firebase storage
    func uploadImage(_ image: UIImage,completion: @escaping ((_ url: URL?) -> ())){
        let storageRef = Storage.storage().reference().child("myImage.png")
        let imgData = imgStudentPic.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) {(metaData, error) in
            if error == nil{
                //                self.showAlrt(tittle: "Result", msg: Constants.alertmsg.sDataSaved, actionTittle: "Ok")
                storageRef.downloadURL { (url, error) in
                    completion(url)
                }
            }else{
                self.showAlrt(tittle: "Result", msg: error?.localizedDescription ?? "", actionTittle: "Ok")
                completion(nil)
            }
        }
    }
    //    save data to firebase realtime Database
    func saveDataToRef(name: String, profileImageURL: URL, completion: @escaping ((_ result: Bool?) -> ())){
        
        let dict = ["name": self.valueName, "age": Int(self.txtFieldAge.text?.trimmingCharacters(in: .whitespaces) ?? "0") ?? "0", "profileImageURL": profileImageURL.absoluteString, "address": self.txtFieldAddress.text ?? "", "stu_class": self.txtFieldClass.text ?? "","first_name": self.txtFieldFirstName.text?.capitalized ?? "","last_name": self.txtFieldLastName.text?.capitalized ?? ""] as [String: Any]
        self.refDB.child("students").child(self.valueName).setValue(dict){ errorr ,response  in
            if errorr == nil{
                completion(true)
                self.showAlrt(tittle: "Result", msg: Constants.alertmsg.sDataSaved, actionTittle: "Ok")
            }else{
                self.showAlrt(tittle: "Result", msg: Constants.alertmsg.sDataFailed, actionTittle: "Ok")
                completion(false)
            }
        }
    }
    
}
extension NewStudentDataVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataClass.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataClass[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtFieldClass.text = dataClass[row]
        self.txtFieldClass.resignFirstResponder()
    }
}
extension NewStudentDataVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func setypImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image.compress(maxKb: 10000) { imgData in
            self.imgStudentPic.image = UIImage(data: imgData)
            self.dismiss(animated: true, completion: nil)
            self.imgStudentPic.contentMode = .scaleToFill
            self.isStudentImageSelected = true
        }
    }
}
extension NewStudentDataVC: UITextFieldDelegate{
    // UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldAge {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
