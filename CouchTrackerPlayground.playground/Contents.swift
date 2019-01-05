//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

//import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import Cartography
import RxSwift

enum MyCoolState {
	case empty
	case done
	case error(message: String)
}

//let subject = BehaviorSubject<MyCoolState>(value: .empty)
//
//func changeSubject() {
//	subject.onNext(.error(message: "Eita!"))
//}

let vc = ColorsViewController()
PlaygroundPage.current.liveView = vc
