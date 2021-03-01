import UIKit
import TraktSwift

import Combine

private enum Secrets {
  enum Trakt {
    static let clientId = "1aec4225ee175a6affce5ad374140c360fd5f0ab5113e6aa1c123bd4baeb082b"
    static let clientSecret = "234ffdeb49f01d3fdeea35ad8726436a8713a47465b24d466070b8a424d65d49"
    static let redirectURL = "couchtracker://redirectoauth"
  }
}

public func initializeCouchTracker(
    window: UIWindow
) {
//    let traktBuilder = TraktBuilder {
//      $0.clientId = Secrets.Trakt.clientId
//      $0.clientSecret = Secrets.Trakt.clientSecret
//      $0.redirectURL = Secrets.Trakt.redirectURL
//      $0.callbackQueue = DispatchQueue(label: "NetworkQueue", qos: .utility)
//    }
//
//    let trakt = Trakt(builder: traktBuilder)

//    let viewController = TrendingMoviesViewController(
//        store: .init(
//            initialState: .init(),
//            reducer: trendingMoviesReducer,
//            environment: TrendingMoviesEnvironment(
//                client: .live(trakt: trakt, genresClient: .live(trakt: trakt)
//                )
//            )
//        )
//    )

    window.rootViewController = UIViewController()
}
