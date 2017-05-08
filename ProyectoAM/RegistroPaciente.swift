//
//  RegistroPaciente.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 5/6/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class RegistroPaciente: UIViewController{
    
    @IBOutlet var id: UITextField!
    
    @IBOutlet var Nombre: UITextField!
    
    @IBOutlet var Apellido: UITextField!
    
    @IBOutlet var Edad: UITextField!
    
    @IBOutlet var Sexo: UITextField!
    
    @IBOutlet var Telefono: UITextField!
    
    @IBOutlet var Correo: UITextField!
    
    var baseDatos: OpaquePointer? = nil
    
    @IBAction func generateRandom(_ sender: Any) {
        let n = Int(arc4random_uniform(10000))
        //let n = Int(arc4random_uniform(0-10000)+10000)
        //let a = Int(arc4random(0 - 10000)+10000)
        id.text = "D\(n)"
    }
    
    @IBAction func botonRegistrar(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if(Nombre.text == "" || Apellido.text == "" || Edad.text == "" || Sexo.text == "" || Telefono.text == "" || Correo.text == ""){
            createAlertRegisterFailedPatient()
        }
        if(Nombre.text == "" && Apellido.text == "" && Edad.text == "" && Sexo.text == "" && Telefono.text == "" && Correo.text == ""){
            //  loadDefaults()
            createAlertRegisterFailedPatient()
            //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        }
        else {
            
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
    }
    
    func createAlertRegisterFailedPatient(){
        let alertaInicio  = UIAlertController(title: "Intenta de nuevo", message: "Existen campos vacíos para registrarse.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaInicio.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaInicio.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaInicio, animated: true, completion: nil)
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
    
    // MARK: - Funciones de la BD
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("agendaMedica.txt") {
            print(path)
            if sqlite3_open(path.absoluteString, &baseDatos) == SQLITE_OK { return true
            }
            // Error
            sqlite3_close(baseDatos)
        }
        return false
    }
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func crearTablaDoctores(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(NOMINA TEXT PRIMARY KEY, NOMBRE TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT)"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            return true
        } else {
            sqlite3_close(baseDatos)
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            return false
        }
    }
    
    func insertarDoctor(_ nomina: String, _ nombre: String, _ especialidad: String, _ escuela:String, _ cedula: Int, _ telefono: String) {
        let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO) "
            + "VALUES ('\(nomina)', '\(nombre)', '\(especialidad)', '\(escuela)', \(cedula), '\(telefono)')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar doctor")
        }
    }
    
    func consultarDoctores(){
        let sqlConsulta = "SELECT * FROM DOCTORES"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let nomina = String.init(cString: sqlite3_column_text(declaracion, 0))
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 1))
                let especialidad = String.init(cString: sqlite3_column_text(declaracion, 2))
                let escuela = String.init(cString: sqlite3_column_text(declaracion, 3))
                let cedula = String.init(cString: sqlite3_column_text(declaracion, 4))
                let telefono = String.init(cString: sqlite3_column_text(declaracion, 5))
                print("\(nomina), \(nombre), \(especialidad), \(escuela), \(cedula), \(telefono)")
            }
        }
    }
    
    //SOLO PARA CREAR TABLA DE PACIENTES SI NO EXISTE
    func crearTablaPacientes(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(ID TEXT PRIMARY KEY, NOMBRE TEXT, SEXO TEXT, EDAD DECIMAL, FECHANACIMIENTO TEXTO, DIRECCION TEXT, TELEFONO TEXT, HISTORIAL TEXT)"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            return true
        } else {
            sqlite3_close(baseDatos)
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //let sqlCreaTabla = "CREATE TABLE DOCTORES" + "(NOMINA TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT, PRIMARY KEY(NOMINA))"/* INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, UNIVERSIDAD, CEDULA, TELEFONO) VALUES ('','','','','','')"*/
        
        //esta funcion se ejecuta luego luego que incia la aplicacion y crea la base de datos, aunque ya existe solo la instancia de nuevo cargando los datos anteriores
        let preferencias = UserDefaults.standard
        preferencias.synchronize()
        if let flag = preferencias.string(forKey: "true"){
            print("Ya existe BD")
        } else{
            if abrirBaseDatos(){
                print("ok")
                //consultarBaseDatos()
                if crearTablaDoctores(nombreTabla: "DOCTORES"){
                    //crearDoctores()
                    consultarDoctores()
                }
                else{
                    print("No se puede crear la doctores")
                }
                if crearTablaPacientes(nombreTabla: "PACIENTES"){
                    //insertarPaciente()
                }
                else{
                    print("No se puede crear la pacientes")
                }
            } else{
                print("Error al abrir BD")
            }
            sqlite3_close(baseDatos)
            preferencias.set("iniciado", forKey: "true")
            preferencias.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
