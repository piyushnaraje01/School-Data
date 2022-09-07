//
//  DetailsStudentVC.swift
//  FirebaseDataSaveDemo
//
//  Created by Skycap on 06/09/22.
//

import UIKit
import Kingfisher
class DetailsStudentVC: UIViewController {

    @IBOutlet weak var imgStudentPic: UIImageView!
    @IBOutlet weak var vWCLass: UIView!
    @IBOutlet weak var vWAddress: UIView!
    @IBOutlet weak var vWAge: UIView!
    @IBOutlet weak var vwname: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblclass: UILabel!
    @IBOutlet weak var btnEditData: UIButton!
    var arrStudentData = [StudentDataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(backToHome), name: .dataUpdated, object: nil)
        Constants.stylehollowButton(self.btnEditData, cornerRadius: 25)
        self.setData()
    }

    @IBAction func btnActionEditData(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewStudentDataVC") as! NewStudentDataVC
        nextViewController.isNewStudent = false
        nextViewController.arrOldStudentData = arrStudentData
        self.present(nextViewController, animated:true, completion:nil)
    }
    @objc func backToHome(){
        self.navigationController?.popViewController(animated: true)
    }
    func setData(){
        self.imgStudentPic.contentMode = .scaleAspectFill
        let url = URL(string: "\(arrStudentData[0].profileImageURL ?? "")")
        self.imgStudentPic.kf.setImage(with: url, placeholder: UIImage(named: Constants.studentDefaultPic.rawPicName), options: .none) { _ in
            
        }
        self.lblName.text = "\(arrStudentData[0].first_name ?? "") \(arrStudentData[0].last_name ?? "")"
        self.lblAge.text = "\(arrStudentData[0].age ?? 0)"
        self.lblAddress.text = arrStudentData[0].address ?? ""
        self.lblclass.text = arrStudentData[0].stu_class ?? ""
    }
}
extension Notification.Name {
    static let dataUpdated = Notification.Name("dataUpdated")
}
