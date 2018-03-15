//
//  ThreadProfileVC+ext+CoreData.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 28/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation
import CoreData

extension ThreadProfileVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if controller == frcForInstanceBody {
            
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
                break
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
                break
            case .move: break
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            }
        }else if controller == frcForInstanceMedia {
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath, let indexPath = indexPath {
                    if self.collectionView.numberOfItems(inSection: indexPath.section) == 0 {
                       self.shouldReloadCollectionView = true
                    }else {
                        let block = BlockOperation(block: {
                            DispatchQueue.main.async {
                                self.collectionView.insertItems(at: [newIndexPath])
                            }
                        })
                        blockOperations.append(block)
                    }
                }else {
                    self.shouldReloadCollectionView = true
                }
                break
            case .update:
                
                if let indexPath = indexPath {
                    let block = BlockOperation(block: {
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    })
                    blockOperations.append(block)
                }
                break
            case .move: break
            case .delete:
                if let indexPath = indexPath {
                    
                    if self.collectionView.numberOfItems(inSection: indexPath.section) == 1 {
                        self.shouldReloadCollectionView = true
                    }else {
                        let block = BlockOperation(block: {
                            DispatchQueue.main.async {
                                self.collectionView.deleteItems(at: [indexPath])
                            }
                        })
                        blockOperations.append(block)
                    }
                }
                break
            }
        }
       
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        
        if controller == frcForInstanceBody {
            switch type {
            case .insert:
                tableView.insertSections([sectionIndex], with: .fade)
                break
            case .delete:
                tableView.deleteSections([sectionIndex], with: .fade)
                break
            default: break
            }
        }else if controller == frcForInstanceMedia {
            switch type {
            case .insert:
                let block = BlockOperation(block: {
                    DispatchQueue.main.async {
                        self.collectionView.insertSections([sectionIndex])
                    }
                })
                blockOperations.append(block)
                break
            case .delete:
                let block = BlockOperation(block: {
                    DispatchQueue.main.async {
                        self.collectionView.deleteSections([sectionIndex])
                    }
                })
                blockOperations.append(block)
                break
            default: break
            }
        }
        
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == frcForInstanceBody {
            tableView.beginUpdates()
        }else if controller == frcForInstanceMedia {
           
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == frcForInstanceBody {
            tableView.endUpdates()
        }else if controller == frcForInstanceMedia {
            if shouldReloadCollectionView {
                self.collectionView.reloadData()
            }else {
                collectionView.performBatchUpdates({
                    
                    for operation in blockOperations {
                        operation.cancel()
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }, completion: { (completed) in
                    
                })
            }
          
        }
    }
}
