//
//  ExploreViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ExploreViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var ref : DatabaseReference!
    var ideas : [Idea] = []
    var searchController : UISearchController!
    var resultsController = UITableViewController()

    var currentIdeaArray = [Idea]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        ref = Database.database().reference()
        observeIdea()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
//Search Bar Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentIdeaArray = ideas.filter({ (idea) -> Bool in
            guard let text = searchBar.text else {return false}
            return idea.title.contains(text)
        })
            tableView.reloadData()
        }


    func observeIdea() {
        self.ref.child("User").child("Idea").observe(.childAdded) { (snapshot) in
            guard let userDict = snapshot.value as? [String:Any] else {return}
            let user = Idea(uid: snapshot.key, dict: userDict)
            
            self.currentIdeaArray = self.ideas
            DispatchQueue.main.async {
                self.ideas.append(user)
                let indexPath = IndexPath(row: self.ideas.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
            }
            self.tableView.reloadData()
        }
        
    } //end of ObserveIdea
    

    
}
    

extension ExploreViewController : UITableViewDataSource {
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


extension ExploreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "IdeaDetailViewController") as? IdeaDetailViewController else {return}
        
        let idea = ideas[indexPath.row]
        
        vc.selectedIdea = idea
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


