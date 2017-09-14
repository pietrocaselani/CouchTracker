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
import TraktSwift

final class AppConfigurationsPresenterTest: XCTestCase {
  private let view = AppConfigurationsViewMock()
  private let router = AppConfigurationsRouterMock()
  private var presenter: AppConfigurationsPresenter!

  override func tearDown() {
    presenter = nil
    super.tearDown()
  }

  private func setUpModuleWithError(_ error: Error) {
    let repository = AppConfigurationsRepositoryErrorMock(error: error)
    let interactor = AppConfigurationsInteractorMock(repository: repository)
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  private func setupModuleWithToken(_ token: Token?)  {
    let repository = AppConfigurationsRepositoryMock()
    repository.appToken = token
    let interactor = AppConfigurationsInteractorMock(repository: repository)
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  func testAppConfigurationsPresenter_receivesGenericError_notifyRouter() {
    //Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "com.arctouch", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(router.invokedShowErrorMessage)
    XCTAssertEqual(router.invokedShowErrorMessageParameters?.message, message)
  }

  func testAppConfigurationsPresenter_receivesTokenError_notifyView() {
    //Given
    setUpModuleWithError(TokenError.absent)

    //When
    presenter.viewDidLoad()

    //Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil)
    let viewModels = [AppConfigurationsViewModel(title: "Main", configurations: [connectToTraktViewModel])]

    XCTAssertTrue(view.invokedShowConfigurations)
    XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
  }

  func testAppConfigurationsPresenter_receivesTokenSuccess_notifyView() {
    //Given
    let repository = AppConfigurationsRepositoryMock()
    repository.appToken = AppConfigurationsMock.createTraktTokenMock()
    let interactor = AppConfigurationsInteractorMock(repository: repository)
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)

    //When
    presenter.viewDidLoad()

    //Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: "trakt username")
    let viewModels = [AppConfigurationsViewModel(title: "Main", configurations: [connectToTraktViewModel])]

    XCTAssertTrue(view.invokedShowConfigurations)
    XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
  }

  func testAppConfigurationsPresenter_receivesEventAlreadyConnectedToTraktFromView_doesNothing() {
    //Given
    setupModuleWithToken(AppConfigurationsMock.createTraktTokenMock())

    //When
    presenter.viewDidLoad()
    presenter.optionSelectedAt(index: 0)

    //Then
    XCTAssertFalse(router.invokedShowTraktLogin)
  }

  func testAppConfigurationsPresenter_receivesEventConnectToTraktFromView_notifyRouter() {
    //Given
    setupModuleWithToken(nil)

    //When
    presenter.viewDidLoad()
    presenter.optionSelectedAt(index: 0)

    //Then
    XCTAssertTrue(router.invokedShowTraktLogin)
  }
}
