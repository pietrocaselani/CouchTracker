@testable import CouchTrackerCore
import Nimble
import RxTest
import TraktSwift
import XCTest

final class TraktTokenPolicyDeciderTest: XCTestCase {
    private var output: TraktLoginOutputMock!
    private var policyDecider: TraktLoginPolicyDecider!
    private var schedulers: TestSchedulers!
    private let request = URLRequest(url: URL(string: "couchtracker://my_awesome_url")!)

    override func setUp() {
        super.setUp()

        output = TraktLoginOutputMock()
        schedulers = TestSchedulers(initialClock: 0)
    }

    override func tearDown() {
        output = nil
        schedulers = nil

        super.tearDown()
    }

    func setupPolicyDecider(_ traktProvider: TraktProvider = createTraktProviderMock()) {
        policyDecider = TraktTokenPolicyDecider(loginOutput: output, traktProvider: traktProvider, schedulers: schedulers)
    }

    func testTraktTokenPolicyDecider_receivesError_notifyOutput() {
        // Given
        let errorMessage = "Trakt is offline :("
        let genericError = NSError(domain: "io.github.pietrocaselani", code: 305, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        setupPolicyDecider(TraktProviderMock(oauthURL: nil, error: genericError))

        // When
        let res = schedulers.start {
            self.policyDecider.allowedToProceed(with: self.request).asObservable()
        }

        // Then
        let expectedEvent = error(201, genericError, AuthenticationResult.self)

        expect(res.events).to(containElementSatisfying({ element -> Bool in
            element == expectedEvent
        }))

        XCTAssertTrue(output.invokedLogInFail)
        XCTAssertEqual(output.invokedLoginFailParameters?.message, errorMessage)
    }

    func testTraktTokenPolicyDecider_receivesUndeterminedResult_doNothing() {
        // Given
        setupPolicyDecider()

        // When
        let res = schedulers.start {
            self.policyDecider.allowedToProceed(with: self.request).asObservable()
        }

        // Then
        let expectedResult = AuthenticationResult.undetermined
        let expectedEvent = next(201, expectedResult)

        expect(res.events).to(containElementSatisfying({ element -> Bool in
            element == expectedEvent
        }))

        XCTAssertFalse(output.invokedLogInFail)
        XCTAssertFalse(output.invokedLoggedInSuccessfully)
    }

    func testTraktTokenPolicyDecider_receivesAuthenticatedResult_notifyOutput() {
        // Given
        let trakt = TraktProviderMock(oauthURL: URL(string: "http://google.com"), error: nil)
        setupPolicyDecider(trakt)

        // When
        let res = schedulers.start {
            self.policyDecider.allowedToProceed(with: self.request).asObservable()
        }

        // Then
        let expectedResult = AuthenticationResult.authenticated
        let expectedEvent = next(201, expectedResult)

        expect(res.events).to(containElementSatisfying({ element -> Bool in
            element == expectedEvent
        }))

        XCTAssertTrue(output.invokedLoggedInSuccessfully)
    }
}
