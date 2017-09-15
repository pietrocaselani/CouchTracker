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
import RxSwift
import RxTest

final class AppConfigurationsInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)
  private var disposeBag: CompositeDisposable!
  private var observer: TestableObserver<LoginState>!

  override func setUp() {
    observer = scheduler.createObserver(LoginState.self)
    disposeBag = CompositeDisposable()
    super.setUp()
  }

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testAppConfigurationsInteractor_fetchUserFailure_emitsGenericError() {
    //Given
    let message = "decrypt error"
    let genericError = NSError(domain: "com.arctouch", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
    let repository = AppConfigurationsRepositoryErrorMock(error: genericError)
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let observable = interactor.fetchLoginState()

    //Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedEvents: [Recorded<Event<LoginState>>] = [error(0, genericError)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationsInteractor_fetchUserFailure_emitsNotLogged() {
    //Given an empty repository
    let repository = AppConfigurationsRepositoryMock(usersProvider: traktProviderMock.users, isEmpty: true)
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let observable = interactor.fetchLoginState()

    //Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedEvents = [next(0, LoginState.notLogged), completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationsInteractor_fetchUser_emitsUserLogged() {
    //Given a repository with token
    let repository = AppConfigurationsRepositoryMock(usersProvider: traktProviderMock.users)
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let observable = interactor.fetchLoginState()

    //Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedUser = AppConfigurationsMock.createUserMock()
    let expectedEvents = [next(0, LoginState.logged(user: expectedUser)), completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
