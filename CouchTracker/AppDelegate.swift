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

  let trakt = TraktV2(clientId: "1aec4225ee175a6affce5ad374140c360fd5f0ab5113e6aa1c123bd4baeb082b")

  private var listMoviesModule: ListMoviesModule!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().barTintColor = UIColor.ctblack
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ctzircon]

    guard let navigationController = window?.rootViewController as? UINavigationController else {
      fatalError("RootViewController isn't an instance of UINavigationController")
    }

    guard let listMoviesView = navigationController.topViewController as? ListMoviesView else {
      fatalError("TopViewController isn't an instance of ListMoviesView")
    }

    let moviesModule = ListMoviesModule(trakt: trakt)
    moviesModule.configure(view: listMoviesView)

    self.listMoviesModule = moviesModule

    return true
  }

}
