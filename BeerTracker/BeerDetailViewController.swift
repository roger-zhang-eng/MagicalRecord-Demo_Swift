//
//  BeerDetailViewController.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class BeerDetailViewController: UITableViewController {
  
  @IBOutlet weak var beerNameTextField: UITextField!
  @IBOutlet weak var beerNotesView: UITextView!
  @IBOutlet weak var cellNameRatingImage: UITableViewCell!
  
  //------------------------------------------
  // Showing the image
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var addPhotoLabel: UILabel!
  
  // Set up a "Property Observer" using a "didSet block" instead of just declaring the variable like this:
  //    var image: UIImage?
  // The code in the didSet block is performed whenever the variable is assigned a new value.
  
  var image: UIImage? {
    didSet {
      
      // Store the photo in the image instace variable for later use.
      if let image = image {
        showImage(image)
      }
    }
  }
  //------------------------------------------
  // Rating Control
  
  @IBOutlet weak var ratingControlOutlet: AMRatingControl!
  
  //------------------------------------------
  var currentBeer: Beer!

  //------------------------------------------
  // Rating
  
  // When properties of a Swift class are created, the bridging header is not yet in scope.
  // Therefore, properties related to the bridging header must be declared with type AnyObject!
  
  var amRatingCtl: AnyObject!
  
  let beerEmptyImage: UIImage = UIImage(named: "beermug-empty")!
  let beerFullImage:  UIImage = UIImage(named: "beermug-full")!
  
  //#####################################################################
  // MARK: - Initialization
  
  required init(coder aDecoder: NSCoder) {
    // Automatically invoked by UIKit as it loads the view controller from the storyboard.

    amRatingCtl = AMRatingControl(location: CGPointMake(95, 66),
                                emptyImage: beerEmptyImage,
                                solidImage: beerFullImage,
                              andMaxRating: 5)

    // A call to super is required after all variables and constants have been assigned values but before anything else is done.
    super.init(coder: aDecoder)!
    
    amRatingCtl.addTarget(self, action: "updateRating", forControlEvents: UIControlEvents.TouchUpInside)
  }
  //#####################################################################
  // MARK: - UIViewController
  
  // MARK: Managing the View

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //------------------------------------------
    beerNotesView.layer.borderColor = UIColor(white: 0.667, alpha: 0.500).CGColor
    beerNotesView.layer.borderWidth = 1.0
    
    //------------------------------------------
    if let beer = currentBeer {
      // A beer exists.  EDIT Mode.
      
    } else {
      // A beer does NOT exist.  ADD Mode.
      
      currentBeer = Beer.createEntity() as! Beer
      currentBeer.name = ""
    }
    //------------------------------------------
    let details: BeerDetails? = currentBeer.beerDetails
    
    if let bDetails = details {
      // Beer Details exist.  EDIT Mode.
      
    } else {
      // Beer Details do NOT exist.  Either ADD Mode or EDIT Mode with a beer that has no details.
      
      currentBeer.beerDetails = BeerDetails.createEntity() as! BeerDetails
    }
    //------------------------------------------
    // Update user interface with attribute values.
    
    //--------------------
    // BEER NAME
    
    let cbName: String? = currentBeer.name
    
    if let bName = cbName {
      beerNameTextField.text = bName
    }
    //--------------------
    // BEER NOTE
    
    if let bdNote = details?.note {
      beerNotesView.text = bdNote
    }
    //--------------------
    // BEER RATING
    
    let theRatingControl = ratingControl()
    cellNameRatingImage.addSubview(theRatingControl)
    
    if let bdRating = details?.rating {
      theRatingControl.rating = Int(bdRating)
      
    } else {
      // Need this for ADD Mode.
      theRatingControl.rating = 0
    }
    //--------------------
    // BEER IMAGE
    
    if let beerImagePath = details?.image {
      
      let beerImage = UIImage(contentsOfFile: beerImagePath)
      
      if let bImage = beerImage {
        showImage(bImage)
      }
    }
    //------------------------------------------
    // Set scene title.
    
    if currentBeer.name == "" {
      title = "New Beer"
    } else {
      title = currentBeer.name
    }
  }
  //#####################################################################
  // MARK: Responding to View Events
  
  override func viewWillDisappear(animated: Bool) {
    
    super.viewWillDisappear(true)
    
    //------------------------------------------
    
    beerNameTextField.resignFirstResponder()
    beerNotesView.resignFirstResponder()
    
    saveContext()
  }
  //#####################################################################
  // MARK: - Action Methods
  
  @IBAction func didFinishEditingBeer(sender: UITextField) {
    
    beerNameTextField.resignFirstResponder()
  }
  //#####################################################################
  
  @IBAction func takePicture(sender: UITapGestureRecognizer) {
    pickPhoto()
  }
  //#####################################################################
  // MARK: - Helper Methods
  
  func cancelAdd() {
    currentBeer.deleteEntity()
    navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  
  func addNewBeer() {
    navigationController?.popViewControllerAnimated(true)
  }
  //#####################################################################
  // MARK: - MagicalRecord Methods
  //         Third-party Core Data stack.
  
  func saveContext() {
    NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
  }
  //#####################################################################
  // MARK: - Rating Control Methods
  //         Third-party star rating UIControl.
  //         Using AMRatingControl - https://www.cocoacontrols.com/controls/amratingcontrol

  func ratingControl() -> AMRatingControl {
    
    if let amrc = amRatingCtl as? AMRatingControl {
      
      amrc.starSpacing = 5
    }
    
    return amRatingCtl as! AMRatingControl
  }
  //#####################################################################
  func updateRating() {
    currentBeer.beerDetails.rating = ratingControl().rating
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Text Field Delegate

extension BeerDetailViewController: UITextFieldDelegate {
  
  // MARK: Managing Editing
  
  func textFieldDidEndEditing(textField: UITextField) {
    
    if textField.text != "" {
      self.title       = textField.text
      currentBeer.name = textField.text!
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Text View Delegate

extension BeerDetailViewController: UITextViewDelegate {
  
  // MARK: Responding to Editing Notifications
  
  func textViewDidEndEditing(textView: UITextView) {
    
    textView.resignFirstResponder()
    
    if textView.text != "" {
      currentBeer.beerDetails.note = textView.text
    }
  }
  //#####################################################################
}
//#####################################################################
// MARK: - Table View Delegate

/*extension BeerDetailViewController: UITableViewDelegate {
}*/

//#####################################################################
// MARK: - Gesture Recognizer Delegate

extension BeerDetailViewController: UIGestureRecognizerDelegate {
  
}
//#####################################################################
// MARK: - Image Picker Controller Delegate

// The view controller must conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate for image picking to work,
// but none of the UINavigationControllerDelegate methods have to be implemented.

extension BeerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    // Called when the user has selected a photo in the image picker.
    
    // "[NSObject : AnyObject]" indicates that input parameter, info, is a dictionary with keys of type NSObject and values of type AnyObject.
    
    // Use the UIImagePickerControllerEditedImage key to retrieve a UIImage object that contains the image after the Move and Scale operations on the original image.
    image = info[UIImagePickerControllerEditedImage] as! UIImage?
    
    //------------------------------------------
    if let imageToDelete = currentBeer.beerDetails.image {
      ImageSaver.deleteImageAtPath(imageToDelete)
    }
    //------------------------------------------
    if ImageSaver.saveImageToDisk(image!, andToBeer: currentBeer) {
      showImage(image!)
    }
    //------------------------------------------
    // Refresh the table view to set the photo row to the proper height to accommodate a photo (or not).
    tableView.reloadData()
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  //#####################################################################
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  //#####################################################################
  
  func pickPhoto() {
    
    if true || UIImagePickerController.isSourceTypeAvailable(.Camera) {
      // Adding "true ||" introduces into the iOS Simulator fake availability of the camera.

      // The user's device has a camera.
      showPhotoMenu()
      
    } else {
      // The user's device does not have a camera.
      choosePhotoFromLibrary()
    }
  }
  //#####################################################################
  
  func showPhotoMenu() {
    // Show an alert controller with an action sheet that slides in from the bottom of the screen.
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    // handler: is given a Closure that calls the appropriate method.
    // The "_" wildcard is being used to ignore the parameter that is passed to this closure (which is a reference to the UIAlertAction itself).
    
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { _ in self.takePhotoWithCamera() })
    alertController.addAction(takePhotoAction)
    
    let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: { _ in self.choosePhotoFromLibrary() })
    alertController.addAction(chooseFromLibraryAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  //#####################################################################
  
  func takePhotoWithCamera() {
    
    let imagePicker = UIImagePickerController()
    
    imagePicker.sourceType = .Camera
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    //------------------------------------------
    // Make the photo picker's tint color (background color) the same as the view's.
    // This avoids having standard blue text on a dark gray navigation bar (assuming the view's tint color is set appropriately in the storyboard).
    imagePicker.view.tintColor = view.tintColor
    
    //------------------------------------------
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  //#####################################################################
  
  func choosePhotoFromLibrary() {
    
    let imagePicker = UIImagePickerController()
    
    imagePicker.sourceType = .PhotoLibrary
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    //------------------------------------------
    // Make the photo picker's tint color (background color) the same as the view's.
    // This avoids having standard blue text on a dark gray navigation bar (assuming the view's tint color is set appropriately in the storyboard).
    imagePicker.view.tintColor = view.tintColor
    
    //------------------------------------------
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  //#####################################################################
  
  func showImage(image: UIImage) {
    
    // Put the image into the image view.
    imageView.image = image
    
    // Make the image view visible.
    imageView.hidden = false
    
    //--------------------
    // IMAGE FRAME SIZE
    
    // By default, an image view will stretch the image to fit the entire content area.
    // To keep the image's aspect ratio intact as it is resized, in the storyboard set the Image View's MODE to Aspect Fit.
    // Properly size the image view within the Beer Name table view cell.
    
    let imageAspectRatio = image.size.width / image.size.height
    let imageViewFrameHeight = 65 / imageAspectRatio
    
    imageView.frame = CGRect(x: 16, y:18, width: 65, height: imageViewFrameHeight)
    
    //--------------------
    // Hide the label that prompts the user to add a photo.
    addPhotoLabel.hidden = true
  }
  //#####################################################################
}
