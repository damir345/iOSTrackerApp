//
//  CreationTrackerDelegate.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 16/08/25.
//

import UIKit

final class CreationTrackerDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    weak var viewController: CreationTrackerViewController?
    
    init(viewController: CreationTrackerViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 16 * 2
        switch indexPath.section {
        case 0:
            return CGSize(width: cellWidth, height: 75)
            
        case 1:
            return viewController?.configureUIDelegate?.calculateTableViewHeight(width: cellWidth)
            ?? CGSize(width: cellWidth, height: 150)
            
        case 2, 3: // эмодзи и цвета
            let itemsPerRow: CGFloat = 6
            let spacing: CGFloat = 8
            let insets = self.collectionView(collectionView,
                                             layout: collectionViewLayout,
                                             insetForSectionAt: indexPath.section)
            let totalSpacing = insets.left + insets.right + (itemsPerRow - 1) * spacing
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = floor(availableWidth / itemsPerRow)
            return CGSize(width: itemWidth, height: itemWidth)
            
        default:
            return CGSize(width: cellWidth, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 1:
            return UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16)
        case 2, 3:
            return UIEdgeInsets(top: 24, left: 16, bottom: 40, right: 16)
        default:
            return UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 2 || section == 3 ? 8 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 2 || section == 3 ? 12 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 2, 3:
            return CGSize(width: collectionView.bounds.width, height: 18)
        default:
            return .zero
        }
    }
    
    // MARK: - Selection
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            viewController?.selectedEmoji = nil
        } else if indexPath.section == 3 {
            viewController?.selectedColor = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell,
               let emoji = cell.label.text {
                viewController?.selectedEmoji = emoji
            }
        } else if indexPath.section == 3 {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell,
               let color = cell.colorView.backgroundColor {
                viewController?.selectedColor = color
            }
        }
    }
}

