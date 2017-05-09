//
//  SignOutCode.swift
//  ProyectoAM
//
//  Created by Fernando Medellin on 22/03/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit
import Firebase
import KeychainSwift

class SignOutCode: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cerrarSesion(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            print("Cierre de Sesión completo")
        }
        catch let signOutError as NSError {
            print("No se pudo cerrar sesión...", signOutError)
        }
        DataService().keyChain.delete("uid")
        //KeychainSwift().delete("uid")
        dismiss(animated: true, completion: nil)
    }
    /*@IBAction func SignOut (_ sender: Any){
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
        }
        catch let signOutError as NSError {
            print("No se pudo cerrar sesión...", signOutError)
        }
        DataService().keyChain.delete("uid")
        //KeychainSwift().delete("uid")
        dismiss(animated: true, completion: nil)
    }*/
}
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//}
