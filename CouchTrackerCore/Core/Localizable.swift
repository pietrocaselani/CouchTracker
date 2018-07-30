import Foundation

public protocol Localizable {
    var localized: String { get }
    var bundle: Bundle { get }

    func localized(_ args: CVarArg...) -> String
}
