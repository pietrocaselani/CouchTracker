import Foundation

public final class FileAppStateDataHolder: AppStateDataHolder {
  private let fileManager: FileManager

  public init(fileManager: FileManager = .default) {
    self.fileManager = fileManager
  }

  public func currentAppState() throws -> AppState {
    return FileAppStateDataHolder.appState()
  }

  public func save(appState: AppState) throws {
    let data = try JSONEncoder().encode(appState)

    let filePath = appStateFilePath()
    fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
  }

  public static func appState() -> AppState {
    let filePath = appStateFilePath()
    let url = URL(fileURLWithPath: filePath, isDirectory: false)

    guard let data = try? Data(contentsOf: url) else { return AppState.initialState() }

    let appState = try? JSONDecoder().decode(AppState.self, from: data)

    return appState ?? AppState.initialState()
  }
}

func appStateFilePath() -> String {
  let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
  return libraryPath.appending("/AppState.json")
}
