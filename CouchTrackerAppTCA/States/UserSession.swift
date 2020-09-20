import TraktSwift
import CouchTrackerSync

struct UserSessionState: Hashable {
    typealias ShowInProgress = CouchTrackerSync.Show

    var user: User
    var showsInProgress: [ShowInProgress]
}
