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

    guard let listMoviesView = window?.rootViewController as? ListMoviesView else {
      fatalError("RootViewController isn't an instance of ListMoviesView")
    }

    let moviesModule = ListMoviesModule()
    moviesModule.configure(view: listMoviesView)

    self.listMoviesModule = moviesModule

    return true
  }

}
