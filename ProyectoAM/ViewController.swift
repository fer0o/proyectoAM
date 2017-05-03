//
//  ViewController.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 10/02/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import KeychainSwift

class ViewController: UIViewController {
    
    //var username = NSUserName()
    
    
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    var isSignIn: Bool = true
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton1: UIButton!
    
    
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
    
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignIn = !isSignIn
        
        //Check the bool and set the buttons and labels
        
        if isSignIn {
            signInLabel.text = "Iniciar Sesión"
            signInButton1.setTitle("Iniciar Sesión", for: .normal)
        }
        else{
            signInLabel.text = "Registrarse"
            signInButton1.setTitle("Registrarse", for: .normal)
        }
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //Validation Email and Password
        
        if let email = emailField.text, let pass = passwordField {
        
        
        if isSignIn {
            //Sign in the user with the Firebase
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: {user?, error?) in
                //code
                if let u = user{
                    //User found
                    
                }
                else{
                    //Check error in show message.
                }
                
                
            })
            
        }
        else{
            //Register the user with the Firebase
            FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                
                if let u = user {
                    //User is found, go to home screen
                    
                }
                else{
                    //Error: check error and show message.
                }
            })
        }
        }
    
    }
    
    
    
    func CompleteSignIn (id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
    }
    
    //Modificar Inicio de sesión
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
