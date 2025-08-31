//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import UIKit

final class CategoryCreationViewController: UIViewController {
    var saveButtonCanBePressed: Bool? {
        didSet {
            let isEnabled = saveButtonCanBePressed == true
            saveButton.backgroundColor = isEnabled ? .black : .lightGray
            saveButton.isEnabled = isEnabled
        }
    }
    
    private let saveButton = UIButton()
    private let categoryNameTextField = UITextField()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Новая категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        setUpSaveButton()
        setUpTextField()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    @objc
    private func saveButtonTapped() {
        guard let text = categoryNameTextField.text else {return}
        createNewCategory(categoryName: text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = categoryNameTextField.text else { return }
        saveButtonCanBePressed = text != ""
    }
    
    //MARK: - Private methods
    private func createNewCategory(categoryName: String) {
        do {
            try trackerCategoryStore.addNewCategory(name: categoryName)
        } catch {
            print("Ошибка при добавлении категории: \(error)")
        }
    }

    
    private func setUpSaveButton() {
        view.addSubview(saveButton)
        
        saveButton.setTitle("Готово", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        saveButton.titleLabel?.textColor = .white
        saveButton.backgroundColor = UIColor.ypGray
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setUpTextField() {
        view.addSubview(categoryNameTextField)
        categoryNameTextField.layer.cornerRadius = 16
        categoryNameTextField.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        categoryNameTextField.placeholder = "Введите название категории"
        categoryNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        categoryNameTextField.setLeftPaddingPoints(12)
        
        categoryNameTextField.clearButtonMode = .whileEditing
        
        categoryNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
