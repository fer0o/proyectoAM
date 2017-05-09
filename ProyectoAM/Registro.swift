//
//  Registro.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 5/6/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//
//  Registro de Doctores

//iPhone SE path DB: /Users/chiefmaster25/Library/Developer/CoreSimulator/Devices/7A83422C-515D-4692-A6C0-D068C7313D95/data/Containers/Data/Application/04250436-F2B4-4F60-BB4E-95BDBEA43001/Documents/agendaMedica.txt

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Registro: UIViewController{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var id: UITextField!
    
    @IBOutlet var nombre: UITextField!
    
    @IBOutlet var especialidad: UITextField!
    
    @IBOutlet var escuela: UITextField!
    
    @IBOutlet var cedula: UITextField!
    
    @IBOutlet var telefono: UITextField!
    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBAction func generateRandom(_ sender: Any) {
        let n = Int(arc4random_uniform(10000))
        //let n = Int(arc4random_uniform(0-10000)+10000)
        //let a = Int(arc4random(0 - 10000)+10000)
        id.text = "D\(n)"
    }
    
    var baseDatos: OpaquePointer? = nil
    
    var databasePath = String()
    
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
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(NOMINA TEXT PRIMARY KEY, NOMBRE TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT, EMAIL TEXT, PASSWORD TEXT)"
        
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            print ("Tabla Creada")
            return true
        }
        else {
            sqlite3_close(baseDatos)
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            return false
        }
    }
    
    /*func crearTablaDoctores(nombreTabla: String) -> Bool {
     let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(NOMINA TEXT PRIMARY KEY, NOMBRE TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT, EMAIL TEXT, PASSWORD TEXT)"
     
     //"CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(NOMINA TEXT PRIMARY KEY, NOMBRE TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT)"
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
    
    /*func insertarDoctor(/*_ nomina: String, _ nombre: String, _ especialidad: String, _ escuela:String, _ cedula: Int, _ telefono: String*/) {
        let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO, EMAIL, PASSWORD) " + "VALUES ('\(id.text!)', '\(nombre.text!)', '\(especialidad.text!)', '\(escuela.text!)', \(cedula.text!), '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)')"
        //"INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO) "
        //+ "VALUES ('\(nomina)', '\(nombre)', '\(especialidad)', '\(escuela)', \(cedula), '\(telefono)')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar doctor")
        }
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
                let email = String.init(cString: sqlite3_column_text(declaracion, 6))
                let password = String.init(cString: sqlite3_column_text(declaracion, 7))
                print("\(nomina), \(nombre), \(especialidad), \(escuela), \(cedula), \(telefono), \(email), \(password)")
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
    
    func checkFields1(){
        if(id.text == "" || nombre.text == "" || especialidad.text == "" || escuela.text == "" || cedula.text == "" || telefono.text == "" || emailField.text == "" || passwordField.text == ""){
            createAlertRegisterFailed()
        }
        
        if(id.text == "" && nombre.text == "" && especialidad.text == "" && escuela.text == "" && cedula.text == "" && telefono.text == "" && emailField.text == "" && passwordField.text == ""){
            //  loadDefaults()
            createAlertRegisterFailed()
            //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        }
    }
    
    @IBAction func botonRegistrar(_ sender: Any) {
        //let defaults = UserDefaults.standard
        checkFields1()
        
    if abrirBaseDatos(){
            print("ok")
            //consultarBaseDatos()
            //if crearTablaDoctores(nombreTabla: "DOCTORES"){
            //crearDoctores()
            consultarDoctores()
            //sqlite3_close(baseDatos)
            //}
            /*else{
             print("No se puede crear la doctores")
             }
             if crearTablaPacientes(nombreTabla: "PACIENTES"){
             //insertarPaciente()
             }
             else{
             print("No se puede crear la pacientes")*/
 
        
        let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO, EMAIL, PASSWORD) " + "VALUES ('\(id.text!)', '\(nombre.text!)', '\(especialidad.text!)', '\(escuela.text!)', \(cedula.text!), '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)')"
            //let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO, EMAIL, PASSWORD) "
                //+ "VALUES ('\(id.text!)', '\(nombre.text!)', '\(especialidad.text!)', '\(escuela.text!)', \(cedula.text!), '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)')"
        
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("Error al insertar datos")
            print(error as Any)
            print(sqlInserta)
        }
        else{
            print("Registro Exitoso")
            appDelegate.idDoctor = id.text!
            //Register the user with the Firebase
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
            
            /*let sqlInserta = "INSERT INTO EMPLEADOS (NOMINA, NOMBRE, SALARIO) " + "VALUES ('\(nomina.text!)', '\(Nombre.text!)', \(especialidad.text!))"
            //'\(nomina)', '\(nombre)', '\(especialidad)', '\(escuela)', \(cedula), '\(telefono)'
            var error: UnsafeMutablePointer<Int8>? = nil
            
            if sqlite3_exec(baseDatos, sqlI
         nserta, nil, nil, &error) != SQLITE_OK {
                print("Error al insertar datos")
            }*/
            /*defaults.set(id.text, forKey: "id")
            defaults.set(nombre.text, forKey: "nombre")
            defaults.set(especialidad.text, forKey: "especialidad")
            defaults.set(escuela.text, forKey: "escuela")
            defaults.set(cedula.text, forKey: "cedula")
            defaults.set(telefono.text, forKey: "telefono")
            defaults.set(emailField.text, forKey: "correo")
            defaults.set(passwordField.text, forKey: "contraseña")
            defaults.synchronize()*/

            print("\n")
            print("Nomina = \(id.text!)")
            print("Nombre = \(nombre.text!)")
            print("Especialidad = \(especialidad.text!)")
            print("Escuela = \(escuela.text!)")
            print("Cédula = \(cedula.text!)")
            print("Telefono = \(telefono.text!)")
            print("Correo = \(emailField.text!)")
            print("Contraseña = \(passwordField.text!)")
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
            especialidad.text = ""
            escuela.text = ""
            cedula.text = ""
            telefono.text = ""
            emailField.text = ""
            passwordField.text = ""
            //botonClear.setTitle("Limpiar Registro", forState: .Normal)
        //}
    }
    
    /*create table entries (id integer primary key autoincrement -> para crear incremento en la id*/
    
    
    /*func loadDefaults() {
        let defaults = UserDefaults.standard
        id.text = defaults.object(forKey: "nomina") as? String
        nombre.text = defaults.object(forKey: "nombre") as? String
        especialidad.text = defaults.object(forKey: "especialidad") as? String
        escuela.text = defaults.object(forKey: "escuela") as? String
        cedula.text = defaults.object(forKey: "cedula") as? String
        telefono.text = defaults.object(forKey: "telefono") as? String
        emailField.text = defaults.object(forKey: "correo") as? String
        passwordField.text = defaults.object (forKey: "contraseña") as? String
    }*/
    
    func borrarRegistro() {
        let query = "DROP TABLE DOCTORES"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, query, nil, nil, &error) == SQLITE_OK {
            print("Registro borrado")
        } else {
            print("Error al borrar")
            print(error!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let sqlCreaTabla = "CREATE TABLE DOCTORES" + "(NOMINA TEXT, ESPECIALIDAD TEXT, ESCUELA TEXT, CEDULA DECIMAL, TELEFONO TEXT, PRIMARY KEY(NOMINA))"/* INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, UNIVERSIDAD, CEDULA, TELEFONO) VALUES ('','','','','','')"*/
        
        //Para borrar tablas de la BD, SIEMPRE COMENTARLA
        //borrarRegistro()
        
        //esta funcion se ejecuta luego luego que incia la aplicacion y crea la base de datos, aunque ya existe solo la instancia de nuevo cargando los datos anteriores
        //let preferencias = UserDefaults.standard
        //preferencias.synchronize()
        //if let flag = preferencias.string(forKey: "true"){
        //    print("Ya existe BD")
        //}
        //else{
            if abrirBaseDatos(){
                print("ok")
                //consultarBaseDatos()
                //if crearTablaDoctores(nombreTabla: "DOCTORES"){
                    //crearDoctores()
                    consultarDoctores()
                    //sqlite3_close(baseDatos)
                //}
                /*else{
                    print("No se puede crear la doctores")
                }
                if crearTablaPacientes(nombreTabla: "PACIENTES"){
                    //insertarPaciente()
                }
                else{
                    print("No se puede crear la pacientes")
                }*/
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
