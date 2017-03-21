//
//  CitasDoc.swift
//  ProyectoAM
//
//  Created by Luis Espinosa on 3/20/17.
//  Copyright © 2017 Fernando Medellin Cuevas. All rights reserved.
//

import UIKit

class CitasDoc: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var baseDatos: OpaquePointer? = nil
    var fechas = [String] ()
    var nombres = [String] ()
    var ids = [String] ()
    var idDoctor = "D01375758"
    
    @IBOutlet weak var tabla: UITableView!
    
    var selectIDS: String = ""
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        selectIDS = "\(ids[indexPath.row])"
        print(selectIDS)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPacientes", for: indexPath)
        celda.textLabel?.text = fechas[indexPath.row]
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
    
    func obtenerPath(_ salida: String) -> URL? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func consultarBaseDatos() {
        let sqlConsulta = "SELECT CITAS.PACIENTEID, CITAS.FECHA, PACIENTES.NOMBRE FROM CITAS, DOCTORES, PACIENTES WHERE DOCTORES.NOMINA==CITAS.DOCTORID AND PACIENTES.ID==CITAS.PACIENTEID AND DOCTORES.NOMINA == '\(idDoctor)'"
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(baseDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            while sqlite3_step(declaracion) == SQLITE_ROW {
                let id = String.init(cString: sqlite3_column_text(declaracion, 0))
                let fecha = String.init(cString: sqlite3_column_text(declaracion, 1))
                let nombre = String.init(cString: sqlite3_column_text(declaracion, 2))
                print("\(id), \(fecha), \(nombre)")
                ids.append(id)
                fechas.append(fecha)
                nombres.append(nombre)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pasar el pais el segundo controlador
        let segundoVC = segue.destination as! ContactoPac
        segundoVC.idPac = selectIDS
    }
    
    //MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ids.removeAll()
        nombres.removeAll()
        fechas.removeAll()
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
