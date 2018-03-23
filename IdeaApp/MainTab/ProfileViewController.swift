//
//  ProfileViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var numberOfUnstartedIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfProgressIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfIncompleteIdeaLabel: UILabel!
    
    @IBOutlet weak var numberOfCompleteIdea: UILabel!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        observeUserProfile()
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func observeUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        ref.child("User").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}
            
            let profilePicURL = userDict["profilePicURL"] as? String ?? ""
            
            self.firstNameLabel.text = userDict["FirstName"] as? String ?? ""
            self.lastNameLabel.text = userDict["LastName"] as? String ?? ""
            
            self.getImage(profilePicURL, self.profileImage)
        }
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

    

}
