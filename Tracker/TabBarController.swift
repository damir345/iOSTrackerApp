//
//  ViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import UIKit


final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        setupTabs()
    }
    
    private func setupTabs() {
        //tracker2
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerTabBarActive"),
            selectedImage: nil
        )
        let navViewController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statTabBar"),
            selectedImage: nil)
        
        self.viewControllers = [navViewController, statisticsViewController]
    }
}

