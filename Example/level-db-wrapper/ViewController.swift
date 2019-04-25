//
//  ViewController.swift
//  level-db-wrapper
//
//  Created by ivan-genesis on 04/23/2019.
//  Copyright (c) 2019 ivan-genesis. All rights reserved.
//

import UIKit
import level_db_wrapper

class ViewController: UIViewController {
    
    private let db = LevelDB(name: "testDB")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func storeAndReadKeys() {
        db["aaaa"] = "aaaa1"
        db["bbbb"] = "bbbb1"
        db["cccc"] = "cccc1"
        db["dddd"] = "dddd1"
        db["eeee"] = "eeee1"
        db["ffff"] = "ffff1"
        
        let keys = db.collectKeys(offset: 0)
        for key in keys {
            print("key: \(key)")
        }
    }

}

