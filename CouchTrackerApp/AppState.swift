import TraktSwift
import CouchTrackerSync

struct UserSessionState: Hashable {
    let user: User
}

struct ShowsProgressState {
    let shows: [Show]
}
