//
//  Historial.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 3/20/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class Historial: UIViewController{
    
    var baseDatos: OpaquePointer? = nil
    var idPac: String = ""
    @IBOutlet weak var historialTV: UITextView!
    
    
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
        let sqlConsulta = "SELECT HISTORIAL FROM PACIENTES WHERE ID = '\(idPac)'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let historial = String.init(cString: sqlite3_column_text(declaracion, 0))
                DispatchQueue.main.async {
                    self.historialTV.text="\(historial)"}
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
