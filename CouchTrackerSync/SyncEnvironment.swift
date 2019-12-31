import TraktSwift
import RxSwift

struct SyncEnvironment {
  var networkScheduler: SchedulerType
  var trakt: TraktProvider
}

extension SyncEnvironment {
  static let live: SyncEnvironment = {
    let networkQueue = DispatchQueue(label: "NetworkQueue", qos: .default)

    let traktBuilder = TraktBuilder {
      $0.clientId = Secrets.Trakt.clientId
      $0.clientSecret = Secrets.Trakt.clientSecret
      $0.redirectURL = Secrets.Trakt.redirectURL
      $0.callbackQueue = networkQueue
    }

    return SyncEnvironment(
      networkScheduler: ConcurrentDispatchQueueScheduler(queue: networkQueue),
      trakt: Trakt(builder: traktBuilder)
    )
  }()
}

#if DEBUG
var Current = SyncEnvironment.live
#else
let Current = SyncEnvironment.live
#endif
