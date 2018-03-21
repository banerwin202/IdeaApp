//
//  SignUpViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref : DatabaseReference!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(findImageButtonTapped))
            profileImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createBtnTapped(_ sender: Any) {
          signUpUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupAddTargetIsNotEmptyTextFields()
        imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
    //Disables Create Button if info are not filled up
    func setupAddTargetIsNotEmptyTextFields() {
        createButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                     for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                        for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                              for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            let email = emailTextField.text, !email.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text,
            password == confirmPassword
            else
        {
            self.createButton.isEnabled = false
            return
        }
        // enable okButton if all conditions are met
        createButton.isEnabled = true
    }
    
    @objc func findImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            if let validData = data {
                let image = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        task.resume()
    }
    
    func uploadToStorage(_ image: UIImage) {
        let storageRef = Storage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.child(userID).child("profilePic").putData(imageData, metadata: metaData) { (meta, error) in
            
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("User").child(userID).child("profilePicURL").setValue(downloadURL)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
            
            //upload the image immediate after select, thats why put the code here
            if let image = profileImageView.image {
                self.uploadToStorage(image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func signUpUser() {
        guard let email = emailTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        if !email.contains("@") {
            //show error //if email not contain @
            showAlert(withTitle: "Invalid Email format", message: "Please input valid Email")
        } else if password.count < 6 {
            //show error
            showAlert(withTitle: "Invalid Password", message: "Password must contain 6 characters")
        } else if password != confirmPassword {
            //show error
            showAlert(withTitle: "Password Do Not Match", message: "Password must match")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                //ERROR HANDLING
                if let validError = error {
                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                }
                
                //HANDLE SUCESSFUL CREATION OF USER
                if let validUser = user {
                    self.firstNameTextField.text = ""
                    self.emailTextField.text = ""
                    self.lastNameTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    let userPost: [String:Any] = ["FirstName": firstName, "Email": email, "LastName" : lastName]
                    
                    self.ref.child("User").child(validUser.uid).setValue(userPost)
                    
//                    let sb = UIStoryboard(name: "HospitalDetail", bundle: Bundle.main)
                    guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "userTabBarController") as? UITabBarController else {return}
                    
                    self.present(navVC, animated: true, completion: nil)
                    print("sign up method successful")
                }
            })
        }
    }
    
}



