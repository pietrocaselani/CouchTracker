@testable import CouchTrackerCore
import XCTest

final class ShowProgressCellServiceTest: XCTestCase {
  private var imageRepository: ImagesRepositorySampleMock!
  private var interactor: ShowProgressCellService!

  override func setUp() {
    super.setUp()

    imageRepository = ImagesRepositorySampleMock()
    interactor = ShowProgressCellService(imageRepository: imageRepository)
  }

  func testShowProgressCellService_receivesEmptyURL_emitsOnCompleted() {
    // Given
    let imageEntities = [ImageEntity]()
    let images = ImagesEntity(identifier: 1010, backdrops: imageEntities, posters: imageEntities, stills: imageEntities)
    imageRepository.images = images

    // When
    let maybe = interactor.fetchPosterImageURL(for: 1010, with: nil)

    // Then
    let testExpectation = expectation(description: "Should receive on completed")

    _ = maybe.subscribe {
      testExpectation.fulfill()
      XCTAssertTrue(self.imageRepository.fetchShowsImagesInvoked)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowProgressCellService_receivesError_emitsOnError() {
    // Given
    let imageError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 1010, userInfo: nil)
    let imageRepository = ErrorImageRepositoryMock(error: imageError)
    interactor = ShowProgressCellService(imageRepository: imageRepository)

    // When
    let maybe = interactor.fetchPosterImageURL(for: 1010, with: nil)

    // Then
    let testExpectation = expectation(description: "Should receive on error")

    _ = maybe.subscribe(onError: { _ in
      testExpectation.fulfill()
    })

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowProgressCellService_receivesValidURL_emitsURL() {
    // Given
    let entity = ImageEntity(link: "http://fake.com/image.png", width: 100, height: 100, iso6391: nil, aspectRatio: 1.2, voteAverage: 2.3, voteCount: 3)
    let imageEntities = [entity]
    let images = ImagesEntity(identifier: 1010, backdrops: imageEntities, posters: imageEntities, stills: imageEntities)
    imageRepository.images = images

    // When
    let maybe = interactor.fetchPosterImageURL(for: 1010, with: nil)

    // Then
    let testExpectation = expectation(description: "Should receive URL")
    guard let expectedURL = URL(string: "http://fake.com/image.png") else {
      XCTFail()
      return
    }

    _ = maybe.subscribe(onSuccess: { url in
      testExpectation.fulfill()
      XCTAssertEqual(url, expectedURL)
    })

    wait(for: [testExpectation], timeout: 1)
  }
}
