//
//  ViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let trackersVC = UINavigationController(rootViewController: TrackersViewController())
        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle"), tag: 0)

        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "chart.bar"), tag: 1)

        viewControllers = [trackersVC, statisticsVC]
    }
}

