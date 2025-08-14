//
//  NewHabitCreationViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 1/08/25.
//

import UIKit

final class NewHabitCreationViewController: CreationTrackerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIDelegate = self
        configureUIDelegate?.setUpBackground()
    }
    
    //MARK: - Private Methods
    private func convertSelectedDaysToString() -> String {
        var scheduleSubText = String()
        
        let weekSet = Set(WeekDays.allCases)
        if selectedWeekDays == weekSet {
            scheduleSubText = "Каждый день"
        } else if !selectedWeekDays.isEmpty {
            selectedWeekDays.sorted { $0.rawValue < $1.rawValue }.forEach { day in
                scheduleSubText += day.shortName + ", "
            }
            scheduleSubText = String(scheduleSubText.dropLast(2))
        } else {
            return ""
        }

        return scheduleSubText
    }
    
    @objc
    override func saveButtonPressed() {
        guard let name = trackerName, !selectedWeekDays.isEmpty else { return }
        let tracker = Tracker(
            name: name,
            color: .color1,
            emoji: "🙂",
            schedule: selectedWeekDays,
            state: .Habit
        )
        
        creationDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        dismiss(animated: true)
    }
}

//MARK: - ShowScheduleDelegate
extension NewHabitCreationViewController: ShowScheduleDelegate {
    func showScheduleViewController(viewController: ScheduleViewController) {
        viewController.scheduleDelegate = self
        viewController.selectedDays = selectedWeekDays
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - ScheduleProtocol
extension NewHabitCreationViewController: ScheduleProtocol {
    func saveSelectedDays(selectedDays: Set<WeekDays>) {
        selectedWeekDays = selectedDays
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonsCell  {
            cell.updateSubTitle(
                forCellAt: IndexPath(row: 1, section: 0),
                text: convertSelectedDaysToString())
        }
    }
}

//MARK: - ConfigureUIForTrackerCreationProtocol
extension NewHabitCreationViewController: ConfigureUIForTrackerCreationProtocol {
    func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.scheduleDelegate = self
        cell.state = .Habit
    }
    
    func setUpBackground() {
        self.title = "Новая привычка"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    func calculateTableViewHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 150)
    }
    
    func checkIfSaveButtonCanBePressed() {
        if trackerName != nil,
           trackerCategory != nil,
           !selectedWeekDays.isEmpty
        {
            saveButtonCanBePressed = true
        } else {
            saveButtonCanBePressed = false
        }
    }
}
