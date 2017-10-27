import Carlos
import Moya
import PiedPiper

final class MoyaFetcher<Target: TargetType>: Fetcher {
  typealias OutputType = NSData

  private let lock: ReadWriteLock = PThreadReadWriteLock()
  private var pendingRequests: [Future<OutputType>] = []
  private let provider: MoyaProvider<Target>

  init(provider: MoyaProvider<Target>) {
    self.provider = provider
  }

  func get(_ key: Target) -> Future<OutputType> {
    let promise = startRequest(target: key)

    promise.onSuccess { _ in
      self.removePendingRequests(promise)
      }.onFailure { _ in
        self.removePendingRequests(promise)
      }.onCancel {
        self.removePendingRequests(promise)
    }

    self.addPendingRequest(promise)

    return promise.future
  }

  private func startRequest(target: Target) -> Future<OutputType> {
    let promise = Promise<OutputType>()

    let cancellable = provider.request(target) { result in
      if case .success(var response) = result {
        do {
          response = try response.filterSuccessfulStatusAndRedirectCodes()
          promise.succeed(response.data as NSData)
        } catch {
          promise.fail(error)
        }
      } else if case .failure(let error) = result {
        promise.fail(error)
      }
    }

    promise.onCancel {
      cancellable.cancel()
    }

    return promise.future
  }

  private func addPendingRequest(_ request: Future<OutputType>) {
    lock.withWriteLock {
      self.pendingRequests.append(request)
    }
  }

  private func removePendingRequests(_ request: Future<OutputType>) {
    if let idx = lock.withReadLock({ self.pendingRequests.index(where: { $0 === request }) }) {
      _ = lock.withWriteLock {
        self.pendingRequests.remove(at: idx)
      }
    }
  }
}
