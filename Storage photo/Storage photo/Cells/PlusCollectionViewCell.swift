import UIKit

class PlusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    func configure(with image: UIImage) {
        
        plusImageView.image = UIImage(named: "Plus")
        
    }
    
}
