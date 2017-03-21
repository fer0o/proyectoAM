//
//  ViewController.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 10/02/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var username = NSUserName()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
        
        
        
        
        self.performSegue(withIdentifier: "loginView", sender: self)
    }


}

