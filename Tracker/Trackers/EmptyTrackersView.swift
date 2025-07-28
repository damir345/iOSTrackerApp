//
//  EmptyTrackersView.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import UIKit

final class EmptyTrackersView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока ничего нет"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
