import Foundation

final class ThreadWithRunLoop: Thread {
    var runLoop: RunLoop!

    override func main() {
        runLoop = RunLoop.current
        runLoop.add(Port(), forMode: .commonModes)
        runLoop.run()
    }
}
