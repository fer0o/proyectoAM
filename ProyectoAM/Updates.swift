//
//  Updates.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 03/05/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class Updates: UIViewController{
    
    var baseDatos: OpaquePointer? = nil
    
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
    
    func crearDoctores(){
        insertarDoctor("D01375758", "Luis Fernando Espinosa Elizalde", "Neurocirujano", "ITESM", 11375758, "55-6068-0871")
        insertarDoctor("D01169427", "Luis Felipe Espinosa Elizalde", "Ortodoncista", "LaSalle", 21169427, "55-8952-6655")
        insertarDoctor("D01169661", "Allan Iván Ramírez Alanis", "Medico General", "UNAM", 41169661, "55-6451-3544")
        insertarDoctor("D01169814", "Fernando Angel Medellin Cuevas", "Optometrista", "Ibero", 31169814, "55-1234-4567")
        insertarDoctor("D01018322", "Arturo Velazquez Ríos", "Pediatra", "Paramericana", 60108322, "55-9876-5412")
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
 
    /*override func viewDidLoad() {
        super.viewDidLoad()
        let preferencias = UserDefaults.standard
        preferencias.synchronize()
        if let flag = preferencias.string(forKey: "true"){
            
        } else{
            if abrirBaseDatos(){
                print("ok")
                //consultarBaseDatos()
                if crearTablaDoctores(nombreTabla: "DOCTORES"){
                    crearDoctores()
                    consultarDoctores()
                }
                else{
                    print("No se puede crear la doctores")
                }
                if crearTablaPacientes(nombreTabla: "PACIENTES"){
                    insertarPaciente()
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
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
