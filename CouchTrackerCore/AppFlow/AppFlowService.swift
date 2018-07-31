public final class AppFlowService: AppFlowInteractor {
  private let repository: AppFlowRepository

  public var lastSelectedTab: Int {
    get {
      return repository.lastSelectedTab
    }
    set {
      repository.lastSelectedTab = newValue
    }
  }

  public init(repository: AppFlowRepository) {
    self.repository = repository
  }
}
