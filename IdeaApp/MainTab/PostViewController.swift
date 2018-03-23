//
//  AddViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var ref : DatabaseReference!
    let imagePicker = UIImagePickerController()
    var ideaImageID : [String] = []
    var currentID : String = ""
    
    @IBOutlet weak var locationBtnTapped: UIButton!
    
    @IBOutlet weak var ideaNameTextField: UITextField!
    
    @IBOutlet weak var ideaDateTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField! 
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(findImageButtonTapped(_:)))
            imageView.addGestureRecognizer(tap)
        }
    }
    

    @IBAction func createBtnTapped(_ sender: Any) {
        createIdea()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if (Auth.auth().currentUser?.uid) != nil {
            currentID = (Auth.auth().currentUser?.uid)!}
        
           imagePicker.delegate = self
        }
    
    
    @objc func findImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }



    func uploadToStorage(_ image: UIImage,_ ideaImageID : String) {
        let storageRef = Storage.storage().reference()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.child(userID).child("ideaPic").putData(imageData, metadata: metaData) { (meta, error) in
            
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadURL = meta?.downloadURL()?.absoluteString {

            self.ref.child("User").child("Idea").child(ideaImageID).child("IdeaPicURL").setValue(downloadURL)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func createIdea() {
        guard let ideaName = ideaNameTextField.text,
            let ideaDate = ideaDateTextField.text,
            let ideaLocation = locationTextField.text,
            let ideaDescription = descriptionTextField.text else {return}
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let ideaID = ref.child("User").child("Idea").childByAutoId()
        
        if let image = self.imageView.image {
            self.uploadToStorage(image, ideaID.key)
        }
        
        let newIdea : [String:Any] = ["IdeaTitle" : ideaName, "IdeaDate" : ideaDate, "IdeaLocation" : ideaLocation, "Description" : ideaDescription]
        
    
        self.ref.child("User").child("Idea").child(ideaID.key).setValue(true)
        self.ref.child("User").child("Idea").child(ideaID.key).setValue(newIdea)
        self.ref.child("User").child(userID).child("Idea").child(ideaID.key).setValue(true)
    }


}
