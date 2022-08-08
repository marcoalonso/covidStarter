//
//  ViewController.swift
//  CovidAppcfe
//
//  Created by marco rodriguez on 08/08/22.
//

import UIKit

class EstadisticasViewController: UIViewController {

    @IBOutlet weak var totalConfirmados: UILabel!
    @IBOutlet weak var totalMuertes: UILabel!
    
    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var searchPaise: UISearchBar!
    @IBOutlet weak var tablaPaises: UITableView!
    
    // MARK: - Variables
    var listaPaises: [CountriesStats] = []
    
    var paisVisualizar: CountriesStats?
    
    var manager = CovidManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaPaises.delegate = self
        tablaPaises.dataSource = self
        
        manager.delegado = self
        
        
        manager.buscarEstadisticas()
        
    }
}

extension EstadisticasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPaises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaPaises.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = listaPaises[indexPath.row].Country
        celda.detailTextLabel?.text = "Total de casos \(listaPaises[indexPath.row].TotalConfirmed)"
        return celda
    }
    
    //Identificar cuando selecciono un elemento de la Tabla
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Guardar el elemento seleccionado
        paisVisualizar = listaPaises[indexPath.row]
        //Navegar
        performSegue(withIdentifier: "paisCovid", sender: self)
    }
    
    //Enviar informacion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paisCovid"{
            let verPais = segue.destination as! VistaDetalladaViewController
            verPais.paisCovid = paisVisualizar
        }
    }
}

extension EstadisticasViewController: covidManagerProtocol {
    func cargarDatos(datos: CovidDatos) {
        print(datos)
        
        //Cuando queremos actualizar "algo" de la Interfaz Grafica desde un proceso o tarea que se ejecuta en background se debe elegir el hilo principal del proceso
        DispatchQueue.main.async {
            self.totalConfirmados.text = "Total confirmados: \(datos.Global.TotalConfirmed)"
            self.totalMuertes.text = "Muertes totales: \(datos.Global.TotalDeaths)"
            self.fechaLabel.text = datos.Global.Date
            
            //tableView
            self.listaPaises = datos.Countries
            self.tablaPaises.reloadData()
        }
        
        
    }
    
    func huboError(cualError: Error) {
        print(cualError)
    }
}
