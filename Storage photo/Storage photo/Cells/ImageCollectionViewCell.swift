import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    func configure(with image: ImageInfo) {
        
        myImageView.image = Manager.shared.loadImage(fileName: image.name)
        
    }
}
