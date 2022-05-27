import UIKit

class MainViewContoller: UIViewController {
    
    //MARK: - lets, vars
    
    var photoInfo: [ImageInfo] = []
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myCollectionView.reloadData()
        photoInfo = Manager.shared.loadImageArray()
    }
    
    //MARK: - IBActions
    
    @IBAction func pressDismissVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Flow funcs
    
}
//MARK: - Extensions

extension MainViewContoller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            addImageObject(image)
        }
        else if let image = info[.originalImage] as? UIImage {
            
            addImageObject(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func addImageObject(_ image: UIImage) {
        if let imageString = Manager.shared.saveImage(image) {
            let newImage = ImageInfo(name: imageString, comment: "", like: false)
            Manager.shared.addImageArray(newImage)
        }
    }
}

extension MainViewContoller: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoInfo.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            // Cell 1
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusCollectionViewCell", for: indexPath) as? PlusCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: UIImage(named: "Plus") ?? UIImage())
            return cell
        } else {
            // Cell 2
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: photoInfo[indexPath.item - 1])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (collectionView.frame.size.width - 10)/2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        if indexPath.item > 0 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else { return }
            controller.index = indexPath.row - 1
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

