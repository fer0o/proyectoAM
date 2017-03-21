//
//  ContactoPac.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 3/20/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class ContactoPac: UIViewController{
    
    var baseDatos: OpaquePointer? = nil
    var idPac: String = ""
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var sexoTF: UITextField!
    @IBOutlet weak var edadTF: UITextField!
    @IBOutlet weak var fechaTF: UITextField!
    @IBOutlet weak var direccionTF: UITextField!
    @IBOutlet weak var telefonoTF: UITextField!
    
    
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
    
    func consultarBaseDatos() {
        let sqlConsulta = "SELECT * FROM PACIENTES WHERE ID = '\(idPac)'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let id = String.init(cString: sqlite3_column_text(declaracion, 0))
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 1))
                let sexo = String.init(cString: sqlite3_column_text(declaracion, 2))
                let edad = String.init(cString: sqlite3_column_text(declaracion, 3))
                let fechaN = String.init(cString: sqlite3_column_text(declaracion, 4))
                let direccion = String.init(cString: sqlite3_column_text(declaracion, 5))
                let telefono = String.init(cString: sqlite3_column_text(declaracion, 5))
                print("\(id), \(nombre), \(sexo), \(edad), \(fechaN), \(direccion)", "\(telefono)")
                nombreTF.text = "\(nombre)"
                sexoTF.text = "\(sexo)"
                edadTF.text = "\(edad)"
                fechaTF.text = "\(fechaN)"
                direccionTF.text = "\(direccion)"
                telefonoTF.text = "\(telefono)"
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pasar el pais el segundo controlador
        let segundoVC = segue.destination as! Historial
        segundoVC.idPac = idPac
    }
    
    override func viewDidLoad() {
        if abrirBaseDatos(){
            print("ok")
            consultarBaseDatos()
            sqlite3_close(baseDatos)
        } else{
            print("Error al abrir BD")
        }
    }
}
