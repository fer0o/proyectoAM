//
//  CitasSinD.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 03/05/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class CitasSinD: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var baseDatos: OpaquePointer? = nil
    var fechas = [String] ()
    var nombres = [String] ()
    var ids = [String] ()
    @IBOutlet weak var tabla: UITableView!
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        updateCita(indexPath.row)
        fechas.remove(at: indexPath.row)
        nombres.remove(at: indexPath.row)
        ids.remove(at: indexPath.row)
        tabla.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "citasNoD", for: indexPath)
        celda.textLabel?.text = fechas[indexPath.row]
        //Subtitulos (detalles)
        celda.detailTextLabel?.text = nombres[indexPath.row]
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
            ids.remove(at: indexPath.row)
            nombres.remove(at: indexPath.row)
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
        let query = "DELETE FROM CITAS WHERE DOCTORID = '\(appDelegate.idDoctor)' AND PACIENTEID = '\(ids[row])' AND FECHA = '\(fechas[row])'"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, query, nil, nil, &error) == SQLITE_OK {
            let alertaCorrecto = UIAlertController(title: "Cancelado", message: "La cita a sido cancelada, se avisara al paciente", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaCorrecto.addAction(btnAceptar)
            present(alertaCorrecto, animated: true, completion: nil)
            print("Registro borrado")
        } else {
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
        }
    }
    
    func consultarBaseDatos() {
        let sqlConsulta = "SELECT CITAS.PACIENTEID, CITAS.FECHA, PACIENTES.NOMBRE FROM CITAS, DOCTORES, PACIENTES WHERE DOCTORES.NOMINA==CITAS.DOCTORID AND PACIENTES.ID==CITAS.PACIENTEID AND DOCTORES.NOMINA == '\(appDelegate.idDoctor)' AND CITAS.BANDERA=='0'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let id = String.init(cString: sqlite3_column_text(declaracion, 0))
                let fecha = String.init(cString: sqlite3_column_text(declaracion, 1))
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 2))
                print("\(id), \(fecha), \(nombre)")
                print("holas")
                ids.append(id)
                fechas.append(fecha)
                nombres.append(nombre)
            }
        } else{
            print("nel")
        }
    }
    
    func updateCita(_ row: Int){
        let update = "UPDATE CITAS SET BANDERA = '1' WHERE PACIENTEID='\(ids[row])' AND DOCTORID='\(appDelegate.idDoctor)' AND FECHA='\(fechas[row])'"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(baseDatos, update, nil, nil, &error) == SQLITE_OK {
            
            print("Updated")
            let alertaCorrecto = UIAlertController(title: "Aceptado", message: "La cita ha sido confirmada", preferredStyle: .alert)
            let btnAceptar = UIAlertAction(title:"Aceptar", style: .default, handler: nil)
            alertaCorrecto.addAction(btnAceptar)
            present(alertaCorrecto, animated: true, completion: nil)
        } else{
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            print("No updated")
        }
    }
    
    
    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ids.removeAll()
        nombres.removeAll()
        fechas.removeAll()
        print("\(appDelegate.idDoctor)")
        if abrirBaseDatos(){
            print("ok")
            consultarBaseDatos()
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
