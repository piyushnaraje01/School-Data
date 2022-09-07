

import Foundation
import UIKit
import SystemConfiguration
struct Constants{
    struct studentDefaultPic{
        static let rawPicName = "ImgStudentPic"
    }
    struct alertmsg{
        static let sDataSaved = "Student data has been saved successfully."
        static let sDataFailed = "Error in saving student data."
        static let noInternetConnection = "Please check internet connection and try again."
        static let sDataUpdated = "Student's data has been updated."
        static let passwordStrength = "Please make sure your password is at  least 8 characters, contains a special character and a number."
       
    }
    struct txtFieldError{
        static let sSelectImg = "Please select student's picture from gallary."
        static let sFirstNameFill = "Please enter student's first name."
        static let sLastNameFill = "Please enter student's last name."
        static let sAgeFill = "Please enter student's age."
        static let sAddressFill = "Please enter Student's full residential address."
        static let sClassFill = "Please select student's class"
    }
    
    static func stylehollowButton(_ button:UIButton, cornerRadius:  CGFloat){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = cornerRadius
        button.tintColor = UIColor.systemGreen
    }
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    static func styleTextField(_ textfield:UITextField){
        let bottomline = CALayer()
        bottomline.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width , height: 2)
        bottomline.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomline)
    }
    struct Storyboard {
    static let homeNavVC = "homeNavVC"
    }
}

//    image compression
extension UIImage {
    func compress(maxKb: Double,completed: @escaping (Data) -> Void) {
        let quality: CGFloat = maxKb / self.sizeAsKb()
        let compressedData: Data? = self.jpegData(compressionQuality: quality)
        return completed(compressedData!)
    }
    func sizeAsKb() -> Double {
        Double(self.pngData()?.count ?? 0 / 1024)
    }
}
//alert function
extension UIViewController{
    func showAlrt(tittle: String, msg: String, actionTittle: String) {
        let alrt = UIAlertController(title: tittle, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTittle, style: .destructive) { _ in
        
        }
        alrt.addAction(action)
        self.present(alrt, animated: true, completion: nil)
    }

}
public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
