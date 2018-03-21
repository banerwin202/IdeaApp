//
//  MainViewController.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase


class IdeaViewController: UIViewController {
    
    var ref : Database
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    



}

extension IdeaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
