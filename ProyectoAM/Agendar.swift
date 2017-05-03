//
//  Agendar.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 3/20/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class Agendar: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var baseDatos: OpaquePointer? = nil
    var nombres = [String] ()
    var especialidades = [String] ()
    var nominas = [String] ()
    var nominaC:String = ""

    //var baseDatos: OpaquePointer? = nil
    //var nombres = [String] ()
    //var especialidades = [String] ()
    //var nominas = [String] ()
    //var nominaC:String = ""
    //var idPaciente = "P01111111"
    @IBOutlet weak var fechaPV: UIDatePicker!
    
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(nominas[indexPath.row])
        nominaC = nominas[indexPath.row]
    }
    
    //MARK: - Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaDoc", for: indexPath)
        celda.textLabel?.text = especialidades[indexPath.row]
        //Subtitulos (detalles)
        celda.detailTextLabel?.text = nombres[indexPath.row]
        return celda
    }
    
    // MARK: - Funciones de la BD
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("agendaMedica.txt") {
            print(path)
            if sqlite3_open(path.absoluteString, &baseDatos) == SQLITE_OK { return true
            }
            // Error ç
            sqlite3_close(baseDatos)
        }
        return false
    }
    
    /*func crearTabla(nombreTabla: String) -> Bool {
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
    
    func crearTabla(nombreTabla: String) -> Bool {
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
    }*/
    
    func crearTabla(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(DOCTORID TEXT, PACIENTEID TEXT, FECHA TEXT, PRIMARY KEY (DOCTORID, PACIENTEID), FOREIGN KEY (DOCTORID) REFERENCES DOCTORES(NOMINA), FOREIGN KEY (PACIENTEID) REFERENCES PACIENTES(ID))"
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
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    /*func insertarDatos() {
        let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO) "
            + "VALUES ('D01169427', 'Luis Felipe Espinosa Elizalde', 'Ortodoncista', 'LaSalle', 21169427, '55-8952-6655')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar datos")
        }
    }*/
    
    /*func insertarPaciente() {
        let sqlInserta = "INSERT INTO PACIENTES (ID, NOMBRE, SEXO, EDAD, FECHANACIMIENTO, DIRECCION, TELEFONO, HISTORIAL) "
            + "VALUES ('P01111111', 'Ana Duarte Gomez', 'Mujer', '19', '21/08/1998', 'Doctores 101, Satelite, Edo. Mex', '55-1452-5696', 'NULL')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar datos")
        }
    }*/
    
    func consultarBaseDatos() {
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
                nombres.append(nombre)
                especialidades.append(especialidad)
                nominas.append(nomina)
            }
        }
    }
    
    func consultarBaseDatos2() {
        let sqlConsulta = "SELECT * FROM CITAS"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let doctor = String.init(cString: sqlite3_column_text(declaracion, 0))
                let paciente = String.init(cString: sqlite3_column_text(declaracion, 1))
                let fecha = String.init(cString: sqlite3_column_text(declaracion, 2))
                print("\(doctor), \(paciente),\(fecha)")
            }
        }
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(nominas[indexPath.row])
        nominaC = nominas[indexPath.row]
    }
    
    //MARK: - Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaDoc", for: indexPath)
        celda.textLabel?.text = especialidades[indexPath.row]
        //Subtitulos (detalles)
        celda.detailTextLabel?.text = nombres[indexPath.row]
        return celda
    }
    
    // MARK: - Funciones de la BD
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("agendaMedica.txt") {
            print(path)
            if sqlite3_open(path.absoluteString, &baseDatos) == SQLITE_OK { return true
            }
            // Error ç
            sqlite3_close(baseDatos)
        }
        return false
    }
    
    /*func crearTabla(nombreTabla: String) -> Bool {
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
     
     func crearTabla(nombreTabla: String) -> Bool {
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
     }*/
    
    func crearTabla(nombreTabla: String) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(DOCTORID TEXT, PACIENTEID TEXT, FECHA TEXT, BANDERA TEXT, PRIMARY KEY (DOCTORID, PACIENTEID, FECHA), FOREIGN KEY (DOCTORID) REFERENCES DOCTORES(NOMINA), FOREIGN KEY (PACIENTEID) REFERENCES PACIENTES(ID))"
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
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    /*func insertarDatos() {
     let sqlInserta = "INSERT INTO DOCTORES (NOMINA, NOMBRE, ESPECIALIDAD, ESCUELA, CEDULA, TELEFONO) "
     + "VALUES ('D01169427', 'Luis Felipe Espinosa Elizalde', 'Ortodoncista', 'LaSalle', 21169427, '55-8952-6655')"
     var error: UnsafeMutablePointer<Int8>? = nil
     if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar datos")
     }
     }*/
    
    /*func insertarPaciente() {
     let sqlInserta = "INSERT INTO PACIENTES (ID, NOMBRE, SEXO, EDAD, FECHANACIMIENTO, DIRECCION, TELEFONO, HISTORIAL) "
     + "VALUES ('P01111111', 'Ana Duarte Gomez', 'Mujer', '19', '21/08/1998', 'Doctores 101, Satelite, Edo. Mex', '55-1452-5696', 'NULL')"
     var error: UnsafeMutablePointer<Int8>? = nil
     if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK { print("Error al insertar datos")
     }
     }*/
    
    func consultarBaseDatos() {
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
                nombres.append(nombre)
                especialidades.append(especialidad)
                nominas.append(nomina)
            }
        }
    }
    
    func consultarBaseDatos2() {
        let sqlConsulta = "SELECT * FROM CITAS"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let doctor = String.init(cString: sqlite3_column_text(declaracion, 0))
                let paciente = String.init(cString: sqlite3_column_text(declaracion, 1))
                let fecha = String.init(cString: sqlite3_column_text(declaracion, 2))
                let bandera = String.init(cString: sqlite3_column_text(declaracion, 3))
                print("\(doctor), \(paciente),\(fecha), \(bandera)")
            }
        }
    }
    
    func borrarRegistro() {
        let query = "DROP TABLE CITAS"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, query, nil, nil, &error) == SQLITE_OK {
            print("Registro borrado")
        } else {
            print("Error al borrar")
        }
    }
    
    
    @IBAction func agregarCita(_ sender: Any) {
        /*let fecha = fechaPV.date
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM d, YYYY. h:mm a"
        print(formateador.string(from: fecha))
        let sqlInserta = "INSERT INTO CITAS (DOCTORID, PACIENTEID, FECHA) "
            + "VALUES ('\(nominaC)', '\(idPaciente)', '\(formateador.string(from: fecha))')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("Error al insertar datos")
            let alertaMal = UIAlertController(title: "Aviso", message: "Error al insertar datos", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaMal.addAction(btnAceptar)
            present(alertaMal, animated: true, completion: nil)
        }
        else{
            let alertaBien = UIAlertController(title: "Cita agendada", message: "La cita fue guardada con exito", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaBien.addAction(btnAceptar)
            present(alertaBien, animated: true, completion: nil)
        }*/
        let fecha = fechaPV.date
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM d, YYYY. h:mm a"
        print(formateador.string(from: fecha))
        let sqlInserta = "INSERT INTO CITAS (DOCTORID, PACIENTEID, FECHA, BANDERA) "
            + "VALUES ('\(nominaC)', '\(appDelegate.idPaciente)', '\(formateador.string(from: fecha))', '0')"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("Error al insertar datos")
            let alertaMal = UIAlertController(title: "Aviso", message: "Error al insertar datos", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaMal.addAction(btnAceptar)
            present(alertaMal, animated: true, completion: nil)
        }
        else{
            let alertaBien = UIAlertController(title: "Cita agendada", message: "La cita fue guardada con exito", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaBien.addAction(btnAceptar)
            present(alertaBien, animated: true, completion: nil)
        }

    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if abrirBaseDatos(){
            print("ok")
            consultarBaseDatos()
            if crearTabla(nombreTabla: "CITAS"){
                consultarBaseDatos2()
                //insertarPaciente()
                print("--------")
                //consultarBaseDatos2()
                //insertarDatos()
                //borrarRegistro()
                //Cerrar BD
                //sqlite3_close(baseDatos)
            }
            else{
                print("No se puede crear la tabla")
            }
        } else{
            print("Error al abrir BD")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
