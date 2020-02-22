//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 20/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        fetchPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.selectedAnnotations.forEach { annotation in
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let mapViewCenterCoord = mapView.centerCoordinate
        UserDefaults.standard.set(mapViewCenterCoord.latitude, forKey: AppConstants.LATITUDE_KEY)
        UserDefaults.standard.set(mapViewCenterCoord.longitude, forKey: AppConstants.LONGITUDE_KEY)
    }
    
    fileprivate func fetchPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            pins = try dataController.viewContext.fetch(fetchRequest)
            addPinsToMap()
        } catch {
            print("Error fetching saved pins: \(error.localizedDescription)")
        }
    }
    
    fileprivate func addPinsToMap() {
        for pin in pins {
            addPinToMap(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
        }
    }

    fileprivate func setupMap() {
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPinAnnotationView.self))
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTapped(_:)))
        mapTapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
        
        setMapCenterFromPreviousUsage()
        
    }
    
    fileprivate func setMapCenterFromPreviousUsage() {
        if let lat = UserDefaults.standard.value(forKey: AppConstants.LATITUDE_KEY), let long = UserDefaults.standard.value(forKey: AppConstants.LONGITUDE_KEY) {
            let centerCoordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
            let span = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc func handleMapTapped(_ gestureReconizer: UILongPressGestureRecognizer){
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        addPinToMap(coordinate: coordinate)
        savePin(lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    fileprivate func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    fileprivate func savePin(lat: Double, long: Double) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = lat
        pin.longitude = long
        pins.append(pin)
        try? dataController.viewContext.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

}

//MARK: - UIGestureRecognizerDelegate Methods

extension TravelLocationsMapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is MKPinAnnotationView)
    }
}

//MARK: - MKMapViewDelegate Methods

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        runAfter {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "photoAblumViewController") as! PhotoAlbumViewController
            vc.pin = self.pins.first { $0.latitude == view.annotation?.coordinate.latitude && $0.longitude == view.annotation?.coordinate.longitude }
            vc.dataController = self.dataController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
