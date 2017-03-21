//
//  RegistrationDocViewController.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 21/03/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class RegistrationDocViewController: UIViewController {

    //--------------------outlets
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var repeatUserPasswordTextField: UITextField!
    //-------------------fin de los outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //accttion boton registrarse
    
    @IBAction func botonRegistro(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatUserPasswordTextField.text
        
        //revisar campos vacios
        
        if((userEmail == "") || (userPassword == "") || (userRepeatPassword == "")){
            //muestra mensaje
            
            displayMyAlertMessage(userMessage: " Los campos están vacios ")
            
            return
            
        }
        if(userPassword != userRepeatPassword){
            //despliega mensjae de no coinciden
            
            
            displayMyAlertMessage(userMessage: " The passwords no coinciden ")
            return
        }
        UserDefaults.standard.setValue(userEmail, forKey: "user Email")
        UserDefaults.standard.setValue(userPassword, forKey: "user Password")
        UserDefaults.standard.synchronize()
        
        var myAlert = UIAlertController(title: "Alert", message: "Registro Completo", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //funcion que despliega el mensaje
    func displayMyAlertMessage(userMessage: String){
        let  myAlert  = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        
        let okAction = UIAlertAction(title: " ok ", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)


        
        
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
