import UIKit

class GalleryViewController: UIViewController {
    
    //MARK: - lets, vars
    
    var index = 0
    
    var photoInfo: [ImageInfo] = []
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var galleryImageView: UIImageView!
    
    @IBOutlet weak var scrollViewBottomConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var likeObject: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var trashButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        registerForKeyboardNotifications()
        photoInfo = Manager.shared.loadImageArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoInfo = Manager.shared.loadImageArray()
        galleryImageView.image = Manager.shared.loadImage(fileName: photoInfo[index].name)
        
        addRecognizers()
    }
    
    //MARK: - IBActions
    
    @IBAction func pressDismissVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressPreviousPhoto(_ sender: UIButton) {
        
        guard let text = self.descriptionField.text else {return}
        self.photoInfo[index].comment = text
        
        let previousImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        previousImageView.frame.size = self.galleryImageView.frame.size
        previousImageView.clipsToBounds = true
        previousImageView.frame.origin = self.galleryImageView.frame.origin
        previousImageView.image = self.galleryImageView.image
        previousImageView.contentMode = .scaleAspectFit
        self.view.addSubview(previousImageView)
        
        self.galleryImageView.image = previousImage()
        
        UIView.animate(withDuration: 0.5) {
            previousImageView.frame.origin.x = 0 - previousImageView.frame.width
        } completion: { _ in
            self.descriptionField.text = self.photoInfo[self.index].comment
            self.setLike()
            self.updateUserDefaults()
            previousImageView.removeFromSuperview()
        }
        if photoInfo.count == 1 {
            sender.isEnabled = false
        }
    }
    
    @IBAction func pressNextPhoto(_ sender: UIButton) {
        
        guard let text = self.descriptionField.text else {return}
        self.photoInfo[index].comment = text
        
        let nextImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        nextImageView.frame.size = self.galleryImageView.frame.size
        nextImageView.clipsToBounds = true
        nextImageView.frame.origin = CGPoint(x: self.view.frame.width, y: self.galleryImageView.frame.origin.y)
        nextImageView.image = self.galleryImageView.image
        nextImageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(nextImageView)
        
        nextImageView.image = nextImage()
        
        UIView.animate(withDuration: 0.5) {
            nextImageView.frame.origin = self.galleryImageView.frame.origin
        } completion: { _ in
            self.galleryImageView.image = nextImageView.image
            self.descriptionField.text = self.photoInfo[self.index].comment
            self.setLike()
            self.updateUserDefaults()
            nextImageView.removeFromSuperview()
        }
        if photoInfo.count == 1 {
            sender.isEnabled = false
        }
    }
    
    @IBAction func keyboardTapDetected(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func imageTapped(_ recognizer: UITapGestureRecognizer) {
        guard let imageView = self.galleryImageView else {return}
        let fullscreenImageView = UIImageView(image: imageView.image)
        fullscreenImageView.frame = UIScreen.main.bounds
        fullscreenImageView.contentMode = .scaleAspectFit
        fullscreenImageView.isUserInteractionEnabled = true
        fullscreenImageView.backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        fullscreenImageView.addGestureRecognizer(tap)
        self.view.addSubview(fullscreenImageView)
    }
    
    @IBAction func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func pressLikeButton(_ sender: UIButton) {
        
        self.photoInfo[index].like.toggle()
        setLike()
    }
    
    @IBAction func pressDeletePhoto(_ sender: UIButton) {
        
        alert(title: "Attention!", message: "Your file would be deleted", firstAction: .cancel, firstHandler: { _ in
            print("Nothing wrong")
        }, secondAction: .default) { _ in
            self.photoInfo.remove(at: self.index)
            self.updateUserDefaults()
            self.checkArray()
        }
    }
    
    //MARK: - Flow funcs
    
    func checkArray() {
        
        if photoInfo.count > 1 {
            self.galleryImageView.image = self.previousImage()
        } else {
            self.galleryImageView.image = UIImage(named: "Empty")
            self.likeObject.isEnabled = false
            self.descriptionField.isEnabled = false
            self.trashButton.isEnabled = false
        }
    }
    
    func updateUserDefaults() {
        
        UserDefaults.standard.set(encodable: photoInfo, forKey: "images")
    }
    
    func addRecognizers() {
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardTapDetected(_:)))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        self.view.addGestureRecognizer(imageRecognizer)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(pressPreviousPhoto(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(pressNextPhoto(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func nextImage() -> UIImage? {
        index += 1
        
        if index >= self.photoInfo.count {
            index = 0
        }
        
        return Manager.shared.loadImage(fileName: self.photoInfo[index].name)
    }
    
    func previousImage() -> UIImage? {
        index -= 1
        
        if index < 0 {
            index = self.photoInfo.count - 1
        }
        
        return Manager.shared.loadImage(fileName: self.photoInfo[index].name)
    }
    
    func setLike() {
        
        let heartSize = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let heart = UIImage(systemName: "heart.fill", withConfiguration: heartSize)
        
        if self.photoInfo[index].like {
            self.likeObject.setImage(heart, for: .normal)
            self.likeObject.tintColor = .red
        }
        if !self.photoInfo[index].like {
            self.likeObject.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeObject.tintColor = .white
        }
    }
    
    //MARK: - Keyboard
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func keyboardWillShow(_ notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollViewBottomConstaint.constant = 0
            photoInfo[index].comment = self.descriptionField.text ?? ""
            updateUserDefaults()
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollViewBottomConstaint.constant = keyboardScreenEndFrame.height + 5
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}
//MARK: - Extensions

extension GalleryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.photoInfo[index].comment = self.descriptionField.text ?? ""
        updateUserDefaults()
    }
}

extension GalleryViewController {
    
    func alert(title: String,
               message: String,
               firstAction: UIAlertAction.Style,
               firstHandler: ((UIAlertAction) -> Void)?,
               secondAction: UIAlertAction.Style? = nil,
               secondHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch firstAction {
        case.default:
            let ok = UIAlertAction(title: "OK", style: .default, handler: firstHandler)
            alert.addAction(ok)
        case .cancel:
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: firstHandler)
            alert.addAction(cancel)
        case .destructive:
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: firstHandler)
            alert.addAction(delete)
        default:
            fatalError()
        }
        switch secondAction {
        case.default:
            let ok = UIAlertAction(title: "OK", style: .default, handler: secondHandler)
            alert.addAction(ok)
        case .cancel:
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: secondHandler)
            alert.addAction(cancel)
        case .destructive:
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: secondHandler)
            alert.addAction(delete)
        case .none:
            print("not used")
        default:
            fatalError()
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
