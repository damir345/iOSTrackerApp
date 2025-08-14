//
//  TrackerDelegateFlowLayout.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 11/08/25.
//

import UIKit

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Layout Delegate Methods
    //
    //  These methods define the visual layout of the collection view (cell size, spacing, headers, etc.).
    //       Calculates width by dividing available space into two columns (with margins and spacing).
    //       Fixed height of 148.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        let cellWidth =  availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    //* Getting the section spacing

    // Asks the delegate for the margins to apply to content in the specified section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    // Asks the delegate for the spacing between successive rows or columns of a section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    //* Getting the header and footer sizes

    // Asks the delegate for the size of the header view in the specified section.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }

}
