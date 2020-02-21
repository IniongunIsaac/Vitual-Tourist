//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 20/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    }

    fileprivate func setupMap() {
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPinAnnotationView.self))
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTapped(_:)))
        mapTapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }
    
    @objc func handleMapTapped(_ gestureReconizer: UILongPressGestureRecognizer){
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
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
        showAlert(with: "\(view.annotation?.coordinate)", alertType: .success) { }
    }
    
}
