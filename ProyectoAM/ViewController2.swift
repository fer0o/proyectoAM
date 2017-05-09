//
//  ViewController2.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 5/6/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import KeychainSwift

class ViewController2: UIViewController, UITextFieldDelegate{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //var username = NSUserName()
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    var isSignIn2: Bool = true
    
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton1: UIButton!
    
    var baseDatos: OpaquePointer? = nil
    
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
    
    /*func crearDoctores(){
        insertarDoctor("D01375758", "Luis Fernando Espinosa Elizalde", "Neurocirujano", "ITESM", 11375758, "55-6068-0871")
        insertarDoctor("D01169427", "Luis Felipe Espinosa Elizalde", "Ortodoncista", "LaSalle", 21169427, "55-8952-6655")
        insertarDoctor("D01169661", "Allan Iván Ramírez Alanis", "Medico General", "UNAM", 41169661, "55-6451-3544")
        insertarDoctor("D01169814", "Fernando Angel Medellin Cuevas", "Optometrista", "Ibero", 31169814, "55-1234-4567")
        insertarDoctor("D01018322", "Arturo Velazquez Ríos", "Pediatra", "Paramericana", 60108322, "55-9876-5412")
    }*/
    
    func insertarDoctor(/*_ nomina: String, _ nombre: String, _ especialidad: String, _ escuela:String, _ cedula: Int, _ telefono: String*/) {
        //let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO, EMAIL, PASSWORD) " + "VALUES ('\(id.text!)', '\(nombre.text!)', '\(especialidad.text!)', '\(escuela.text!)', \(cedula.text!), '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)')"
        //let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO, EMAIL, PASSWORD) "
        //+ "VALUES ('\(id.text!)', '\(nombre.text!)', '\(especialidad.text!)', '\(escuela.text!)', \(cedula.text!), '\(telefono.text!)', '\(emailField.text!)', '\(passwordField.text!)')"
        //var error: UnsafeMutablePointer<Int8>? = nil
        //if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            //print("Error al insertar datos")
        //}
        //else{
        //    print("Registro Exitoso")
        //}
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
                let email = String.init(cString: sqlite3_column_text(declaracion, 6))
                let password = String.init(cString: sqlite3_column_text(declaracion, 7))
                print("\(nomina), \(nombre), \(especialidad), \(escuela), \(cedula), \(telefono), \(email), \(password)")
            }
        }
    }
    
    func insertarPaciente() {
        let sqlInserta = "INSERT INTO PACIENTES (ID, NOMBRE, SEXO, EDAD, FECHANACIMIENTO, DIRECCION, TELEFONO, HISTORIAL) " + "VALUES ('P01111111', 'Ana Duarte Gomez', 'Mujer', '19', '21/08/1998', 'Doctores 101, Satelite, Edo. Mex', '55-1452-5696', 'NULL')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar datos")
        }
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
                let historial = String.init(cString: sqlite3_column_text(declaracion, 6))
                print("\(id), \(sexo), \(edad), \(nacimiento), \(direccion), \(telefono), \(historial)")
            }
        }
    }
    
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
                //    insertarPaciente()
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
        
        let keyChain = DataService().keyChain
        
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
        }
        
        
        
        //let imagen1 = UIImage(named: "tablita3.png")
        //let imageview = UIImageView(image; imagen1)
        //imageview.contentMode UIViewContentMode.scaleAspectFit
        //UIGraphicsBeginImageContext(self.imageview.frame.size)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"tablita3")!)
        //self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named:"tablita3"))
        //UIGraphicsBeginImageContext(self.view.frame.size)
        //UIImage(named: "tablita3.png")?.draw(in: self.view.bounds)//?.draw(in: self.view.bounds)
        //UIImage.ScaleAspectFill
        
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
    
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignIn2 = !isSignIn2
        
        //Check the bool and set the buttons and labels
        
        if isSignIn2 {
            signInLabel.text = "Iniciar Sesión"
            signInButton1.setTitle("Iniciar Sesión", for: .normal)
        }
        else{
            signInLabel.text = "Registrarse"
            signInButton1.setTitle("Registrarse", for: .normal)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
     
     if (segue.identifier == "MenuDoctor") {
     var VC2 : VC2 = segue.destinationViewController as VC2
     VC2.buttonTag = sender.tag
     
     }
     if (segue.identifier == "RegistroDoctor") {
     var VC2 : VC2 = segue.destinationViewController as VC2
     VC2.buttonTag = sender.tag
     }
     }*/
    
    func sacarID(_ email: String){
        if abrirBaseDatos(){
            print("ok")
            //print(email)
            let sqlConsulta = "SELECT ID FROM PACIENTES WHERE CORREO = '\(email)'"
            var declaracion: OpaquePointer? = nil
            if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
                while sqlite3_step(declaracion) == SQLITE_ROW {
                    appDelegate.idPaciente  = String.init(cString: sqlite3_column_text(declaracion, 0))
                    print(appDelegate.idPaciente)
                }
            }
        } else{
            print("Error al abrir BD")
        }
        sqlite3_close(baseDatos)
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        //Validation Email and Password
        if let email = emailField.text, let pass = passwordField.text {
            
            if isSignIn2 {
                
                sacarID(emailField.text!)
                if self.emailField.text == "" || self.passwordField.text == "" {
                    createAlertSigning()
                    print("Please enter email and password.")
                }
                else{
                    //Sign in the user with the Firebase
                    FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                        //code
                        if let u = user{
                            //User found
                            self.sacarID(self.emailField.text!)
                            self.performSegue(withIdentifier: "goToHome2", sender: self)
                            
                        }
                        else{
                            self.createAlertLoginFailed()
                            //Check error in show message.
                            //self.createAlertSigning()
                        }
                    })
                }
                
            }
            else {
                emailField.isUserInteractionEnabled = false
                passwordField.isUserInteractionEnabled = false
                
                //emailField.isEditable = false
                //passwordField.isEditable = false
                
                emailField.isEnabled = false
                passwordField.isEnabled = false
                
                performSegue(withIdentifier: "RegistroPaciente", sender: nil)
                
                /*     if self.emailField.text == "" || self.passwordField.text == "" {
                 createAlertRegister()
                 print("Please enter email and password.")
                 }
                 else{
                 //Register the user with the Firebase
                 FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                 
                 if let u = user {
                 //User is found, go to home screen
                 self.createAlertRegisterSuccessful()
                 //self.performSegue(withIdentifier: "goToHome", sender: self)
                 }
                 else{
                 //Error: check error and show message.
                 //self.createAlertRegister()
                 }
                 })
                 }*/
            }
        }
    }
    
    func createAlertSigning(){
        let alertaInicio  = UIAlertController(title: "Intenta de nuevo", message: "Campos vacíos de inicio de sesión.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaInicio.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaInicio.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaInicio, animated: true, completion: nil)
    }
    
    func createAlertRegister(){
        let alertaRegistro  = UIAlertController(title: "Intenta de nuevo", message: "Los campos del registro se encuentran vacíos o surgió un error.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaRegistro.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaRegistro.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaRegistro, animated: true, completion: nil)
    }
    
    func createAlertRegisterSuccessful(){
        let alertaRegistro  = UIAlertController(title: "Registro Exitoso", message: "Bienvenido al sistema, por favor inicia sesión.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaRegistro.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaRegistro.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaRegistro, animated: true, completion: nil)
    }
    
    func createAlertLoginFailed(){
        let alertaRegistro  = UIAlertController(title: "Error", message: "Usuario/Contraseña no existente o incorrecta, revisa tus credenciales.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertaRegistro.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertaRegistro.dismiss(animated:true, completion: nil)
        }))
        self.present(alertaRegistro, animated: true, completion: nil)
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
