//
//  DiscoverPageContainerVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/8/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class DiscoverPageContainerVC: UIViewController {
	
	var job: Employed_Io_Job?
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    	// Pass the job object to the paged view controller
		if let embeddedVC = segue.destination as? DiscoverPageVC {
			if let job = self.job {
				embeddedVC.setJob(job: job)
				embeddedVC.showTagView()
			}
		}
	}
	
	// Dismisses this view controller
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// Sets the job object
	func setJob(job: Employed_Io_Job) -> Void {
		self.job = job
	}
}
