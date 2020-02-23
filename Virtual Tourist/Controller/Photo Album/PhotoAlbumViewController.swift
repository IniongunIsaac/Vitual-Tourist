//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 22/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import Kingfisher

class PhotoAlbumViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    
    var pin: Pin!
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    
    var photoResponse: PhotosResponse? = nil
    let photoAlbumCollectionViewCellIdentifier = "photoAlbumCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        
        setupFetchedResultsController()
        
        setupPhotoAlbumCollectionView()
        
        initPinPhotos()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fetchedResultsController = nil
    }
    
    fileprivate func setupMapView() {
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKPinAnnotationView.self))
        let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.objectID)-photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Unable to fetch persisted pin photos.\nReason: \(error.localizedDescription)")
        }
    }
    
    fileprivate func setupPhotoAlbumCollectionView() {
        photoAlbumCollectionView.dataSource = self
        photoAlbumCollectionView.delegate = self
    }
    
    fileprivate func initPinPhotos() {
        if pin.photos?.count == 0 {
            photoAlbumCollectionView.setNoValuesFoundBackgroundMessage(AppConstants.NO_SAVED_IMAGES_FOR_LOCATION)
            fetchImages()
        } else {
            photoAlbumCollectionView.removeBackgroundView()
        }
    }
    
    fileprivate func fetchImages(page: Int = 1) {
        showLoading(loadingMessage: "Fetching Pin images, please wait...")
        NetworkApiClient.fetchImages(latitude: pin.latitude, longitude: pin.longitude, page: page, completionHandler: photoResponseCompletionHandler(photoResponse:error:))
    }
    
    fileprivate func photoResponseCompletionHandler(photoResponse: PhotosResponse?, error: Error?) {
        hideLoading()
        if let error = error {
            photoAlbumCollectionView.setNoValuesFoundBackgroundMessage(AppConstants.IMAGES_NOT_FOUND_FOR_LOCATION)
            showAlert(with: "An error occurred, images couldn't be fetched.\nReason:\(error.localizedDescription)", alertType: .failure)
        }
        
        guard let photoResponse = photoResponse else { return }
        
        self.photoResponse = photoResponse
        
        if photoResponse.photos.photo.count == 0 {
            photoAlbumCollectionView.setNoValuesFoundBackgroundMessage(AppConstants.IMAGES_NOT_FOUND_FOR_LOCATION)
        } else {
            photoAlbumCollectionView.removeBackgroundView()
            for photo in photoResponse.photos.photo {
                savePhoto(url: photo.url)
            }
        }
    }
    
    fileprivate func savePhoto(url: String) {
        let photo = Photo(context: dataController.viewContext)
        photo.url = url
        photo.pin = pin
        try? dataController.viewContext.save()
    }
    
    func fetchPhotoData(photo: Photo) {
        NetworkApiClient.downloadPinImage(url: URL(string: photo.url!)!) { data, error in
            guard let data = data else { return }
            photo.image = data
            try? self.dataController.viewContext.save()
        }
    }
    
    fileprivate func photoDataCompletionHandler(data: Data?, error: Error?) {
        guard let data = data else { return }
        let photo = Photo(context: dataController.viewContext)
        photo.image = data
        try? dataController.viewContext.save()
    }
    
    @IBAction func newCollectionButtonTapped(_ sender: UIButton) {
        
        if let pinPhotoCount = pin.photos?.count, pinPhotoCount > 0 {
            removePinPhotosFromPersistentStorage()
        }
        
        if let pages = photoResponse?.photos.pages, pages > 0 {
            fetchImages(page: Int.random(in: 1...10))
        } else {
            fetchImages()
        }
        
    }
    
    fileprivate func removePinPhotosFromPersistentStorage() {
        guard let photos = pin.photos else { return }
        for photo in photos {
            dataController.viewContext.delete(photo as! NSManagedObject)
            try? dataController.viewContext.save()
        }
        photoAlbumCollectionView.reloadData()
    }
    
}
