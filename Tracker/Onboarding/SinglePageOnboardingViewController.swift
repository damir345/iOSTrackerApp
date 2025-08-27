//
//  SinglePageOnboardingViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import Foundation

import UIKit

final class SinglePageOnboardingViewController: UIViewController {
    
    private var text: String?
    private var imageTitle: String?
    
    private var image = UIImageView()
    private var textLabel = UILabel()
    
    init(text: String, imageTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.text = text
        self.imageTitle = imageTitle
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpBackground()
        setUpTextLabel()
    }
    
    private func setUpBackground() {
        guard let imageTitle = imageTitle else {return}
        
        image.image = UIImage(named: imageTitle)
        view.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpTextLabel() {
        guard let text = text else {return}
        
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        view.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
