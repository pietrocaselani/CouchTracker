import RxSwift

extension ObservableType {
	static func justWithoutCompletion(_ element: E) -> Observable<E> {
		return Observable.create({ emiter -> Disposable in
			emiter.onNext(element)
			return Disposables.create()
		})
	}
}
