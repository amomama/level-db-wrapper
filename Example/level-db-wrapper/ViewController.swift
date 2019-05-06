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
    
    @IBAction func storeAndReadKeys() {
        
        let key = "\(self.click)"
        
        
        for i in 0..<1000 {
            let key = "key" + key + "\(i + 1)"
            let value = "value" + key
            
            db[key] = value
            
            let keys = db.collectKeys(offset: 0)
            for key in keys {
                print("key: \(key)")
                let _ = db.delete(key: key)
            }
        }
        
        
        
        self.click += 1
    }

}

