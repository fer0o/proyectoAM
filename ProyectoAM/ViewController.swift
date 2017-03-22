//
//  ViewController.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 10/02/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift

class ViewController: UIViewController {
    
    //var username = NSUserName()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //let keyChain = DataService().keyChain
    
    //Prueba cuando ya el usuario se loguea, se utiliza ViewDidAppear
    
    /*
     override func viewDidLoad(){
        super.viewDidLoad()
     }
     
     override func viewDidAppear(_ animated: Bool){
        let keyChain = DataServices().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
        }
     }
 
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyChain = DataService().keyChain

        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func CompleteSignIn (id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
    }
    
    @IBAction func SignIn(_ sender: Any){
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    self.CompleteSignIn(id: user!.uid)
                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                }
                else{
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            print("No se puede iniciar sesión...")
                        }
                        else{
                            self.CompleteSignIn(id: user!.uid)
                            self.performSegue(withIdentifier: "SignIn", sender: nil)
                        }
                    }
                }
            }
        }
    }
}

    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
            //print el git esta muy malo 
        }
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        self.performSegue(withIdentifier: "loginView", sender: self)
    }*/
