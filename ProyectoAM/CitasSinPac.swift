//
//  CitasSinPac.swift
//  ProyectoAM
//
//  Created by Allan Iván Ramírez Alanís on 03/05/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class CitasSinPac: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var baseDatos: OpaquePointer? = nil
    var fechas = [String] ()
    var especialidades = [String] ()
    var nominas = [String] ()
    var doctor = ""
    var tel = ""
    @IBOutlet weak var tabla: UITableView!
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        consultarDoc(nominas[indexPath.row])
        let alertaMal = UIAlertController(title: "Cita aun no aceptada", message: "Contacto: Dr. \(doctor) - \(tel)", preferredStyle: .alert)
        let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
        alertaMal.addAction(btnAceptar)
        present(alertaMal, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nominas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "noCitaP", for: indexPath)
        celda.textLabel?.text = fechas[indexPath.row]
        //Subtitulos (detalles)
        celda.detailTextLabel?.text = especialidades[indexPath.row]
        return celda
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            borrarRegistro(indexPath.row)
            fechas.remove(at: indexPath.row)
            especialidades.remove(at: indexPath.row)
            nominas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func borrarRegistro(_ row: Int) {
        let query = "DELETE FROM CITAS WHERE DOCTORID = '\(nominas[row])' AND PACIENTEID = '\(appDelegate.idPaciente)' AND FECHA = '\(fechas[row])'"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, query, nil, nil, &error) == SQLITE_OK {
            print("Registro borrado")
        } else {
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
        }
    }
    
    func consultarDoc(_ nomina:String) {
        let sqlConsulta = "SELECT NOMBRE, TELEFONO FROM DOCTORES WHERE NOMINA = '\(nomina)'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 0))
                let telefono = String.init(cString: sqlite3_column_text(declaracion, 1))
                doctor = nombre
                tel = telefono
                
            }
        }
    }
    
    func consultarBaseDatos() {
        let sqlConsulta = "SELECT CITAS.DOCTORID, CITAS.FECHA, DOCTORES.ESPECIALIDAD FROM CITAS, DOCTORES, PACIENTES WHERE DOCTORES.NOMINA==CITAS.DOCTORID AND PACIENTES.ID==CITAS.PACIENTEID AND PACIENTES.ID == '\(appDelegate.idPaciente)' AND BANDERA=='0'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let nomina = String.init(cString: sqlite3_column_text(declaracion, 0))
                let fecha = String.init(cString: sqlite3_column_text(declaracion, 1))
                let especialidad = String.init(cString: sqlite3_column_text(declaracion, 2))
                print("\(nomina), \(fecha), \(especialidad)")
                especialidades.append(especialidad)
                fechas.append(fecha)
                nominas.append(nomina)
            }
        }
    }
    
    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nominas.removeAll()
        especialidades.removeAll()
        fechas.removeAll()
        print(appDelegate.idPaciente)
        if abrirBaseDatos(){
            print("ok")
            consultarBaseDatos()
            sqlite3_close(baseDatos)
            tabla.reloadData()
        } else{
            print("Error al abrir BD")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

