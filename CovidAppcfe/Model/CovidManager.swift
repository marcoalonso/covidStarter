//
//  CovidManager.swift
//  CovidAppcfe
//
//  Created by marco rodriguez on 08/08/22.
//

import Foundation

protocol covidManagerProtocol {
    func cargarDatos(datos: CovidDatos)
    func huboError(cualError: Error)
}

protocol historialPaisProtocol {
    func cargarDatos(datos: [PaisDatos])
}

struct CovidManager {
    var delegado: covidManagerProtocol?
    
    var delegadoHistorial: historialPaisProtocol?
    
    
    //consultar otra API
    func estadisticasHoy(pais: String){
        let urlString = "https://api.covid19api.com/dayone/country/\(pais)/status/confirmed"
        
        if let url = URL(string: urlString){
            let sesion = URLSession(configuration: .default)
            
            let tarea = sesion.dataTask(with: url) { datos, respuesta, error in
                //Si hubo un error
                if error != nil {
                    print("Error en la tarea: \(error!.localizedDescription)")
                    //delegado?.huboError(cualError: error!)
                }
                //Si no hubo error
                if let datosSeguros = datos {
        
                    if let estadisticasUI =  self.parsearJSONPais(data: datosSeguros) {
                        //por medio del delegado mandar la dataUI
                        delegadoHistorial?.cargarDatos(datos: estadisticasUI)
                    }
                    
                }//if let
            }
            tarea.resume()
        }
    }
    
    func parsearJSONPais(data: Data) -> [PaisDatos]? {
        //print("parsearJSON")
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados: [PaisDatos]  = try decodificador.decode([PaisDatos].self, from: data)
            
            print("Decodificacion Exitosa")
//            print(datosDecodificados)
            //retorna el array de todo el historial de ese pais
            return datosDecodificados
            
        }catch {
            print("Error al decodificar: \(error.localizedDescription)")
            //delegado?.huboError(cualError: error)
            return nil
        }
    }
    
    
    func buscarEstadisticas() {
        let urlString = "https://api.covid19api.com/summary"
        
        if let url = URL(string: urlString) {
            let sesion = URLSession(configuration: .default)
            
            let tarea = sesion.dataTask(with: url) { datos, respuesta, error in
                if error != nil {
                    print("Error en la tarea: ",error!.localizedDescription)
                    delegado?.huboError(cualError: error!)
                }
                if let datosSeguros = datos {
                    if let estadisticasUI = self.parsearJSON(data: datosSeguros){
                        delegado?.cargarDatos(datos: estadisticasUI)
                    }
                }
            }
            tarea.resume()
        }
    }
    
    func parsearJSON(data: Data) -> CovidDatos? {
        let decodificador = JSONDecoder()
        do{
            let datosDecodificados = try decodificador.decode(CovidDatos.self, from: data)
            return datosDecodificados
        }catch {
            print("Error al decodificar :" ,error.localizedDescription)
            delegado?.huboError(cualError: error)
            return nil
        }
    }

}
