@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class ShowEpisodeServiceTest: XCTestCase {
  private var imageRepository: ImageRepositoryMock!
  private var repository: ShowEpisodeMocks.ShowEpisodeRepositoryMock!
  private var interactor: ShowEpisodeService!

  override func setUp() {
    super.setUp()

    imageRepository = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
    repository = ShowEpisodeMocks.ShowEpisodeRepositoryMock()
    interactor = ShowEpisodeService(repository: repository, imageRepository: imageRepository)
  }

  func testShowEpisodeService_fetchImageURLFromTMDBWithDefaultSize() {
    // Given
    let input = EpisodeImageInputMock(tmdb: 63056, tvdb: 3_254_641, season: 4, number: 10)

    // When
    _ = interactor.fetchImageURL(for: input)

    // Then
    let expectedSizes = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)

    XCTAssertTrue(imageRepository.fetchEpisodeImagesInvoked)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.input.tvdb, input.tvdb)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.tmdb, input.tmdb)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.season, input.season)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.number, input.number)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.sizes, expectedSizes)
  }

  func testShowEpisodeService_fetchImageURLFromTVDBWithDefaultSize() {
    // Given
    let input = EpisodeImageInputMock(tmdb: nil, tvdb: 3_254_641, season: 4, number: 10)

    // When
    _ = interactor.fetchImageURL(for: input)

    // Then
    let expectedSizes = EpisodeImageSizes(tvdb: .normal, tmdb: .w300)

    XCTAssertTrue(imageRepository.fetchEpisodeImagesInvoked)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.input.tvdb, input.tvdb)
    XCTAssertNil(imageRepository.fetchEpisodeImagesParameters?.input.tmdb)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.season, input.season)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters?.input.number, input.number)
    XCTAssertEqual(imageRepository.fetchEpisodeImagesParameters!.sizes, expectedSizes)
  }

  func testShowEpisodeService_toggleWatch_forUnwatchedEpisode_shouldAddOnHistory() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    let episode = ShowsProgressMocks.mockEpisodeEntity(watched: nil)

    // When
    _ = interactor.toggleWatch(for: episode, of: show)

    // Then
    XCTAssertTrue(repository.addToHistoryInvoked)
    XCTAssertFalse(repository.removeFromHistoryInvoked)
    XCTAssertEqual(repository.addToHistoryParameters!.show, show)
    XCTAssertEqual(repository.addToHistoryParameters!.episode, episode)
  }

  func testShowEpisodeService_toggleWatch_forWwatchedEpisode_shoulRemoveFromHistory() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    let episode = ShowsProgressMocks.mockEpisodeEntity(watched: Date(timeIntervalSince1970: 0))

    // When
    _ = interactor.toggleWatch(for: episode, of: show)

    // Then
    XCTAssertFalse(repository.addToHistoryInvoked)
    XCTAssertTrue(repository.removeFromHistoryInvoked)
    XCTAssertEqual(repository.removeFromHistoryParameters!.show, show)
    XCTAssertEqual(repository.removeFromHistoryParameters!.episode, episode)
  }
}
