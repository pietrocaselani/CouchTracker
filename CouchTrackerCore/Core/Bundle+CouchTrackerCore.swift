import Foundation

extension Bundle {
  public static let couchTrackerCore = Bundle(identifier: "io.github.pietrocaselani.CouchTrackerCore")! // swiftlint:disable force_unwrapping
}

public func couchTrackerCoreLocalizable(key: String,
                                        bundleProvider: BundleProvider = DefaultBundleProvider.instance,
                                        tableName: String = "CouchTrackerCore") -> String {
  return NSLocalizedString(key, tableName: tableName, bundle: bundleProvider.bundle, comment: "\(key) not found")
}

public func couchTrackerCoreLocalizable(key: String,
                                        bundleProvider: BundleProvider = DefaultBundleProvider.instance,
                                        tableName: String = "CouchTrackerCore",
                                        _ args: CVarArg...) -> String {
  let string = couchTrackerCoreLocalizable(key: key, bundleProvider: bundleProvider, tableName: tableName)
  return withVaList(args) { NSString(format: string, arguments: $0) as String }
}
