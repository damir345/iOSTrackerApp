//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import UIKit

final class TrackersViewController: UIViewController {

    private let emptyView = EmptyTrackersView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupEmptyState()
    }

    private func setupNavigation() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTrackerTapped)
        )
    }

    @objc private func addTrackerTapped() {
        // Пока пусто
        print("Добавить трекер")
    }

    private func setupEmptyState() {
        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
