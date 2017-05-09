//
//  RegistroPaciente.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 5/6/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistroPaciente: UIViewController{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var id: UITextField!
    
    @IBOutlet var nombre: UITextField!
    
    @IBOutlet var sexo: UITextField!
    
    @IBOutlet var edad: UITextField!
    
    @IBOutlet var nacimiento: UITextField!
    
    @IBOutlet var direccion: UITextField!
    
    @IBOutlet var telefono: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    var baseDatos: OpaquePointer? = nil
    
    var databasePath = String()
    
    @IBAction func generateRandom(_ sender: Any) {
        let n = Int(arc4random_uniform(10000))
        //let n = Int(arc4random_uniform(0-10000)+10000)
        //let a = Int(arc4random(0 - 10000)+10000)
        id.text = "P\(n)"
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
    
    //SOLO PARA CREAR TABLA DE PACIENTES SI NO EXISTE
    /*func crearTablaPacientes(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(ID TEXT PRIMARY KEY, NOMBRE TEXT, SEXO TEXT, EDAD DECIMAL, FECHANACIMIENTO TEXTO, DIRECCION TEXT, TELEFONO TEXT, CORREO TEXT, PASS TEXT, HISTORIAL TEXT)"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            
            return true
        } else {
            sqlite3_close(baseDatos)
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            return false
        }
    }*/

    
    func checkFields1(){
        if(id.text == "" || nombre.text == "" || sexo.text == "" || edad.text == "" || nacimiento.text == "" || direccion.text == "" || telefono.text == "" || emailField.text == "" || passwordField.text == ""){
            createAlertRegisterFailedPatient()
        }
        
        if(id.text == "" && nombre.text == "" && sexo.text == "" && edad.text == "" && nacimiento.text == "" && direccion.text == "" && telefono.text == "" && emailField.text == "" && passwordField.text == ""){
            //  loadDefaults()
            createAlertRegisterFailedPatient()
            //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        }
    }
    
    
    @IBAction func botonRegistrar(_ sender: Any) {
        //let defaults = UserDefaults.standard
        checkFields1()
        
    if abrirBaseDatos(){
            print("ok")
        
        let sqlInserta = "INSERT INTO PACIENTES (ID, NOMBRE, SEXO, EDAD, FECHANACIMIENTO, DIRECCION, TELEFONO, CORREO, CONTRASEÑA, HISTORIAL) " + "VALUES ('\(id.text!)', '\(nombre.text!)', '\(sexo.text!)', '\(edad.text!)', '\(nacimiento.text!)', '\(direccion.text!)', '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)', 'NULL')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("Error al insertar datos")
            print(error as Any)
            print(sqlInserta)
        }
        else{
            print("Registro Exitoso")
            appDelegate.idDoctor = id.text!
            if let email = emailField.text, let pass = passwordField.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let u = user {
                        //User is found, go to home screen
                        
                        print("Registro exitoso.")
                        //self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else{
                        //Error: check error and show message.
                        //self.createAlertRegister()
                    }
                })
            }
            
            self.createAlertRegisterSuccessful()
        }
        
    } else{
        print("Error al abrir BD")
        }
        sqlite3_close(baseDatos)


        
        //else {
            
            /*defaults.set(id.text, forKey: "ID")
            defaults.set(nombre.text, forKey: "Nombre")
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
            print("Correo = \(Correo.text!)")*/
        //}
        
    }
    
    func createAlertRegisterFailedPatient(){
        let alertaInicio  = UIAlertController(title: "Intenta de nuevo", message: "Existen campos vacíos para registrarse.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaInicio.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaInicio.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaInicio, animated: true, completion: nil)
    }
    
    func createAlertRegisterSuccessful(){
        let alertaInicio  = UIAlertController(title: "Registro Exitoso", message: "Tu registro está completo, por favor inicia sesión.", preferredStyle: UIAlertControllerStyle.alert)
        
        //alerta.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:  { action in self.performSegue(withIdentifier: "returnLoginDoctor", sender: self)})
        alertaInicio.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            //alertaInicio.performSegue(withIdentifier: "returnLoginDoctor", sender: self)
            //("returnLoginDoctor", animated: self)
            alertaInicio.dismiss(animated:true, completion: nil)
        }))
        
        //self.present("returnLoginDoctor", animated: self)
        self.present(alertaInicio, animated: true, completion: nil)
    }
    
    func createAlertRegisterFailed(){
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
        id.text = ""
        nombre.text = ""
        sexo.text = ""
        edad.text = ""
        nacimiento.text = ""
        direccion.text = ""
        telefono.text = ""
        emailField.text = ""
        passwordField.text = ""
        
        //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        //}
    }
    
    func consultarPaciente(){
        let sqlConsulta = "SELECT * FROM PACIENTES"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let id = String.init(cString: sqlite3_column_text(declaracion, 0))
                let sexo = String.init(cString: sqlite3_column_text(declaracion, 1))
                let edad = String.init(cString: sqlite3_column_text(declaracion, 2))
                let nacimiento = String.init(cString: sqlite3_column_text(declaracion, 3))
                let direccion = String.init(cString: sqlite3_column_text(declaracion, 4))
                let telefono = String.init(cString: sqlite3_column_text(declaracion, 5))
                let correo = String.init(cString: sqlite3_column_text(declaracion, 6))
                let pass = String.init(cString: sqlite3_column_text(declaracion, 7))
                let historial = String.init(cString: sqlite3_column_text(declaracion, 8))
                print("\(id), \(sexo), \(edad), \(nacimiento), \(direccion), \(telefono), \(correo), \(pass), \(historial)")
            }
        }
    }
    
    /*func loadDefaults() {
        let defaults = UserDefaults.standard
        Nombre.text = defaults.object(forKey: "Nombre") as? String
        Apellido.text = defaults.object(forKey: "Apellido") as? String
        Edad.text = defaults.object(forKey: "Edad") as? String
        Sexo.text = defaults.object(forKey: "Sexo") as? String
        Telefono.text = defaults.object(forKey: "Telefono") as? String
        Correo.text = defaults.object(forKey: "Correo") as? String
    }*/
    
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
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(ID TEXT PRIMARY KEY, NOMBRE TEXT, SEXO TEXT, EDAD DECIMAL, FECHANACIMIENTO TEXTO, DIRECCION TEXT, TELEFONO TEXT, CORREO TEXT, CONTRASEÑA TEXT, HISTORIAL TEXT)"
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        ScrollView.contentInset = contentInsets
        ScrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        ScrollView.contentInset = UIEdgeInsets.zero
        ScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let sqlCreaTabla = "CREATE TABLE DOCTORES" + "(NOMINA TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT, PRIMARY KEY(NOMINA))"/* INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, UNIVERSIDAD, CEDULA, TELEFONO) VALUES ('','','','','','')"*/
        
        //esta funcion se ejecuta luego luego que incia la aplicacion y crea la base de datos, aunque ya existe solo la instancia de nuevo cargando los datos anteriores
        //let preferencias = UserDefaults.standard
        //preferencias.synchronize()
        //if let flag = preferencias.string(forKey: "true"){
        //    print("Ya existe BD")
        //} else{
            if abrirBaseDatos(){
                print("ok")
                //consultarBaseDatos()
                //if crearTablaDoctores(nombreTabla: "DOCTORES"){
                    //crearDoctores()
                //    consultarDoctores()
                //}
                //else{
                //    print("No se puede crear la doctores")
                //}
                //if crearTablaPacientes(nombreTabla: "PACIENTES"){
                    //insertarPaciente()
                //}
                //else{
                //    print("No se puede crear la pacientes")
                //}
            } else{
                print("Error al abrir BD")
            }
            sqlite3_close(baseDatos)
            //preferencias.set("iniciado", forKey: "true")
            //preferencias.synchronize()
        //}
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
