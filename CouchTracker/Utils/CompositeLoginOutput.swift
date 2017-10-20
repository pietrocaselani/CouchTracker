final class CompositeLoginOutput: TraktLoginOutput {
  private let outputs: [TraktLoginOutput]

  init(outputs: [TraktLoginOutput]) {
    self.outputs = outputs
  }

  func loggedInSuccessfully() {
    outputs.forEach { $0.loggedInSuccessfully() }
  }

  func logInFail(message: String) {
    outputs.forEach { $0.logInFail(message: message) }
  }
}
