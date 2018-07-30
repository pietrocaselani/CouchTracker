@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class PosterCellInteractorTest: XCTestCase {
    let scheduler = TestScheduler(initialClock: 0)
    var observer: TestableObserver<URL>!

    override func setUp() {
        super.setUp()

        observer = scheduler.createObserver(URL.self)
    }

    func testTrendingInteractor_fetchPosterImageURLForShowSuccess_emitsNextAndCompleted() {
        let type = PosterViewModelType.show(tmdbShowId: 2)
        let interactor = PosterCellService(imageRepository: imageRepositoryRealMock)
        let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

        let disposable = observable.asObservable().subscribe(observer)

        scheduler.scheduleAt(600) {
            disposable.dispose()
        }

        scheduler.start()

        let expectedURL = URL(string: "https:/image.tmdb.org/t/p/w92/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg")!

        let events: [Recorded<Event<URL>>] = [next(0, expectedURL), completed(0)]

        XCTAssertEqual(observer.events, events)
    }

    func testTrendingInteractor_fetchPosterImageURLForMovieFailure_emitsOnError() {
        let type = PosterViewModelType.movie(tmdbMovieId: 4)
        let imageError = NSError(domain: "io.github.pietrocaselani", code: 100, userInfo: nil)
        let interactor = PosterCellService(imageRepository: ErrorImageRepositoryMock(error: imageError))
        let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

        let disposable = observable.asObservable().subscribe(observer)

        scheduler.scheduleAt(600) {
            disposable.dispose()
        }

        scheduler.start()

        let events: [Recorded<Event<URL>>] = [error(0, imageError)]

        XCTAssertEqual(observer.events, events)
    }

    func testTrendingInteractor_fetchPosterImageURLForMovieSuccessReceivesEmptyData_emitsOnCompleted() {
        let type = PosterViewModelType.movie(tmdbMovieId: 4)

        let images = [ImageEntity]()
        let imagesMock = ImagesEntity(identifier: 4, backdrops: images, posters: images, stills: images)

        let repository = ImagesRepositorySampleMock(images: imagesMock)

        let interactor = PosterCellService(imageRepository: repository)
        let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

        let disposable = observable.asObservable().subscribe(observer)

        scheduler.scheduleAt(600) {
            disposable.dispose()
        }

        scheduler.start()

        let events: [Recorded<Event<URL>>] = [completed(0)]

        XCTAssertEqual(observer.events, events)
    }

    func testTrendingInteractor_fetchPosterImageURLForMovieSuccessReceivesData_emitsURL() {
        let type = PosterViewModelType.movie(tmdbMovieId: 4)

        let image = ImageEntity(link: "https://pc.com", width: 123, height: 321, iso6391: nil, aspectRatio: 2.1, voteAverage: 3.2, voteCount: 5)
        let images = [image]
        let imagesMock = ImagesEntity(identifier: 4, backdrops: images, posters: images, stills: images)

        let repository = ImagesRepositorySampleMock(images: imagesMock)

        let interactor = PosterCellService(imageRepository: repository)
        let observable = interactor.fetchPosterImageURL(of: type, with: PosterImageSize.w92)

        let disposable = observable.asObservable().subscribe(observer)

        scheduler.scheduleAt(600) {
            disposable.dispose()
        }

        scheduler.start()

        let events: [Recorded<Event<URL>>] = [next(0, URL(string: "https://pc.com")!), completed(0)]

        XCTAssertEqual(observer.events, events)
    }
}
