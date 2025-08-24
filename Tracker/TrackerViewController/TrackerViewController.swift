//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 11/08/25.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    let model = TrackerModel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private var label = UILabel()
    private var navigationBar: UINavigationBar?
    private let datePicker = UIDatePicker()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initCollection()
        setUpNavigationBar()
    }

    //MARK: - Collection Initialization
    private func initCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Setting Up Navigation Bar
    private func setUpNavigationBar() {
        navigationBar = navigationController?.navigationBar
        
        let addButton = UIBarButtonItem(image:  UIImage(named: "addButton") ?? UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addHabit))
        addButton.tintColor = .ypBlack
        navigationBar?.topItem?.leftBarButtonItem = addButton
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationBar?.topItem?.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationBar?.prefersLargeTitles = true
        navigationBar?.topItem?.title = "Трекеры"

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
       

    // MARK: - Private Functions
    private func updateModelAndReloadCollectionViewData() {
        model.updateCollectionAccordingToDate()
        collectionView.reloadData()
    }
    
    //MARK: - Actions
    @objc
    private func addHabit() {
        let createTrackerViewController = NewTrackerViewController()
        createTrackerViewController.delegate = self
        let ncCreateTracker = UINavigationController(rootViewController: createTrackerViewController)
        navigationController?.present(ncCreateTracker, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        model.currentDate = selectedDate
        updateModelAndReloadCollectionViewData()
    }
}


//MARK: - SearchController
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text != "" {
            model.updateCollectionAccordingToSearchBarResults(enteredName: text)
            collectionView.reloadData()
        }
    }
}

//MARK: SearchBarController
extension TrackerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        updateModelAndReloadCollectionViewData()
    }
}

// MARK: - TrackerCreationDelegate
extension TrackerViewController: TrackerCreationDelegate {
    func createTracker(tracker: Tracker, category: String) {
         model.createTracker(tracker: tracker, category: category);
         //TODO?: updateModelAndReloadCollectionViewData() instead of teh following code line?
         collectionView.reloadData()
    }
}
