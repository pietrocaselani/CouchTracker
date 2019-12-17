import Foundation

final class ThreadWithRunLoop: Thread {
  let runLoop = RunLoop.current

  override func main() {
    runLoop.add(Port(), forMode: .common)
    runLoop.run()
  }
}
