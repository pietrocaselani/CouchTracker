import XCTest
import RxSwift
import RxTest
import TMDBSwift

final class ImageCachedRepositoryTest: XCTestCase {
	private let scheduler = TestSchedulers()
	private var repository: ImageCachedRepository!
	private var observer: TestableObserver<ImagesEntity>!

	override func setUp() {
		super.setUp()

		repository = ImageCachedRepository(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock,
				cofigurationRepository: configurationRepositoryMock, schedulers: scheduler)

		observer = scheduler.createObserver(ImagesEntity.self)
	}

	func testImageCachedRepository_fetchMovieImages_withDefaultSizes() {
		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w300/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w342/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(1, images), completed(2)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testImageCachedRepository_fetchMovieImages_withSpecificSizes() {
		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: .w92, backdropSize: .w1280).subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w1280/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w92/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(1, images), completed(2)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testImageCachedRepository_fetchShowImages_withDefaultSizes() {
		var link = "https:/image.tmdb.org/t/p/w300/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"
		let backdrop = ImageEntity(link: link, width: 1920, height: 1080, iso6391: nil, aspectRatio: 1.777777777777778, voteAverage: 5.396825396825397, voteCount: 6)


		link = "https:/image.tmdb.org/t/p/w342/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
		let poster = ImageEntity(link: link, width: 2000, height: 3000, iso6391: "en", aspectRatio: 0.6666666666666666, voteAverage: 5.522, voteCount: 6)

		let images = ImagesEntity(identifier: 1409, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let single = repository.fetchShowImages(for: 1409, posterSize: nil, backdropSize: nil)

		let testExpectation = expectation(description: "Expect for images entity")

		_ = single.subscribe(onSuccess: { imagesEntity in
			testExpectation.fulfill()
			XCTAssertEqual(imagesEntity, images)
		}, onError: {
			XCTFail($0.localizedDescription)
		})

		scheduler.start()

		wait(for: [testExpectation], timeout: 0.2)
	}

	func testImageCachedRepository_fetchShowImages_withSpecificSizes() {
		var link = "https:/image.tmdb.org/t/p/w780/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"
		let backdrop = ImageEntity(link: link, width: 1920, height: 1080, iso6391: nil, aspectRatio: 1.777777777777778, voteAverage: 5.396825396825397, voteCount: 6)


		link = "https:/image.tmdb.org/t/p/w154/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
		let poster = ImageEntity(link: link, width: 2000, height: 3000, iso6391: "en", aspectRatio: 0.6666666666666666, voteAverage: 5.522, voteCount: 6)

		let images = ImagesEntity(identifier: 1409, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let single = repository.fetchShowImages(for: 1409, posterSize: .w154, backdropSize: .w780)

		let testExpectation = expectation(description: "Expect for images entity")

		_ = single.subscribe(onSuccess: { imagesEntity in
			testExpectation.fulfill()
			XCTAssertEqual(imagesEntity, images)
		}, onError: {
			XCTFail($0.localizedDescription)
		})

		scheduler.start()

		wait(for: [testExpectation], timeout: 0.2)
	}
}
