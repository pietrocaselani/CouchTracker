import XCTest
import RxTest
import RxSwift
import TraktSwift

final class ShowDetailsInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)

  func testShowDetailsInteractor_fetchDetailsFailure_emitsError() {
    let showError = NSError(domain: "io.github.pietrocaselani", code: 4)
    let repository = ShowDetailsRepositoryErrorMock(error: showError)

    let interactor = ShowDetailsService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                        repository: repository,
                                        genreRepository: GenreRepositoryMock(),
                                        imageRepository: imageRepositoryMock)

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchDetailsOfShow().subscribe(onSuccess: { show in
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

  func testShowDetailsInteractor_fetchDetailsSuccess_emitsShow() {
    let interactor = ShowDetailsService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
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
    }) { _ in
      XCTFail()
    }

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    wait(for: [showExpectation], timeout: 1)
  }

  func testShowDetailsInteractor_fetchImagesFailure_emitsError() {
    let showError = NSError(domain: "io.github.pietrocaselani", code: 4)
    let interactor = ShowDetailsService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                        repository: showDetailsRepositoryMock,
                                        genreRepository: GenreRepositoryMock(),
                                        imageRepository: ErrorImageRepositoryMock(error: showError))

    let errorExpectation = expectation(description: "Expect interactor to emit an error")

    let disposable = interactor.fetchImages().subscribe(onSuccess: { show in
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

  func testShowDetailsInteractor_fetchImagesSuccess_emitsData() {
    let interactor = ShowDetailsService(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
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
    }) { error in
      XCTFail()
    }

    scheduler.scheduleAt(600) {
      disposable.dispose()
    }

    scheduler.start()

    wait(for: [dataExpectation], timeout: 1)
  }
}
