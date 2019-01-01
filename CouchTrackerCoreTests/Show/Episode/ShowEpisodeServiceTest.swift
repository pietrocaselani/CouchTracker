@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class ShowEpisodeServiceTest: XCTestCase {
  private var imageRepository: ImageRepositoryMock!
  private var repository: ShowEpisodeMocks.ShowEpisodeRepositoryMock!
  private var interactor: ShowEpisodeService!
  private var observer: TestableObserver<ShowEpisodeImages>!
  private var scheduler: TestScheduler!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(ShowEpisodeImages.self)

    imageRepository = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
    repository = ShowEpisodeMocks.ShowEpisodeRepositoryMock()
    interactor = ShowEpisodeService(repository: repository, imageRepository: imageRepository)
  }

  override func tearDown() {
    scheduler = nil
    observer = nil
    imageRepository = nil
    repository = nil
    interactor = nil

    super.tearDown()
  }

  func testShowEpisodeService_whenThereIsNoTMDBId_emitsEmpty() {
    // Given
    let input = EpisodeImageInputMock(tmdb: nil, tvdb: nil, season: 0, number: 0)

    // When
    _ = interactor.fetchImages(for: input).asObservable().subscribe(observer)

    // Then
    let expectedEvents: [Recorded<Event<ShowEpisodeImages>>] = [Recorded.completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowEpisodeService_fetchImageURLFromTMDBWithDefaultSize() {
    // Given
    let input = EpisodeImageInputMock(tmdb: 63056, tvdb: 3_254_641, season: 4, number: 10)

    // When
    _ = interactor.fetchImages(for: input)

    // Then
    let expectedSizes = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)

    XCTAssertTrue(imageRepository.fetchEpisodeImagesInvoked)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.input.tvdb, input.tvdb)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.tmdb, input.tmdb)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.season, input.season)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.number, input.number)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.sizes, expectedSizes)
  }

  func testShowEpisodeService_fetchImage_emitSuccess() {
    // Given
    let input = EpisodeImageInputMock(tmdb: 63056, tvdb: 3_254_641, season: 4, number: 10)

    // When
    _ = interactor.fetchImages(for: input).asObservable().subscribe(observer)

    // Then
    let posterURL = URL(validURL: "https:/image.tmdb.org/t/p/w780/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg")
    let previewURL = URL(validURL: "https:/image.tmdb.org/t/p/w300/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")
    let images = ShowEpisodeImages(posterURL: posterURL, previewURL: previewURL)
    let expectedEvents = [Recorded.next(0, images), Recorded.completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowEpisodeService_toggleWatch_forUnwatchedEpisode_shouldAddOnHistory() {
    // Given
    let episode = ShowsProgressMocks.mockWatchedEpisode(watched: nil)

    // When
    _ = interactor.toggleWatch(for: episode)

    // Then
    XCTAssertTrue(repository.addToHistoryInvoked)
    XCTAssertFalse(repository.removeFromHistoryInvoked)
    XCTAssertEqual(repository.addToHistoryParameters, episode.episode)
  }

  func testShowEpisodeService_toggleWatch_forWwatchedEpisode_shoulRemoveFromHistory() {
    // Given
    let episode = ShowsProgressMocks.mockWatchedEpisode(watched: Date(timeIntervalSince1970: 0))

    // When
    _ = interactor.toggleWatch(for: episode)

    // Then
    XCTAssertFalse(repository.addToHistoryInvoked)
    XCTAssertTrue(repository.removeFromHistoryInvoked)
    XCTAssertEqual(repository.removeFromHistoryParameters, episode.episode)
  }
}
