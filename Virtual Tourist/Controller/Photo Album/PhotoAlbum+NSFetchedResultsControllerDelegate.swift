//
//  PhotoAlbum+NSFetchedResultsControllerDelegate.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 22/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            photoAlbumCollectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            photoAlbumCollectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            photoAlbumCollectionView.reloadItems(at: [indexPath!])
        case .move:
            photoAlbumCollectionView.moveItem(at: indexPath!, to: newIndexPath!)
        @unknown default:
            print("Unknown operation.")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: photoAlbumCollectionView.insertSections(indexSet)
        case .delete: photoAlbumCollectionView.deleteSections(indexSet)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            print("Unknown operation.")
        }
    }
    
}
