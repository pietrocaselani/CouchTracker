import Foundation

final class ThreadWithRunLoop: Thread {
  // swiftlint:disable implicitly_unwrapped_optional
  var runLoop: RunLoop!

  override func main() {
    runLoop = RunLoop.current
    runLoop.add(Port(), forMode: .common)
    runLoop.run()
  }
}
