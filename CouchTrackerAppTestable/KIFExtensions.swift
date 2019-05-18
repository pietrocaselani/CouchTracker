import Foundation
import KIF
import XCTest

public extension XCTestCase {
  func tester(file: String = #file, _ line: Int = #line) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }

  func system(file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
}

public extension KIFTestActor {
  func tester(file: String = #file, _ line: Int = #line) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }

  func system(file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
}

extension UIView {
  var keyWindow: UIWindow? { return UIApplication.shared.keyWindow }

  public func isVisible() -> Bool {
    guard let rect = superview?.convert(frame, to: nil) else { return false }
    let isInWindow = keyWindow?.bounds.contains(rect) ?? false
    return isInWindow
      && !isHidden
      && alpha > 0
  }
}

extension UITableView {
  public func scrollToTop() {
    setContentOffset(.zero, animated: false)
  }

  public func scrollToBottom() {
    setContentOffset(CGPoint(x: 0, y: contentSize.height), animated: false)
  }
}

extension KIFUITestActor {
  var keyWindow: UIWindow? { return UIApplication.shared.keyWindow }

  // MARK: - Instant matchers

  public func element(withAccessibilityHint hint: String) -> UIAccessibilityElement? {
    return keyWindow?.accessibilityElement { $0?.accessibilityHint == hint }
  }

  public func element(withAccessibilityIdentifier identifier: String) -> UIAccessibilityElement? {
    return keyWindow?.accessibilityElement { $0?.accessibilityIdentifier == identifier }
  }

  public func view(withAccessibilityHint hint: String) -> UIView? {
    return keyWindow?.view { $0?.accessibilityHint == hint }
  }

  public func view(withAccessibilityLabel label: String) -> UIView? {
    return keyWindow?.view { $0?.accessibilityLabel == label }
  }

  public func view(withAccessibilityIdentifier identifier: String) -> UIView? {
    return keyWindow?.view { $0?.accessibilityIdentifier == identifier }
  }

  // MARK: - Partial instant matchers

  public func element(withAccessibilityLabelThatContains label: String) -> UIAccessibilityElement? {
    return keyWindow?.accessibilityElement { $0?.accessibilityLabel?.contains(label) ?? false }
  }

  public func view(withAccessibilityLabelThatContains string: String) -> UIView? {
    return keyWindow?.view { $0?.accessibilityLabel?.contains(string) ?? false }
  }

  public func view(withAccessibilityHintThatContains string: String) -> UIView? {
    return keyWindow?.view { $0?.accessibilityHint?.contains(string) ?? false }
  }

  // MARK: - Partial tap matchers

  public func tapElement(withAccessibilityLabelThatContains string: String) {
    var element: UIAccessibilityElement?
    wait(for: &element,
         view: nil,
         withElementMatching: NSPredicate(format: "accessibilityLabel CONTAINS %@", string),
         tappable: true)

    if let e = element {
      tap(element: e)
    } else {
      XCTFail("Failed to find element that contains: \(string)")
    }
  }

  public func tapView(withAccessibilityIdentifier identifier: String) {
    var view: UIView?
    wait(for: nil, view: &view, withIdentifier: identifier, tappable: true)
    view?.tap()
  }

  public func tapNavigationBackButton() {
    tester().tapScreen(at: CGPoint(x: 15, y: 25))
  }

  // MARK: - Swipe actions

  public func swipeView(withAccessibilityIdentifier identifier: String, inDirection direction: KIFSwipeDirection) {
    var view: UIView?
    var element: UIAccessibilityElement?

    wait(for: &element, view: &view, withIdentifier: identifier, tappable: true)
    swipeAccessibilityElement(element, in: view, in: direction)
  }

  // MARK: - TableView/Scroll actions

  public func firstTableView() -> UITableView? {
    return keyWindow?.view { $0 is UITableView } as! UITableView?
  }

  public func scroll(_ tableView: UITableView?, toIndexPath indexPath: IndexPath) {
    guard let tableView = tableView else { return XCTFail("A tableView was not provided.") }
    tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
  }

  // MARK: - Condition waiters

  public func wait(for timeout: TimeInterval? = nil, untilTrue block: @escaping () -> Bool) {
    let waitBlock: KIFTestExecutionBlock = { _ in block() ? .success : .wait }
    if let t = timeout {
      run(waitBlock, timeout: t)
    } else {
      run(waitBlock)
    }
  }

  // MARK: - View waiters

  @discardableResult
  public func waitForView(withAccessibilityIdentifier identifier: String) -> UIView? {
    var view: UIView?
    wait(for: nil,
         view: &view,
         withElementMatching: NSPredicate(format: "accessibilityIdentifier == %@", identifier),
         tappable: false)

    return view
  }

  @discardableResult
  public func waitForView(withAccessibilityLabelThatContains label: String, tappable: Bool = true) -> UIView? {
    var view: UIView?
    wait(for: nil,
         view: &view,
         withElementMatching: NSPredicate(format: "accessibilityLabel CONTAINS %@", label),
         tappable: tappable)

    return view
  }

  public func waitForAbsenceOfView(withAccessibilityIdentifier identifier: String) {
    waitForAbsenceOfViewWithElement(matching: NSPredicate(format: "accessibilityIdentifer = %@", identifier))
  }

  public func waitForAbsenceOfView(withAccessibilityHint hint: String) {
    waitForAbsenceOfViewWithElement(matching: NSPredicate(format: "accessibilityHint = %@", hint))
  }
}

// MARK: - Private methods

extension KIFUITestActor {
  func tap(element: NSObject) {
    if let view = element as? UIView {
      view.tap()
    } else {
      let center = CGPoint(x: element.accessibilityFrame.origin.x + element.accessibilityFrame.size.width / 2,
                           y: element.accessibilityFrame.origin.y + element.accessibilityFrame.size.height / 2)
      tapScreen(at: center)
    }
  }
}

extension KIFUITestActor {
  public func speedUp() { keyWindow?.layer.speed = 1e2 }
  public func restoreSpeed() { keyWindow?.layer.speed = 1 }
}

extension UIWindow {
  public func view(matching matchBlock: @escaping ((UIView?) -> Bool)) -> UIView? {
    let element = accessibilityElement(matching: { (element) -> Bool in
      if let view = (element as Any?) as? UIView {
        return matchBlock(view)
      }
      return false
    })

    return (element as Any?) as! UIView?
  }
}
