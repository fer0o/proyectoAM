//
//  RegistroPaciente.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 5/6/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class RegistroPaciente: UIViewController{
    
    @IBOutlet var Nombre: UITextField!
    
    @IBOutlet var Apellido: UITextField!
    
    @IBOutlet var Edad: UITextField!
    
    @IBOutlet var Sexo: UITextField!
    
    @IBOutlet var Telefono: UITextField!
    
    @IBOutlet var Correo: UITextField!
    
    @IBAction func botonLimpiar(_ sender: Any) {
        
    }
    
    @IBAction func botonRegistrar(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(Nombre.text, forKey: "Nombre")
        defaults.set(Apellido.text, forKey: "Apellido")
        defaults.set(Edad.text, forKey: "Edad")
        defaults.set(Sexo.text, forKey: "Sexo")
        defaults.set(Telefono.text, forKey: "Telefono")
        defaults.set(Correo.text, forKey: "Correo")
        defaults.synchronize()
        
        print("Nombre = \(Nombre.text!)")
        print("Apellido = \(Apellido.text!)")
        print("Edad = \(Edad.text!)")
        print("Sexo = \(Sexo.text!)")
        print("Telefono = \(Telefono.text!)")
        print("Correo = \(Correo.text!)")
    }
    
    @IBAction func botonClear(_ sender: Any) {
        //if(Nombre.text == "" || Apellido.text == "" || Edad.text == "" || Sexo.text == "" || Telefono.text == "" || Correo.text == ""){
        //  loadDefaults()
        //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        //}
        //else {
        Nombre.text = ""
        Apellido.text = ""
        Edad.text = ""
        Sexo.text = ""
        Telefono.text = ""
        Correo.text = ""
        //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        //}
    }
    
    
    
    
    func loadDefaults() {
        let defaults = UserDefaults.standard
        Nombre.text = defaults.object(forKey: "Nombre") as? String
        Apellido.text = defaults.object(forKey: "Apellido") as? String
        Edad.text = defaults.object(forKey: "Edad") as? String
        Sexo.text = defaults.object(forKey: "Sexo") as? String
        Telefono.text = defaults.object(forKey: "Telefono") as? String
        Correo.text = defaults.object(forKey: "Correo") as? String
    }
    
    
}
