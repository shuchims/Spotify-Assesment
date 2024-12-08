//
//  Untitled.swift
//  Spotify
//
//  Created by Shuchi Mehra Sharma on 09/12/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self // Set delegate to self
    }
    
    // Disable animation when switching tabs
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        UIView.setAnimationsEnabled(false)
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(true)
        }
        return true
    }
}
