//
//  MainViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class IdeaViewController: UIViewController {
    
    var ref : DatabaseReference!
    var ideas : [Idea] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            guard let navVC = storyboard?.instantiateViewController(withIdentifier: "mainNavigationController") as? UINavigationController else {return}
            present(navVC, animated: true, completion: nil)
        } catch {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        observeIdea()
    }

    
    func observeIdea() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        ref.child("User").child(userID).child("Idea").observe(.childAdded) { (snapshot) in
            self.ref.child("User").child("Idea").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshotIdea) in
                guard let userDict = snapshotIdea.value as? [String:Any] else {return}
                let user = Idea(uid: snapshot.key, dict: userDict)
                
                DispatchQueue.main.async {
                    self.ideas.append(user)
                    let indexPath = IndexPath(row: self.ideas.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
                self.tableView.reloadData()
            })
        }
    } //end of ObserveIdea
    
}
        
            
extension IdeaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = Bundle.main.loadNibNamed("IdeaTableViewCell", owner: self, options: nil)?.first as? IdeaTableViewCell else {return UITableViewCell()}
        
        cell.titleLabel.text = ideas[indexPath.row].title
        cell.dateLabel.text = ideas[indexPath.row].date
        cell.statusLabel.text = ideas[indexPath.row].status
        
        return cell
        
        
    }
}

extension IdeaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "IdeaDetailViewController") as? IdeaDetailViewController else {return}
        
        let idea = ideas[indexPath.row]
        
        vc.selectedIdea = idea
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

