import RxSwift

//    let tmp = shows.asObservable().flatMap(Observable.just)

//    Current.trakt.shows.rx.request(.watchedProgress(showId: <#T##String#>, hidden: <#T##Bool#>, specials: <#T##Bool#>, countSpecials: <#T##Bool#>))

//func goWords(_ words: Single<[String]>) {
//    let tmp = words.asObservable().flatMap { Observable.from($0) }
//
//    _ = tmp.subscribe(onNext: { print($0) })
//}
//
//goWords(Single.just(["Hello", "PC"]))

_ = Observable.just("PC").subscribe(onNext: { print("\($0)") })
