//
//  SecondViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit

// This particular view controller is used for the database
class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load all views such that they are ready
        tabBarController?.viewControllers?.forEach { let _ = $0.view }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

