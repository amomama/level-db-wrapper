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
    
    let db = LevelDB(name: "testDB")
    var click: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func readKeys() {
        let keys = db.collectKeys(offset: 0)
        for key in keys {
            print("Read key: \(key)")
            let _ = db.delete(key: key)
        }
    }
    
    @IBAction func storeKeys() {
        let key = "\(self.click)"
        
        for i in 0..<10000 {
            let key = "key" + key + "\(i + 1)"
            let value = "value" + key
            
            db[key] = value
            
            //print("Write key: \(key)")
        }
        
        self.click += 1
    }

}

