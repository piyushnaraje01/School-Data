
import UIKit

class HomeTblViewCell: UITableViewCell {

    @IBOutlet weak var imgStudedentPic: UIImageView!
    @IBOutlet weak var btnStudentDetail: UIButton!
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var bgView: UIView!
    var btntapped : (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnActionDetailStudent(_ sender: UIButton) {
        if let btnAction = self.btntapped
          {
              btnAction()
          }
        
        
    }
}
