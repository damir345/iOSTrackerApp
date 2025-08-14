//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 10/08/25.
//

import UIKit

// MARK: - Protocol for Button Behavior
protocol PrimaryButtonBehavior {
    func applyStyling(title: String)
    func setupConstraints(
        parentView: UIView,
        withHeight height: CGFloat,
        leadingConstant: CGFloat,
        trailingConstant: CGFloat,
        bottomAnchorConstant: CGFloat,
        buttonToAnchor: UIButton
    )
}

// MARK: - Extension for UIButton
extension UIButton: PrimaryButtonBehavior {
    func applyStyling(title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.ypBlack
        self.layer.cornerRadius = 16
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints(
        parentView: UIView,
        withHeight height: CGFloat,
        leadingConstant: CGFloat,
        trailingConstant: CGFloat,
        bottomAnchorConstant: CGFloat,
        buttonToAnchor: UIButton
    ) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            self.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant),
            self.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant),
                bottomAnchorConstant == -1
                    ? self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
                    : self.topAnchor.constraint(equalTo: buttonToAnchor.bottomAnchor, constant: bottomAnchorConstant)
        ])
    }
}

class NewTrackerViewController: UIViewController {
    
    weak var delegate: TrackerCreationDelegate?
    
    private var createNewHabitButton = UIButton()
    private var createNewEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание трекера"
        view.backgroundColor = .white

        // Create Buttons
        defineNewHabitButton()
        defineNewEventButton()
    }
    
    private func defineNewHabitButton() {
        view.addSubview(createNewHabitButton)
        createNewHabitButton.applyStyling(title: "Привычка")
        createNewHabitButton.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        
        createNewHabitButton.setupConstraints(
            parentView: view,
            withHeight: 60,
            leadingConstant: 20,
            trailingConstant: -20,
            bottomAnchorConstant: -1,
            buttonToAnchor: UIButton()
            )
    }
    
    private func defineNewEventButton() {
        view.addSubview(createNewEventButton)
        createNewEventButton.applyStyling(title: "Нерегулярное событие")
        createNewEventButton.addTarget(self, action: #selector(eventButtonPressed), for: .touchUpInside)
        createNewEventButton.setupConstraints(
            parentView: view,
            withHeight: 60,
            leadingConstant: 20,
            trailingConstant: -20,
            bottomAnchorConstant: 16,
            buttonToAnchor: createNewHabitButton
        )
    }
    
    @objc
    private func habitButtonPressed() {
        let vc = NewHabitCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func eventButtonPressed() {
        let vc = NewEventCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

