import CouchTrackerCore
import Moya
import TMDBSwift
import TraktSwift
import TVDBSwift

final class Environment {
    static let instance = Environment()
    let trakt: TraktProvider
    let tmdb: TMDBProvider
    let tvdb: TVDBProvider
    let loginObservable: TraktLoginObservable
    let defaultOutput: TraktLoginOutput
    let schedulers: Schedulers
    let realmProvider: RealmProvider
    let buildConfig: BuildConfig
    let appConfigurationsObservable: AppConfigurationsObservable
    let appConfigurationsOutput: AppConfigurationsOutput

    var currentAppState: AppConfigurationsState {
        let userDefaults = UserDefaults.standard
        let loginState = AppConfigurationsUserDefaultsDataSource.currentLoginValue(userDefaults)
        let hideSpecials = AppConfigurationsUserDefaultsDataSource.currentHideSpecialValue(userDefaults)
        return AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
    }

    private init() {
        let schedulers = DefaultSchedulers()

        let debug: Bool

        var plugins = [PluginType]()

        #if DEBUG
            debug = true

            plugins.append(NetworkLoggerPlugin())

            let traktClientId = Secrets.Trakt.clientId.isEmpty
            let tmdbAPIKey = Secrets.TMDB.apiKey.isEmpty
            let tvdbAPIKey = Secrets.TVDB.apiKey.isEmpty

            if traktClientId || tmdbAPIKey || tvdbAPIKey {
                Swift.fatalError("One or more API keys are empty. Check the class Secrets.swift")
            }
        #else
            debug = false
        #endif

        var traktPlugins = plugins
        traktPlugins.append(NoCacheMoyaPlugin())

        buildConfig = DefaultBuildConfig(debug: debug)

        let traktBuilder = TraktBuilder {
            $0.clientId = Secrets.Trakt.clientId
            $0.clientSecret = Secrets.Trakt.clientSecret
            $0.redirectURL = Secrets.Trakt.redirectURL
            $0.callbackQueue = schedulers.networkQueue
            $0.plugins = traktPlugins
        }

        let tvdbBuilder = TVDBBuilder {
            $0.apiKey = Secrets.TVDB.apiKey
            $0.callbackQueue = schedulers.networkQueue
            $0.plugins = plugins
        }

        let trakt = Trakt(builder: traktBuilder)

        self.trakt = trakt
        tmdb = TMDB(apiKey: Secrets.TMDB.apiKey)
        tvdb = TVDB(builder: tvdbBuilder)

        self.schedulers = schedulers

        let traktLoginStore = TraktLoginStore(trakt: trakt)

        loginObservable = traktLoginStore
        defaultOutput = traktLoginStore.loginOutput

        realmProvider = DefaultRealmProvider(buildConfig: buildConfig)

        let appConfigurationsStore = AppConfigurationsStore()

        appConfigurationsOutput = appConfigurationsStore
        appConfigurationsObservable = appConfigurationsStore
    }
}
