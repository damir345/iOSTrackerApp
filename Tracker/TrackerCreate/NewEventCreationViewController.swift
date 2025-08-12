//
//  NewEventCreationViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 1/08/25.
//

import Foundation
import UIKit

final class NewEventCreationViewController: CreationTrackerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIDelegate = self
        configureUIDelegate?.setUpBackground()
    }
    
    @objc
    override func saveButtonPressed() {
        guard let name = trackerName else { return }
        let weekSet = Set(WeekDays.allCases)
        let tracker = Tracker(
            name: name,
            color: .color1,       // фиксированный цвет
            emoji: "🙂",          // фиксированный эмодзи
            schedule: weekSet,
            state: .Event)
        
        creationDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        dismiss(animated: true)
    }
}

//MARK: - ConfigureUIForTrackerCreationProtocol
extension NewEventCreationViewController: ConfigureUIForTrackerCreationProtocol {
    func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.state = .Event
    }
    
    func setUpBackground() {
        self.title = "Новое нерегулярное событие"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    func calculateTableViewHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 75)
    }
    
    func checkIfSaveButtonCanBePressed() {
        if trackerName != nil && trackerCategory != nil {
            saveButtonCanBePressed = true
        } else {
            saveButtonCanBePressed = false
        }
    }
}
