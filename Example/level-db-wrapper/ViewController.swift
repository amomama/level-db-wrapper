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
    
    @IBAction func storeAndReadKeys() {
        
        for i in 0..<1000 {
            let key = "aaaaa_\(i)"
            self.db[key] = key
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let keys = self?.db.collectKeys(offset: 0) else { return }
            for key in keys {
                print("key: \(key)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                for key in keys {
                    self?.db.delete(key: key)
                    print("del key: \(key)")
                }
            }
        }
    }

}

