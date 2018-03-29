//
//  JobFormVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/28/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import Eureka

class JobFormVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        let categories = ["Engineering", "Business", "Design", "Arts Entertainment", "Communications", "Education", "Environment", "Government", "Health", "International", "Law", "Non-Profit", "Sciences"]

        form +++ Section("Profile")
            <<< TextRow(){ row in
                row.title = "Title"
                row.placeholder = "Enter a job title..."
            }
            <<< TextAreaRow(){
                $0.title = "Description"
                $0.placeholder = "Enter a job description..."
			}
			<<< TextAreaRow(){
                $0.title = "Short Description"
                $0.placeholder = "Enter a short job description..."
			}
			<<< PickerInlineRow<String>("Category") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.map { "\($0)" }
                }
                row.options = categories
                row.value = row.options[0]
        	}
            <<< TextRow(){
                $0.title = "Last Name"
                $0.placeholder = "Enter text here"
			}
			<<< EmailRow(){
                $0.title = "Email"
                $0.placeholder = "Enter email here"
			}
            <<< PhoneRow(){
                $0.title = "Phone"
                $0.placeholder = "Enter phone here"
            }
            <<< TextAreaRow(){
                $0.title = "Bio"
                $0.placeholder = "Enter bio here"
			}
        +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
    }
}
