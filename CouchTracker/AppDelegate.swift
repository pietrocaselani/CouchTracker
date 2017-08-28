//
//  AppDelegate.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/16/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

import UIKit
import Trakt

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let trakt = Trakt(clientId: "1aec4225ee175a6affce5ad374140c360fd5f0ab5113e6aa1c123bd4baeb082b")

  private var listMoviesModule: ListMoviesModule!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().barTintColor = UIColor.ctblack
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ctzircon]

    guard let viewController = ListMoviesModule.setupModule(apiProvider: trakt) as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()

    return true
  }

}
