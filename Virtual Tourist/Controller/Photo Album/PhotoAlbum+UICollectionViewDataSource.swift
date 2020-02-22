//
//  PhotoAlbum+UICollectionViewDataSource.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 22/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0 //photoResponse?.photos.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAlbumCollectionViewCellIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        
        let photo = fetchedResultsController.object(at: indexPath)
        if let photoData = photo.image {
            cell.photoImageView.image = UIImage(data: photoData)
        } else {
            fetchPhotoData(photo: photo)
        }
        
        return cell
    }
    
    
}
