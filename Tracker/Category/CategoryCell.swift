//
//  CategoryCell.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import UIKit

final class CategoryCell: UITableViewCell {
    var label = UILabel()
    var viewModel: CategoryViewModel? {
        didSet {
            viewModel?.titleBinding = { [weak self] title in
                self?.label.text = title
            }
        }
    }
    
    static let identifier = "CategoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layer.maskedCorners = []
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        contentView.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
