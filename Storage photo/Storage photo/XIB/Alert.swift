import UIKit

class Alert: UIView {
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var failureImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    static func instanceFromNib() -> Alert {
        guard let view = UINib(nibName: "Alert", bundle: nil).instantiate(withOwner: nil, options: nil).first as? Alert else { return Alert() }
        
        return view
    }

    @IBAction func pressButton(_ sender: UIButton) {
        removeFromSuperview()
    }
    
    func setupView() {
        
        failureImage.layer.cornerRadius = 15
        failureImage.layer.borderColor = UIColor.white.cgColor
        failureImage.layer.borderWidth = 2
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
