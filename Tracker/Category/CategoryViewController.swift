//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import UIKit

final class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var categoriesViewModel = CategoriesViewModel()
    
    private let tableView = UITableView()
    private let createCategoryButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        setUpButton()
        initTableView()
        
        categoriesViewModel.categoriesBinding = { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadData()
        }
    }
    
    @objc
    private func createCategoryButtonTapped() {
        navigationController?.pushViewController(CategoryCreationViewController(), animated: true)
    }
    
    private func setUpButton() {
        createCategoryButton.setTitle("Добавить категорию", for: .normal)
        createCategoryButton.backgroundColor = .ypBlack
        createCategoryButton.layer.cornerRadius = 16
        
        view.addSubview(createCategoryButton)
        createCategoryButton.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        
        view.addSubview(createCategoryButton)
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func initTableView() {
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 16
        view.addSubview(tableView)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -16)
        ])
    }
    
    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: tableView.frame)
        backgroundView.setUpNoCategories()
        tableView.backgroundView = backgroundView
    }
    
    //MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (categoriesViewModel.categories.count == 0) {
            showPlaceHolder()
        } else {
            tableView.backgroundView = nil
        }
        return categoriesViewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.prepareForReuse()
        cell.viewModel = categoriesViewModel.categories[indexPath.row]
        if categoriesViewModel.categoryIsChosen(category: cell.viewModel) {
            cell.accessoryType = .checkmark
        }
        
        if categoriesViewModel.categories.count == 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMinYCorner,
                                        .layerMinXMinYCorner,
                                        .layerMinXMaxYCorner,
                                        .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 16
        } else if categoriesViewModel.isLastCategory(index: indexPath.row) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell  else { return }
        cell.accessoryType = .checkmark
        categoriesViewModel.categoryCellWasTapped(at: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell  else { return }
        cell.accessoryType = .none
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
