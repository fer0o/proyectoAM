//
//  LoginDocViewController.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 21/03/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class LoginDocViewController: UIViewController {
    //---------------Outlets----------------
    
    @IBOutlet weak var userEmailTF: UITextField!
    
    
    @IBOutlet weak var userPasswordTF: UITextField!
    
    
    //-------------Fin de Outlets------------
    
    
    //------------Actions--------------------
    
    @IBAction func loginButtonT(_ sender: Any) {
        
        let userEmail = userEmailTF.text
        let userPassword = userPasswordTF.text
        
        //leer datos ya registrados
        
        let userEmailStored = UserDefaults.standard.string(forKey: "user Email")
        let userPasswordStored = UserDefaults.standard.string(forKey: "user Password")
        
        if(userEmailStored == userEmail){
            
            
            
            if (userPasswordStored == userPassword){
                
                //login exitoso
                
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                print("plis logea")
                //(true, forKey: "el usuario se ha logeado")
                UserDefaults.standard.synchronize()
                
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
