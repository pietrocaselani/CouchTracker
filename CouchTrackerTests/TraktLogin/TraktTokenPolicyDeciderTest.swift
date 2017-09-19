/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

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
    let genericError = NSError(domain: "com.arctouch", code: 305, userInfo: [NSLocalizedDescriptionKey: errorMessage])
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
