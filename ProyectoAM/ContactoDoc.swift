//
//  ContactoDoc.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 3/20/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class ContactoDoc: UIViewController{
    
    var baseDatos: OpaquePointer? = nil
    var nominaC: String = ""
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var especialidaTF: UITextField!
    @IBOutlet weak var escuelaTF: UITextField!
    @IBOutlet weak var cedulaTf: UITextField!
    @IBOutlet weak var telefonaTF: UITextField!
    
    
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
        let sqlConsulta = "SELECT * FROM DOCTORES WHERE NOMINA = '\(nominaC)'"
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
                nombreTF.text = "\(nombre)"
                especialidaTF.text = "\(especialidad)"
                escuelaTF.text = "\(escuela)"
                cedulaTf.text = "\(cedula)"
                telefonaTF.text = "\(telefono)"
            }
        }
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

