//
//  CreationTrackerDataSource.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 16/08/25.
//

import UIKit

final class CreationTrackerDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: CreationTrackerViewController?
    
    private let allEmojis: [String]
    private let allColors: [UIColor]
    
    init(viewController: CreationTrackerViewController,
         allEmojis: [String],
         allColors: [UIColor]) {
        self.viewController = viewController
        self.allEmojis = allEmojis
        self.allColors = allColors
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        case 2: return allEmojis.count
        case 3: return allColors.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NameTrackerCell.identifier,
                for: indexPath
            ) as! NameTrackerCell
            cell.delegate = viewController
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ButtonsCell.identifier,
                for: indexPath
            ) as! ButtonsCell
            viewController?.configureUIDelegate?.configureButtonsCell(cell: cell)
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.identifier,
                for: indexPath
            ) as! EmojiCell
            cell.label.text = allEmojis[indexPath.row]
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.identifier,
                for: indexPath
            ) as! ColorCell
            cell.colorView.backgroundColor = allColors[indexPath.row]
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderCollectionReusableView.identifier,
            for: indexPath
        ) as! HeaderCollectionReusableView
        
        if indexPath.section == 2 {
            header.headerLabel.text = "Emoji"
        } else if indexPath.section == 3 {
            header.headerLabel.text = "Цвет"
        }
        
        return header
    }
}

