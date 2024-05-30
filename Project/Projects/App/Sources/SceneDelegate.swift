//
//  SceneDelegate.swift
//  App
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit
import Coordinator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - private property
  
  private lazy var coordinator: Coordinator = AppCoordinator(root: UINavigationController())
  
  
  // MARK: - internal property
  
  var window: UIWindow?
  
  // MARK: - life cycle
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      self.window = window
      window.rootViewController = coordinator.root
      coordinator.navigate(to: .searchIsRequired)
      
      self.window?.makeKeyAndVisible()
    }
    
    if let userActivity = connectionOptions.userActivities.first {
      self.scene(scene, continue: userActivity)
    } else {
      self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
  }
  
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    
  }
  
}
