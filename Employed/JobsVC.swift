//
//  JobsVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/27/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

class JobsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set the navigation bar title & customize it
        self.navigationItem.title = "My Jobs"
		self.navigationController?.navigationBar.tintColor = UIColor.white
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(JobsVC.addButtonPressed(_:)))
		self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
		self.navigationItem.rightBarButtonItem = addButton
    }
	
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
		
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
