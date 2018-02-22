import XCTest
import RxSwift
import RxTest
import TMDBSwift
@testable import CouchTrackerCore

final class ImageCachedRepositoryTest: XCTestCase {
	private let scheduler = TestSchedulers()
	private var repository: ImageCachedRepository!
	private var observer: TestableObserver<ImagesEntity>!
	private var episodeObserver: TestableObserver<URL>!

	override func setUp() {
		super.setUp()

		repository = ImageCachedRepository(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock,
				cofigurationRepository: configurationRepositoryMock, schedulers: scheduler)

		observer = scheduler.createObserver(ImagesEntity.self)
	episodeObserver = scheduler.createObserver(URL.self)
	}

	func testImageCachedRepository_fetchMovieImages_withDefaultSizes() {
		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: nil, backdropSize: nil).asObservable().subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w300/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w342/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(2, images), completed(2)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testImageCachedRepository_fetchMovieImages_withSpecificSizes() {
		//When
		_ = repository.fetchMovieImages(for: 550, posterSize: .w92, backdropSize: .w1280).asObservable().subscribe(observer)
		scheduler.start()

		//Then
		var link = "https:/image.tmdb.org/t/p/w1280/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let backdrop = ImageEntity(link: link, width: 1280, height: 720, iso6391: nil, aspectRatio: 1.77777777777778, voteAverage: 0, voteCount: 0)


		link = "https:/image.tmdb.org/t/p/w92/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let poster = ImageEntity(link: link, width: 1200, height: 1800, iso6391: "en", aspectRatio: 0.666666666666667, voteAverage: 0, voteCount: 0)

		let images = ImagesEntity(identifier: 550, backdrops: [backdrop], posters: [poster], stills: [ImageEntity]())

		let expectedEvents = [next(2, images), completed(2)]

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

	func testImageCachedRepository_fetchEpisodeImages_fromTMDB_withDefaultSizes() {
		let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3254641, season: 1, number: 1)

		_ = repository.fetchEpisodeImages(for: input).asObservable().subscribe(episodeObserver)

	scheduler.start()

		let expectedURL = URL(string: "https:/image.tmdb.org/t/p/w300/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")!

		let expectedEvents = [next(2, expectedURL), completed(2)]

		XCTAssertEqual(episodeObserver.events, expectedEvents)
	}

	func testImageCachedRepository_fetchEpisodeImages_fromTMDB_withSpecificSizes() {
		let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3254641, season: 1, number: 1)

		let sizes = EpisodeImageSizes(tvdb: .normal, tmdb: .w185)

		_ = repository.fetchEpisodeImages(for: input, size: sizes).asObservable().subscribe(episodeObserver)

		scheduler.start()

		let expectedURL = URL(string: "https:/image.tmdb.org/t/p/w185/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg")!

		let expectedEvents = [next(2, expectedURL), completed(2)]

		XCTAssertEqual(episodeObserver.events, expectedEvents)
	}

	func testImageCachedRepository_fetchEpisodeImages_fromTVDB_withEmptyTMDBId_withDefaultSizes() {
		let input = EpisodeImageInputMock(tmdb: nil, tvdb: 3254641, season: 1, number: 1)

		_ = repository.fetchEpisodeImages(for: input).asObservable().subscribe(episodeObserver)

		scheduler.start()

		let expectedURL = URL(string: "https://www.thetvdb.com/banners/episodes/121361/3254641.jpg")!

		let expectedEvents = [next(0, expectedURL), completed(0)]

		XCTAssertEqual(episodeObserver.events, expectedEvents)
	}

	func testImageCachedRepository_fetchEpisodeImages_fromTVDB_withEmptyTMDBId_withSpecificSizes() {
		let input = EpisodeImageInputMock(tmdb: nil, tvdb: 3254641, season: 1, number: 1)

		let sizes = EpisodeImageSizes(tvdb: .small, tmdb: .w92)

		_ = repository.fetchEpisodeImages(for: input, size: sizes).asObservable().subscribe(episodeObserver)

		scheduler.start()

		let expectedURL = URL(string: "https://www.thetvdb.com/banners/_cache/episodes/121361/3254641.jpg")!

		let expectedEvents = [next(0, expectedURL), completed(0)]

		XCTAssertEqual(episodeObserver.events, expectedEvents)
	}

	func testImageCachedRepository_fetchEpisodeImages_fromTVDB_becauseTMDBThrowsError_withSpecificSizes() {
		let repository = ImageCachedRepository(tmdb: TMDBErrorProviderMock(), tvdb: tvdbProviderMock,
				cofigurationRepository: configurationRepositoryMock, schedulers: scheduler)

		let input = EpisodeImageInputMock(tmdb: 1399, tvdb: 3254641, season: 1, number: 1)

		let sizes = EpisodeImageSizes(tvdb: .small, tmdb: .w92)

		_ = repository.fetchEpisodeImages(for: input, size: sizes).asObservable().subscribe(episodeObserver)

		scheduler.start()

		let expectedURL = URL(string: "https://www.thetvdb.com/banners/_cache/episodes/121361/3254641.jpg")!

		let expectedEvents = [next(1, expectedURL), completed(1)]

		XCTAssertEqual(episodeObserver.events, expectedEvents)
	}
}
