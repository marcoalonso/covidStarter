//
//  VistaDetalladaViewController.swift
//  CovidAppcfe
//
//  Created by marco rodriguez on 08/08/22.
//

import UIKit
import MapKit

class VistaDetalladaViewController: UIViewController {
    
    var paisCovid: CountriesStats? //recibir Pais a mostrar
    private var lat: Double?
    private var lon: Double?
    
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    
    var manager = CovidManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegadoHistorial = self

        manager.estadisticasHoy(pais: paisCovid?.Country ?? "")
        
        configureUI()
    }
    
    func setupMap(){
        let anotacion = MKPointAnnotation()
        anotacion.title = "\(paisCovid?.Country ?? "")"
        anotacion.subtitle = "\(paisCovid?.TotalConfirmed ?? 0)"
        anotacion.coordinate = CLLocationCoordinate2D(latitude: lat ?? 19.3453, longitude: lon ?? -101.3455)
        
        //Zooom al mapa
        let span = MKCoordinateSpan(latitudeDelta: 40.0, longitudeDelta: 40.0)
        let region = MKCoordinateRegion(center: anotacion.coordinate, span: span)
        self.mapa.setRegion(region, animated: true)
        self.mapa.addAnnotation(anotacion)
    }
    

    func configureUI(){
        totalDeathsLabel.text = "Muertes: \(paisCovid?.TotalDeaths ?? 0)"
        countryLabel.text = paisCovid?.Country
    }

}

extension VistaDetalladaViewController: historialPaisProtocol{
    func cargarDatos(datos: [PaisDatos]) {
        print(datos[0])
        
        lat = Double(datos[0].Lat)
        lon = Double(datos[0].Lon)
        
        setupMap()
    }
    
    
}
