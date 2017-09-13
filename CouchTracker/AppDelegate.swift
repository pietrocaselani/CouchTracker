//
//  AppDelegate.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/16/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

import UIKit
import TraktSwift
import TMDBSwift
import Carlos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private let trakt = Trakt(clientId: "1aec4225ee175a6affce5ad374140c360fd5f0ab5113e6aa1c123bd4baeb082b")
  private let tmdb = TMDB(apiKey: "d2042fb7e51f1e8c94c015dacd5074f2")
  private var listMoviesModule: TrendingModule!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    Carlos.Logger.output = {_, _ in }

    UINavigationBar.appearance().barTintColor = UIColor.ctblack
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ctzircon]

    let view = TrendingModule.setupModule(traktProvider: trakt, tmdbProvider: tmdb)

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()

    return true
  }
}
