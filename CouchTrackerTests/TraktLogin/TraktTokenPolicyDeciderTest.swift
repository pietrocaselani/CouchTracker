import XCTest

final class TraktTokenPolicyDeciderTest: XCTestCase {
  private let output = TraktLoginOutputMock()
  private var policyDecider: TraktLoginPolicyDecider!
  private let request = URLRequest(url: URL(string: "couchtracker://my_awesome_url")!)

  func setupPolicyDecider(_ traktProvider: TraktProvider = traktProviderMock) {
    policyDecider = TraktTokenPolicyDecider(loginOutput: output, traktProvider: traktProvider)
  }

  func testTraktTokenPolicyDecider_receivesError_notifyOutput() {
    //Given
    let errorMessage = "Trakt is offline :("
    let genericError = NSError(domain: "io.github.pietrocaselani", code: 305, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    setupPolicyDecider(TraktProviderMock(oauthURL: nil, error: genericError))

    //When
    _ = policyDecider.allowedToProceed(with: request).subscribe()

    //Then
    XCTAssertTrue(output.invokedLogInFail)
    XCTAssertEqual(output.invokedLoginFailParameters?.message, errorMessage)
  }

  func testTraktTokenPolicyDecider_receivesUndeterminedResult_doNothing() {
    //Given
    setupPolicyDecider()

    //When
    _ = policyDecider.allowedToProceed(with: request).subscribe()

    //Then
    XCTAssertFalse(output.invokedLogInFail)
    XCTAssertFalse(output.invokedLoggedInSuccessfully)
  }

  func testTraktTokenPolicyDecider_receivesAuthenticatedResult_notifyOutput() {
    //Given
    let trakt = TraktProviderMock(oauthURL: URL(string: "http://google.com"), error: nil)
    setupPolicyDecider(trakt)

    //When
    _ = policyDecider.allowedToProceed(with: request).subscribe()

    //Then
    XCTAssertTrue(output.invokedLoggedInSuccessfully)
  }
}
