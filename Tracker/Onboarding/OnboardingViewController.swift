//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    lazy var pages: [UIViewController] = {
        let blue = SinglePageOnboardingViewController(
            text: "Отслеживайте только то, что хотите",
            imageTitle: "Page1")
        let red = SinglePageOnboardingViewController(
            text: "Даже если это не литры воды и йога",
            imageTitle: "Page2")
            
        return [blue, red]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
            
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setUpButton()
        setUpPageControl()
    }
    
    private func setUpButton() {
        view.addSubview(button)
        
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpPageControl() {
        view.addSubview(pageControl)
            
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func didTapButton() {
        let tabBarVC = TabBarController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("⚠️ Invalid Configuration: UIWindowScene не найден")
            return
        }
        
        tabBarVC.tabBar.alpha = 0
        UIView.transition(
            with: window, duration: 0.6,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                
                window.rootViewController = tabBarVC
                tabBarVC.tabBar.alpha = 1
        })
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var previousIndex = viewControllerIndex - 1
        
        if previousIndex < 0 {
            previousIndex = pages.count - 1
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var nextIndex = viewControllerIndex + 1
        
        if nextIndex >= pages.count  {
            nextIndex = 0
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
        }
    }
}
