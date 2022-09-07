
import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseAuth
class HomeVC: UIViewController {

    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnReload: UIButton!
    @IBOutlet var btnAddStudentData: UIButton!
    @IBOutlet weak var lblInternetConnectionResult: UILabel!
    @IBOutlet weak var homeTblView: UITableView!
    var arrStudentData = [StudentDataModel]()
    var refDB : DatabaseReference!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        refreshControl.tintColor = .systemGreen
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.homeTblView.addSubview(refreshControl)
        self.refDB = Database.database().reference()
        self.getAllFIRData()
        Constants.stylehollowButton(self.btnAddStudentData, cornerRadius: 15)
        Constants.stylehollowButton(self.btnLogout, cornerRadius: 15)
        self.homeTblView.separatorColor = .systemGreen
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Reachability.isConnectedToNetwork(){
            self.lblInternetConnectionResult.isHidden = true
            self.homeTblView.isHidden = false
            self.btnReload.isHidden = true
            
        }else{
            self.lblInternetConnectionResult.isHidden = false
            self.homeTblView.isHidden = true
            self.btnReload.isHidden = false
        }


    }

    @IBAction func btnActionReloadData(_ sender: UIButton) {
        self.getAllFIRData()
    }
    
    @IBAction func btnActionLogout(_ sender: UIButton) {
        try! Auth.auth().signOut()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func btnActionAddStudentData(_ sender: UIButton) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NewStudentDataVC") as! NewStudentDataVC
                self.present(nextViewController, animated:true, completion:nil)
        
    }
    @objc func refresh(_ sender: AnyObject) {
    getAllFIRData()
    }

    func getAllFIRData(){
        self.refDB.child("students").queryOrderedByKey().observe(.value) { (snapshot) in
            self.arrStudentData.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let mainDict = snap.value as? [String: AnyObject]{
                        let name =  mainDict["name"] as? String
                        let age = mainDict["age"] as? Int
                        let address = mainDict["address"] as? String
                        let profileImageURL = mainDict["profileImageURL"] as? String ?? ""
                        let stu_class = mainDict["stu_class"] as? String ?? ""
                        let first_name = mainDict["first_name"] as? String ?? ""
                        let last_name = mainDict["last_name"] as? String ?? ""
                        self.arrStudentData.append(StudentDataModel(name: name ?? "", age: age ?? 0, profileImageURL: profileImageURL , address: address ?? "", stu_class: stu_class, first_name: first_name,last_name: last_name ))
                        self.refreshControl.endRefreshing()
                        DispatchQueue.main.async {
                            self.homeTblView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStudentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTblView.dequeueReusableCell(withIdentifier: "HomeTblViewCell", for: indexPath) as! HomeTblViewCell
        cell.lblStudentName.text = "\(arrStudentData[indexPath.row].first_name ?? "") \(arrStudentData[indexPath.row].last_name ?? "")"
         let url = URL(string: "\(arrStudentData[indexPath.row].profileImageURL ?? "")")
        cell.imgStudedentPic.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ImgStudentPic"),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ]
            )
        cell.imgStudedentPic.contentMode = .scaleToFill
        cell.selectionStyle = .none
        cell.btnStudentDetail.tag = indexPath.row
        cell.btntapped = {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailsStudentVC") as! DetailsStudentVC
            detailVC.arrStudentData.append(self.arrStudentData[indexPath.row])
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height / 15
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailsStudentVC") as! DetailsStudentVC
        detailVC.arrStudentData.append(arrStudentData[(self.homeTblView.indexPathForSelectedRow?.row)!])
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

