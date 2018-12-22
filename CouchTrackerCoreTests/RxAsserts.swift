import RxSwift
import RxTest
import XCTest

func RXAssertEvents<T: Equatable>(_ observer: TestableObserver<[T]>, _ events: [Recorded<Event<[T]>>], file: StaticString = #file, line: UInt = #line) {
  RXAssertEvents(observer.events, events, file: file, line: line)
}

func RXAssertEvents<T: Equatable>(_ observerEvents: [Recorded<Event<[T]>>], _ events: [Recorded<Event<[T]>>], file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(observerEvents.count, events.count, file: file, line: line)

  if observerEvents.count != events.count {
    XCTFail("Number of events don't match", file: file, line: line)
    return
  }

  let count = events.count
  var index = 0

  while index < count {
    let lhs = observerEvents[index]
    let rhs = events[index]

    XCTAssertEqual(lhs.time, lhs.time, file: file, line: line)

    assertArrayEvent(lhs.value, rhs.value, file: file, line: line)

    index += 1
  }
}

fileprivate func assertArrayEvent<T: Equatable>(_ lhs: Event<[T]>, _ rhs: Event<[T]>, file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(lhs.error?.localizedDescription, rhs.error?.localizedDescription, file: file, line: line)
  XCTAssertEqual(lhs.isCompleted, rhs.isCompleted, file: file, line: line)

  let lhsElement = lhs.element
  let rhsElement = rhs.element

  XCTAssertEqual(lhsElement?.count, rhsElement?.count, file: file, line: line)

  if lhsElement?.count ?? 0 != rhsElement?.count ?? 0 {
    return
  }

  let count = lhsElement?.count ?? 0
  var index = 0

  while index < count {
    let lhsValue = lhsElement![index]
    let rhsValue = rhsElement![index]

    XCTAssertEqual(lhsValue, rhsValue, file: file, line: line)

    index += 1
  }
}
