@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class ShowOverviewInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)

  func testShowOverviewInteractor_fetchDetailsFailure_emitsError() {
    let showError = NSError(domain: "io.github.pietrocaselani", code: 4)
    let repository = ShowOverviewRepositoryErrorMock(error: showError)

    let interactor = ShowOverviewService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                         repository: repository,
                                         genreRepository: GenreRepositoryMock(),
                                         imageRepository: imageRepositoryMock)

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchDetailsOfShow().subscribe(onSuccess: { _ in
      XCTFail()
    }) { error in
      XCTAssertEqual(error as NSError, showError)
      errorExpectation.fulfill()
    }

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    wait(for: [errorExpectation], timeout: 1)
  }

  func testShowOverviewInteractor_fetchDetailsSuccess_emitsShow() {
    let interactor = ShowOverviewService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                         repository: showDetailsRepositoryMock,
                                         genreRepository: GenreRepositoryMock(),
                                         imageRepository: imageRepositoryMock)

    let showExpectation = expectation(description: "Expect interactor to emit a show")

    let show = TraktEntitiesMock.createTraktShowDetails()
    let showGenres = TraktEntitiesMock.createShowsGenresMock().filter { genre -> Bool in
      show.genres?.contains(where: { $0 == genre.slug }) ?? false
    }
    let expectedEntity = ShowEntityMapper.entity(for: show, with: showGenres)

    let disposable = interactor.fetchDetailsOfShow().subscribe(onSuccess: { entity in
      XCTAssertEqual(entity, expectedEntity)
      showExpectation.fulfill()
    })

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    wait(for: [showExpectation], timeout: 1)
  }

  func testShowOverviewInteractor_fetchImagesFailure_emitsError() {
    let showError = NSError(domain: "io.github.pietrocaselani", code: 4)
    let interactor = ShowOverviewService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                         repository: showDetailsRepositoryMock,
                                         genreRepository: GenreRepositoryMock(),
                                         imageRepository: ErrorImageRepositoryMock(error: showError))

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchImages().subscribe(onSuccess: { _ in
      XCTFail()
    }, onError: { error in
      XCTAssertEqual(error as NSError, showError)
      errorExpectation.fulfill()
    })

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    wait(for: [errorExpectation], timeout: 1)
  }

  func testShowOverviewInteractor_fetchImagesWithEmptyTMDBIdentifier_emitsOnCompleted() {
    let ids = TraktEntitiesMock.createTraktShowDetails().ids

    let showIds = ShowIds(trakt: ids.trakt, tmdb: nil, imdb: ids.imdb, slug: ids.slug, tvdb: ids.tvdb, tvrage: ids.tvrage)

    let interactor = ShowOverviewService(showIds: showIds,
                                         repository: showDetailsRepositoryMock,
                                         genreRepository: GenreRepositoryMock(),
                                         imageRepository: imageRepositoryRealMock)

    let dataExpectation = expectation(description: "Expect interactor to emit on completed")

    _ = interactor.fetchImages().subscribe(onCompleted: {
      dataExpectation.fulfill()
    })

    wait(for: [dataExpectation], timeout: 1)
  }

  func testShowOverviewInteractor_fetchImagesSuccess_emitsData() {
    let interactor = ShowOverviewService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                         repository: showDetailsRepositoryMock,
                                         genreRepository: GenreRepositoryMock(),
                                         imageRepository: imageRepositoryRealMock)

    let dataExpectation = expectation(description: "Expect interactor to emit images entity")

    let backdrops = [ImageEntity(link: "https:/image.tmdb.org/t/p/w780/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg",
                                 width: 1920, height: 1080, iso6391: nil, aspectRatio: 1.77777777777778,
                                 voteAverage: 5.396825396825397, voteCount: 6)]

    let posters = [ImageEntity(link: "https:/image.tmdb.org/t/p/w780/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg",
                               width: 2000, height: 3000, iso6391: "en", aspectRatio: 0.666666666666666,
                               voteAverage: 5.522, voteCount: 6)]

    let expectedImageEntity = ImagesEntity(identifier: 1409, backdrops: backdrops,
                                           posters: posters, stills: [ImageEntity]())

    let disposable = interactor.fetchImages().subscribe(onSuccess: { images in
      dataExpectation.fulfill()
      XCTAssertEqual(images, expectedImageEntity)
    })

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    wait(for: [dataExpectation], timeout: 1)
  }
}
