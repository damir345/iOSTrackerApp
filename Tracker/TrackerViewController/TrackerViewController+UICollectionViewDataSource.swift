//
//  TrackerDataSource.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 11/08/25.
//

import UIKit

extension TrackerViewController: UICollectionViewDataSource {
    // MARK: - Data Source
    // Getting number of categories
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (model.currentCategories.count == 0) {
            showPlaceHolder(collectionView)
        } else {
            collectionView.backgroundView = nil
        }
        return model.currentCategories.count
    }

    // Specifies how many items (trackers) are in each section (category).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.currentCategories[section].trackers.count
    } // Getting item and section metrics

    // Getting views for items
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        
        cell.counterDelegate = model

        let tracker = model.currentCategories[indexPath.section].trackers[indexPath.row]
        cell.trackerInfo = TrackerInfoCell(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            daysCount: model.calculateTimesTrackerWasCompleted(trackerId: tracker.id),
            currentDay: model.currentDate,
            state: tracker.state)
        
        return cell
    }
    
    //  Provides supplementary views (like headers or footers) for sections in a UICollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // If the kind is UICollectionView.elementKindSectionHeader then
             // dequeue, create and configure the header
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath) as? HeaderCollectionReusableView {
                
                // Set the header title
                sectionHeader.headerLabel.text = model.categories[indexPath.section].title
                return sectionHeader
            }
        }
        // Default case (e.g., footer or invalid kind)
        return UICollectionReusableView()
    }

    // private functions
    private func showPlaceHolder(_ collectionView: UICollectionView) {
        let backgroundView = PlaceHolderView(frame: collectionView.frame)
        backgroundView.setUpNoTrackersState()
        collectionView.backgroundView = backgroundView
    }
}

