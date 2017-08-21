//
//  AppDelegate.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/16/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  private var listMoviesModule: ListMoviesModule!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    listMoviesModule = ListMoviesModule()
    let view = listMoviesModule.loadView()

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()

    return true
  }

}
