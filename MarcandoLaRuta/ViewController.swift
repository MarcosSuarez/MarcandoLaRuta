//
//  ViewController.swift
//  MarcandoLaRuta
//
//  Created by Marcos Suarez on 19/9/16.
//  Copyright © 2016 Marcos Suarez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    private var distanciaRecorrida = 0
    private var posAnterior: CLLocation?
    private var esPrimerPunto = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        //manejador.distanceFilter = 10.0
        
        // Se solicita autorización del usuario para obetener su localización.
        manejador.requestWhenInUseAuthorization()
        
        // Centra el mapa en la posición del usuario.
        //mapa.setCenter(mapa.userLocation.coordinate, animated: true)
        
        // Realiza un zoom y seguimiento del usuario
        mapa.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if  mapa.isUserLocationVisible
        {
            if esPrimerPunto {
                agregarPin((manager.location?.coordinate)!)
                posAnterior = manager.location
                esPrimerPunto = false
            } else {
                let distanciaAB = manager.location?.distance(from: posAnterior!)
                // Si se avanza más de 50 mtrs se introduce un pin.
                if Int(distanciaAB!) >= 50 {
                    posAnterior = manager.location
                    distanciaRecorrida += Int(distanciaAB!)
                    agregarPin((manager.location?.coordinate)!)
                }
            }
        }
    }
    
    func agregarPin(_ coordenadas: CLLocationCoordinate2D)
    {
        let pin = MKPointAnnotation()
        pin.title = "Lat: \(coordenadas.latitude)  Long: \(coordenadas.longitude)"
        pin.subtitle = "Total recorrido: \(distanciaRecorrida) mtrs"
        pin.coordinate = coordenadas
        mapa.addAnnotation(pin)
    }
    
    @IBAction func tipoMapa(_ sender: UISegmentedControl)
    {
        print("Botón seleccionado: \(sender.titleForSegment(at: sender.selectedSegmentIndex)!)")
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            mapa.mapType = MKMapType.standard
        case 1:
            mapa.mapType = MKMapType.satellite
        case 2:
            mapa.mapType = MKMapType.hybrid
        default:
            break
        }
    }
}
