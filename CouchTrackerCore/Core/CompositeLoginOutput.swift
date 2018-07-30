public final class CompositeLoginOutput: TraktLoginOutput {
    private let outputs: [TraktLoginOutput]

    public init(outputs: [TraktLoginOutput]) {
        self.outputs = outputs
    }

    public func loggedInSuccessfully() {
        outputs.forEach { $0.loggedInSuccessfully() }
    }

    public func logInFail(message: String) {
        outputs.forEach { $0.logInFail(message: message) }
    }
}
