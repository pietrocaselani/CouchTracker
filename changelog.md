# 0.0.1 (1)
Pietro Caselani (348):
* Remove Trakt target and use as Pod
* Remove Trakt target and use as Pod
* Merge branch 'TraktAsPod'
* Remove TMDB targets and use as a Pod
* Update Trakt version
* Add files for tests
* Remove TVDB targets and use as Pod
* Fix all compilation errors on production code
* Testing passing, but some are failing
* Disable coverage data
* Fix AppConfigurationsPresenterTest tests; 20 failing
* App works again :raised_hands:
* Some adjustments; Remove cache from Trakt requests
* Uses Trakt as builder
* Fix login update view on background thread
* Add Travis-CI files
* Add swift-version and sonar-properties files
* Add fastlane and slather
* Configure fastlane
* Fix API provider mocks
* Fixing some tests
* Disable cache asserts for now. We will deal with this later
* Remove unused pod
* Fix swiftlint warnings
* Remove sleep calls on tests
* Add build badge
* Use git instated path for some pods
* Change from :path to :git
* Remove unused pod
* Define source
* Update cocoapods repository before install
* Disable code signing for tests
* Update code to new version of Trakt, TVDB and TMDB
* Remove email notifications
* Add instructions to update the app
* Implementing tabs on Shows module
* Add default tabman configuration for CouchTracker
* Update navigation item when page changes
* Presenting Trakt login alert
* Make Settings view into a new tab
* Refactoring Trending module to deal with movies and show independently
* Update Tabman pod
* Update tabman's color
* Add Trending shows on Shows tab
* Create MoviesManage module
* Tests are compiling again
* Add missing files on test targets
* Code cleanup; Remove some comments
* Add tests for NoCacheMoyaPlugin
* Rename `UglyMemoryCache` to `SimpleMemoryCache`
* Fix indentation and code format
* Uses `SimpleMemoryCache`
* Conforms to ShowsManagerDataSource and code format
* Add tests for TrendingCacheRepository
* Inject scheduler on APISearchRepository
* Clean up project Remove unused files and ArcTouch related things
* Create and inject Schedulers protocol
* Move mock function to some classes
* Add tests for AppConfigurationUserDefaultsRepository
* Create test for ImageCachedRepository
* Add test to fetch movie images with specific size
* Add test for fetch tv show images
* Add test to fetch episode image from TMDB
* Fix tvdb and tmdb ids
* Add tests for ShowProgressService
* Swiftlint autocorrect
* Update Readme.md
* Add tvdb_episodes.json on TVDB test bundle
* Create another layer to interact with UserDefaults
* Create tab to display watched show options
* Add RxRealm
* Add realm entities for show progress
* Add schedulers and providers for Realm
* Move all progress show logic to one place
* Rename ShowsProgressDataSource to ShowsProgressViewDataSource
* Everything to keep Realm away from Main thread
* Fix Realm ignored properties
* Rename dataSource parameter to viewDataSource
* Tests for ShowsProgress interactor and repository fixed
* WIP - Testing ShowsProgressRealmDataSource
* Observing and reacting to Realm changes
* Prevent view from flick using disting until changes
* Auto refresh progress shows when watch an episode
* Add BuildConfig protocol and missing files
* Swiftlint autocorrect
* Tests ok again
* Creating tests for ShowProgressAPIRepository
* More tests for ShowProgressAPIRepository
* Add Codecov
* Remove unused pod and update iOS plataform to 10.0
* Remove unused import
* Remove RxBlocking from project
* Add codecov and twitter badges
* Using new build system
* Changing some Observables to Singles
* Added tests for ShowEpisodeService
* Merge pull request #122 from pietrocaselani/MoreTests
* Add SeasonEntity and create folder EntityMappers
* Rename entity mappers
* Fetching and saving seasons and episodes
* Add configuration to hide/show special episodes
* Tests fixed
* More tests for ShowsProgressAPIRepository
* Add test for AppConfigurationsUserDefaultsDataSource
* Add tests for AppConfigurationsStore
* More tests for AppConfigurationsDefaultRepository
* More tests for AppConfigurationsPresenter
* More tests for AppConfigurationsService
* Remove unnecessary error handling code
* Add app config to hide specials episodes and more tests
* Merge pull request #123 from pietrocaselani/SpecialConfig
* Add tests for ShowProgressSort
* Merge pull request #124 from pietrocaselani/ShowProgressSortTest
* Remove unused Moya plugins
* Trying to fix sonar metrics
* Add EditorConfig; Update all swift files
* Merge pull request #125 from pietrocaselani/EditorConfig
* Clean up workspace
* Add codecov config
* Fix codecov yaml syntax
* Separate ShowEpisodeRepository into data source and network
* Add test addToHistory on ShowEpisodeAPIRepository
* Add test removeFromHistory on ShowEpisodeAPIRepository
* Add test on ShowEpisodeAPIRepository handling app state
* Add success test cases for ShowEpisodeAPIRepository
* Add tests for ShowsProgressMoyaNetwork
* Merge pull request #127 from pietrocaselani/ShowEpisodeTests
* Add CouchTrackerCore framework
* Remove unused files
* Remove unused files
* Update fastlane version and test scheme
* Update Fastlane readme
* Make things public to work as framework
* Move files to correct folder; Delete unused targets
* Rename all `iOS` related things on Core module to `Default`
* Fix folders on sonar, swiftlint and codecov
* Disable code signing for CouchTrackerCore(iOS)
* Update readme
* Add missing plist files
* Disable Code Signing for CouchTrackerCoreTests
* Merge pull request #128 from pietrocaselani/FixCouchTrackerTests
* Fix Swiftlint warnings
* Change ImageRepository to return Maybe instead of Single
* Tests for ShowProgressCellService
* Add more tests for ShowsProgressService
* Add tests for ShowProgressCellDefaultPresenter
* Uses pietrocaselani's fork of RxSwift
* Merge pull request #129 from pietrocaselani/ProgressCellTests
* More tests for ShowEpisode module
* Valid API keys when aplication starts
* Fix memory leak
* Add tests for ShowEpisodeMoyaNetwork
* Add tests for ShowEpisodeRealmDataSource
* Merge pull request #130 from pietrocaselani/ShowEpisodeTests
* Fix dyld: Library not loaded CouchTrackerCore when running on device
* Refactoring setup method
* More tests on ShowsProgressPresenter, handling translation
* More tests for ShowsProgressDefaultPresenter
* Merge pull request #131 from pietrocaselani/ShowsProgressPresenterTests
* Open app on last selected tab
* Shows manager opens in the last selected tab
* Add tests for modules managers
* Merge pull request #132 from pietrocaselani/openOnLastTab
* Add no cache header to test somethings
* Refactoring Search module tests
* Tests for SearchAPIRepository
* We can search movies and shows again
* Add tests for SearchResultDefaultPresenter
* Add .lock files
* Merge pull request #135 from pietrocaselani/SearchAgain
* Update Fastlane and fix build
* WIP
* Add tests on ShowsProgress considering location and language
* Add tests checking the time zone
* Merge pull request #136 from pietrocaselani/fix_release_date_ptbr
* Save shows progress list state
* Filter and sort shows progress list using last configurations
* Make ShowProgressListState conform to Equatable and Hashable
* Merge pull request #139 from pietrocaselani/filter_shows_list_last_config
* Update xcodeproj to Swift 4.2
* Implementing view state on MovieDetailsPresenter
* Tests updated using ViewState and ImagesState
* Remove View and Router reference from Presenter - MovieDetails module
* Merge pull request #142 from pietrocaselani/remove_view_from_movieDetailsPresenter
* Update .travis.yml to use Xcode 9.3
* Back to Swift 4.1
* Exec bundle install before
* Add watched at property on MovieEntity
* Add watched date on MovieDetailsViewModel
* Add watched at label on movie details
* Add tests for watched and unwatched movies
* Merge pull request #143 from pietrocaselani/add_movie_to_trakt_history
* Handles watch action on MovieDetailsPresenter
* MovieDetailsInteractor handles watch action
* Remove MovieDetailsViewModel
* Change MovieDetailsRepository signature to receive movie entity
* Add or remove movie from Trakt history
* Rename file to MovieDetailsAPIRepository
* Add UISwitch to mark a movie as watched
* Add more tests on MovieDetailsDefaultPresenter
* Merge pull request #144 from pietrocaselani/mark_movie_as_watched
* Rename ShowDetails to ShowOverview; Remove ShowDetails module and presents as ShowsManager
* Merge pull request #145 from pietrocaselani/show_details_module
* Removing View reference from ShowOverviewPresenter
* ShowOverviewViewController conforms to ShowOverviewView
* Merge pull request #146 from pietrocaselani/remove_view_from_show_overview
* Remove unused files
* Create ShowEpisodeViewState struct
* Implementing ViewState on Show Episode module
* Update to Moya 11.0.2
* WIP - Adding support to Xcode 10
* Update RealmSwift
* Add test for GenreRealmEntity
* Update TraktSwift commit reference
* Merge pull request #147 from pietrocaselani/remove_view_from_show_episode
* Merge branch 'remove_view_from_show_episode'
* Update readme
* Add SwiftFormat
* Configure SwiftFormat script
* Update RealmSwift to 3.7.6
* WIP - Fetching seasons for a show
* Update setup.sh
* Update Readme.md
* WIP - Refactoring Shows Progress logic
* WIP - Refactoring Shows Progress logic Fetching seasons and genres, but still need to add error handling
* WIP - Fetching all seasons for all watched shows
* Trying to set seasons before next episode
* We are now able to get and save all seasons from watched shows
* Merge branch 'master' of github.com:pietrocaselani/CouchTracker into show_sessions
* Tests compile again!
* Tests passing but there is two disabled
* Update RxTest syntax
* First implementation of DefaultGenreSynchronizerTest
* Apply swiftformat for all tests
* Test genre synchronizer for shows
* Creating shows synchronizers
* Seasons are updated when episode is marked as watched Need to fix tests
* Simple example of how to get show updates
* Working on the tests
* Use RxTest Recorded instead of global functions
* All tests green again!
* Clone dependencies using HTTPS instead of SSH
* Update readme
* Clone dependencies into the vendor folder
* Update Xcode image on Travis to 10.1
* Merge pull request #151 from pietrocaselani/show_sessions
* Trying to fix Ruby vulnerabilities (Die nokogiri, die!)
* Change cocoapods version
* Make CocoaPods happy by setting EXPANDED_CODE_SIGN_IDENTITY
* Merge pull request #152 from pietrocaselani/trying_to_fix_ruby_vulnerabilities
* Make Moya logs no verbose
* Fix the state that app initializes
* Merge branch 'master' into fix_app_state_initialization
* Merge pull request #153 from pietrocaselani/fix_app_state_initialization
* Add option to visit the Github page
* Remove AppConfigurationOptions and only handle values
* Merge pull request #154 from pietrocaselani/button_go_to_source_code
* Moving AppConfigurations to CouchTrackerApp
* Moving AppFlow to CouchTrackerApp
* Moving Environment to CouchTrackerApp
* Moving Extensions to CouchTrackerApp
* Moving MovieDetails to CouchTrackerApp
* Moving Movies to CouchTrackerApp
* Moving everything else to CouchTrackerApp
* Move Pods to CouchTrackerApp
* Update to Swift 4.2
* Bump Tabman and R.Swift
* Bump Kingfisher and RxSwift
* Moving Assets to CouchTrackerApp
* App compiles and runs again
* Fix image load for movie and show cell
* Add CouchTrackerApp to the swiftformat script
* Fix top bar appearance
* Fix info label position
* Bump Nimble
* Merge pull request #155 from pietrocaselani/move_app_to_framework
* Merge branch 'master' of github.com:pietrocaselani/CouchTracker into fix_trakt_login_label
* Merge pull request #156 from pietrocaselani/fix_trakt_login_label
* Setup playground
* Clean up the playground
* Merge pull request #157 from pietrocaselani/trying_playgrounds
* Add Cocoapods and bundler cache
* Merge pull request #159 from pietrocaselani/travis_cache
* Update readme
* Dont update pod repository
* Fastlane was updating cocoapods repo
* We need to update the cocoapods repo
* Merge pull request #160 from pietrocaselani/testing_cache
* Finish moving MovieDetails screen from storyboard to view code
* Fix translation tests
* Fix logic to know witch image is best
* Update Swift version to 4.2
* Add back pod install and repo update
* Remove travis cache
* Trying to fix CI things
* Merge pull request #162 from pietrocaselani/mock_payground_screen
* Sets alpha to 75%
* Make all views let
* Sets content insets, this way the top bar looks a little better
* Finish moving ShowOverview to view code
* Add Localization files back to the app target
* Merge pull request #163 from pietrocaselani/show_overview_view_code
* Create a enum to standardize colors and apply to all ViewControllers
* Trying to replicate PosterCell on Playgrounds
* Refact PosterCell and Trending module
* Delete PosterCell.xib and only use the new PosterAndTitleCell
* Remove dead code
* Trying to standardize text colors
* Ops - Forgot to rename a protocol on test target
* Add flags to warn about long compile time
* Merge pull request #164 from pietrocaselani/poster_cell_refactor
* Just fixing some swiftlint and compilation warnings
* Merge pull request #165 from pietrocaselani/fixing_warnings
* Change AppFlow module to view state
* Delete AppFlow storyboard
* Merge pull request #166 from pietrocaselani/appflow_to_viewstate_no_storyboards
* Change MoviesManager module to ViewState
* Delete MoviesManager storyboard
* Merge branch 'master' of github.com:pietrocaselani/CouchTracker into moviesmanager_to_viewstate_no_storyboard
* Merge pull request #167 from pietrocaselani/moviesmanager_to_viewstate_no_storyboard
* Change ShowsManager module to ViewState
* erge branch 'master' of github.com:pietrocaselani/CouchTracker into showsmanager_to_viewstate_no_storyboard
* Delete ShowsManager storyboard
* Merge pull request #168 from pietrocaselani/showsmanager_to_viewstate_no_storyboard
* Add CouchTrackerApp folder on sonar properties
* Change ShowManager module to ViewState
* Remove unnecessary import of UIKit
* Delete ShowManager storyboard
* Delete ShowsNow storyboard
* Swiftlint autocorrect
* Merge pull request #169 from pietrocaselani/showmanager_viewcode_no_storyboard
* Finish refactoring ShowEpisodeView to ViewCode
* Merge branch 'master' into showepisode_viewcode_no_storyboard
* Merge pull request #170 from pietrocaselani/showepisode_viewcode_no_storyboard
* Move AppConfigs Observable, Output and Store to a Store folder
* Fix files reference
* Change AppConfigurations module to ViewState
* Remove AppConfigs module storyboard
* Fixing AppConfigs Presenter tests
* Merge pull request #171 from pietrocaselani/appconfigs_to_viewstate_no_storyboard
* Change Search module to view state - CouchTrackerCore ok
* Remove Search storyboard - but need to fix the SearchBar positioning
* Fix shadow image
* Merge pull request #172 from pietrocaselani/fix_shadow_showepisode
* Merge branch 'master' of github.com:pietrocaselani/CouchTracker into search_viewstate_no_storyboard
* Rataria (workaround) to show SearchBar at correct position
* Finish implementing Search module and tests
* Merge pull request #173 from pietrocaselani/search_viewstate_no_storyboard
# 0.0.1 (2) 
# 0.0.1 (1)
* Pietro Caselani (348):
* * Remove Trakt target and use as Pod
* * Remove Trakt target and use as Pod
* * Merge branch 'TraktAsPod'
* * Remove TMDB targets and use as a Pod
* * Update Trakt version
* * Add files for tests
* * Remove TVDB targets and use as Pod
* * Fix all compilation errors on production code
* * Testing passing, but some are failing
* * Disable coverage data
* * Fix AppConfigurationsPresenterTest tests; 20 failing
* * App works again :raised_hands:
* * Some adjustments; Remove cache from Trakt requests
* * Uses Trakt as builder
* * Fix login update view on background thread
* * Add Travis-CI files
* * Add swift-version and sonar-properties files
* * Add fastlane and slather
* * Configure fastlane
* * Fix API provider mocks
* * Fixing some tests
* * Disable cache asserts for now. We will deal with this later
* * Remove unused pod
* * Fix swiftlint warnings
* * Remove sleep calls on tests
* * Add build badge
* * Use git instated path for some pods
* * Change from :path to :git
* * Remove unused pod
* * Define source
* * Update cocoapods repository before install
* * Disable code signing for tests
* * Update code to new version of Trakt, TVDB and TMDB
* * Remove email notifications
* * Add instructions to update the app
* * Implementing tabs on Shows module
* * Add default tabman configuration for CouchTracker
* * Update navigation item when page changes
* * Presenting Trakt login alert
* * Make Settings view into a new tab
* * Refactoring Trending module to deal with movies and show independently
* * Update Tabman pod
* * Update tabman's color
* * Add Trending shows on Shows tab
* * Create MoviesManage module
* * Tests are compiling again
* * Add missing files on test targets
* * Code cleanup; Remove some comments
* * Add tests for NoCacheMoyaPlugin
* * Rename `UglyMemoryCache` to `SimpleMemoryCache`
* * Fix indentation and code format
* * Uses `SimpleMemoryCache`
* * Conforms to ShowsManagerDataSource and code format
* * Add tests for TrendingCacheRepository
* * Inject scheduler on APISearchRepository
* * Clean up project Remove unused files and ArcTouch related things
* * Create and inject Schedulers protocol
* * Move mock function to some classes
* * Add tests for AppConfigurationUserDefaultsRepository
* * Create test for ImageCachedRepository
* * Add test to fetch movie images with specific size
* * Add test for fetch tv show images
* * Add test to fetch episode image from TMDB
* * Fix tvdb and tmdb ids
* * Add tests for ShowProgressService
* * Swiftlint autocorrect
* * Update Readme.md
* * Add tvdb_episodes.json on TVDB test bundle
* * Create another layer to interact with UserDefaults
* * Create tab to display watched show options
* * Add RxRealm
* * Add realm entities for show progress
* * Add schedulers and providers for Realm
* * Move all progress show logic to one place
* * Rename ShowsProgressDataSource to ShowsProgressViewDataSource
* * Everything to keep Realm away from Main thread
* * Fix Realm ignored properties
* * Rename dataSource parameter to viewDataSource
* * Tests for ShowsProgress interactor and repository fixed
* * WIP - Testing ShowsProgressRealmDataSource
* * Observing and reacting to Realm changes
* * Prevent view from flick using disting until changes
* * Auto refresh progress shows when watch an episode
* * Add BuildConfig protocol and missing files
* * Swiftlint autocorrect
* * Tests ok again
* * Creating tests for ShowProgressAPIRepository
* * More tests for ShowProgressAPIRepository
* * Add Codecov
* * Remove unused pod and update iOS plataform to 10.0
* * Remove unused import
* * Remove RxBlocking from project
* * Add codecov and twitter badges
* * Using new build system
* * Changing some Observables to Singles
* * Added tests for ShowEpisodeService
* * Merge pull request #122 from pietrocaselani/MoreTests
* * Add SeasonEntity and create folder EntityMappers
* * Rename entity mappers
* * Fetching and saving seasons and episodes
* * Add configuration to hide/show special episodes
* * Tests fixed
* * More tests for ShowsProgressAPIRepository
* * Add test for AppConfigurationsUserDefaultsDataSource
* * Add tests for AppConfigurationsStore
* * More tests for AppConfigurationsDefaultRepository
* * More tests for AppConfigurationsPresenter
* * More tests for AppConfigurationsService
* * Remove unnecessary error handling code
* * Add app config to hide specials episodes and more tests
* * Merge pull request #123 from pietrocaselani/SpecialConfig
* * Add tests for ShowProgressSort
* * Merge pull request #124 from pietrocaselani/ShowProgressSortTest
* * Remove unused Moya plugins
* * Trying to fix sonar metrics
* * Add EditorConfig; Update all swift files
* * Merge pull request #125 from pietrocaselani/EditorConfig
* * Clean up workspace
* * Add codecov config
* * Fix codecov yaml syntax
* * Separate ShowEpisodeRepository into data source and network
* * Add test addToHistory on ShowEpisodeAPIRepository
* * Add test removeFromHistory on ShowEpisodeAPIRepository
* * Add test on ShowEpisodeAPIRepository handling app state
* * Add success test cases for ShowEpisodeAPIRepository
* * Add tests for ShowsProgressMoyaNetwork
* * Merge pull request #127 from pietrocaselani/ShowEpisodeTests
* * Add CouchTrackerCore framework
* * Remove unused files
* * Remove unused files
* * Update fastlane version and test scheme
* * Update Fastlane readme
* * Make things public to work as framework
* * Move files to correct folder; Delete unused targets
* * Rename all `iOS` related things on Core module to `Default`
* * Fix folders on sonar, swiftlint and codecov
* * Disable code signing for CouchTrackerCore(iOS)
* * Update readme
* * Add missing plist files
* * Disable Code Signing for CouchTrackerCoreTests
* * Merge pull request #128 from pietrocaselani/FixCouchTrackerTests
* * Fix Swiftlint warnings
* * Change ImageRepository to return Maybe instead of Single
* * Tests for ShowProgressCellService
* * Add more tests for ShowsProgressService
* * Add tests for ShowProgressCellDefaultPresenter
* * Uses pietrocaselani's fork of RxSwift
* * Merge pull request #129 from pietrocaselani/ProgressCellTests
* * More tests for ShowEpisode module
* * Valid API keys when aplication starts
* * Fix memory leak
* * Add tests for ShowEpisodeMoyaNetwork
* * Add tests for ShowEpisodeRealmDataSource
* * Merge pull request #130 from pietrocaselani/ShowEpisodeTests
* * Fix dyld: Library not loaded CouchTrackerCore when running on device
* * Refactoring setup method
* * More tests on ShowsProgressPresenter, handling translation
* * More tests for ShowsProgressDefaultPresenter
* * Merge pull request #131 from pietrocaselani/ShowsProgressPresenterTests
* * Open app on last selected tab
* * Shows manager opens in the last selected tab
* * Add tests for modules managers
* * Merge pull request #132 from pietrocaselani/openOnLastTab
* * Add no cache header to test somethings
* * Refactoring Search module tests
* * Tests for SearchAPIRepository
* * We can search movies and shows again
* * Add tests for SearchResultDefaultPresenter
* * Add .lock files
* * Merge pull request #135 from pietrocaselani/SearchAgain
* * Update Fastlane and fix build
* * WIP
* * Add tests on ShowsProgress considering location and language
* * Add tests checking the time zone
* * Merge pull request #136 from pietrocaselani/fix_release_date_ptbr
* * Save shows progress list state
* * Filter and sort shows progress list using last configurations
* * Make ShowProgressListState conform to Equatable and Hashable
* * Merge pull request #139 from pietrocaselani/filter_shows_list_last_config
* * Update xcodeproj to Swift 4.2
* * Implementing view state on MovieDetailsPresenter
* * Tests updated using ViewState and ImagesState
* * Remove View and Router reference from Presenter - MovieDetails module
* * Merge pull request #142 from pietrocaselani/remove_view_from_movieDetailsPresenter
* * Update .travis.yml to use Xcode 9.3
* * Back to Swift 4.1
* * Exec bundle install before
* * Add watched at property on MovieEntity
* * Add watched date on MovieDetailsViewModel
* * Add watched at label on movie details
* * Add tests for watched and unwatched movies
* * Merge pull request #143 from pietrocaselani/add_movie_to_trakt_history
* * Handles watch action on MovieDetailsPresenter
* * MovieDetailsInteractor handles watch action
* * Remove MovieDetailsViewModel
* * Change MovieDetailsRepository signature to receive movie entity
* * Add or remove movie from Trakt history
* * Rename file to MovieDetailsAPIRepository
* * Add UISwitch to mark a movie as watched
* * Add more tests on MovieDetailsDefaultPresenter
* * Merge pull request #144 from pietrocaselani/mark_movie_as_watched
* * Rename ShowDetails to ShowOverview; Remove ShowDetails module and presents as ShowsManager
* * Merge pull request #145 from pietrocaselani/show_details_module
* * Removing View reference from ShowOverviewPresenter
* * ShowOverviewViewController conforms to ShowOverviewView
* * Merge pull request #146 from pietrocaselani/remove_view_from_show_overview
* * Remove unused files
* * Create ShowEpisodeViewState struct
* * Implementing ViewState on Show Episode module
* * Update to Moya 11.0.2
* * WIP - Adding support to Xcode 10
* * Update RealmSwift
* * Add test for GenreRealmEntity
* * Update TraktSwift commit reference
* * Merge pull request #147 from pietrocaselani/remove_view_from_show_episode
* * Merge branch 'remove_view_from_show_episode'
* * Update readme
* * Add SwiftFormat
* * Configure SwiftFormat script
* * Update RealmSwift to 3.7.6
* * WIP - Fetching seasons for a show
* * Update setup.sh
* * Update Readme.md
* * WIP - Refactoring Shows Progress logic
* * WIP - Refactoring Shows Progress logic Fetching seasons and genres, but still need to add error handling
* * WIP - Fetching all seasons for all watched shows
* * Trying to set seasons before next episode
* * We are now able to get and save all seasons from watched shows
* * Merge branch 'master' of github.com:pietrocaselani/CouchTracker into show_sessions
* * Tests compile again!
* * Tests passing but there is two disabled
* * Update RxTest syntax
* * First implementation of DefaultGenreSynchronizerTest
* * Apply swiftformat for all tests
* * Test genre synchronizer for shows
* * Creating shows synchronizers
* * Seasons are updated when episode is marked as watched Need to fix tests
* * Simple example of how to get show updates
* * Working on the tests
* * Use RxTest Recorded instead of global functions
* * All tests green again!
* * Clone dependencies using HTTPS instead of SSH
* * Update readme
* * Clone dependencies into the vendor folder
* * Update Xcode image on Travis to 10.1
* * Merge pull request #151 from pietrocaselani/show_sessions
* * Trying to fix Ruby vulnerabilities (Die nokogiri, die!)
* * Change cocoapods version
* * Make CocoaPods happy by setting EXPANDED_CODE_SIGN_IDENTITY
* * Merge pull request #152 from pietrocaselani/trying_to_fix_ruby_vulnerabilities
* * Make Moya logs no verbose
* * Fix the state that app initializes
* * Merge branch 'master' into fix_app_state_initialization
* * Merge pull request #153 from pietrocaselani/fix_app_state_initialization
* * Add option to visit the Github page
* * Remove AppConfigurationOptions and only handle values
* * Merge pull request #154 from pietrocaselani/button_go_to_source_code
* * Moving AppConfigurations to CouchTrackerApp
* * Moving AppFlow to CouchTrackerApp
* * Moving Environment to CouchTrackerApp
* * Moving Extensions to CouchTrackerApp
* * Moving MovieDetails to CouchTrackerApp
* * Moving Movies to CouchTrackerApp
* * Moving everything else to CouchTrackerApp
* * Move Pods to CouchTrackerApp
* * Update to Swift 4.2
* * Bump Tabman and R.Swift
* * Bump Kingfisher and RxSwift
* * Moving Assets to CouchTrackerApp
* * App compiles and runs again
* * Fix image load for movie and show cell
* * Add CouchTrackerApp to the swiftformat script
* * Fix top bar appearance
* * Fix info label position
* * Bump Nimble
* * Merge pull request #155 from pietrocaselani/move_app_to_framework
* * Merge branch 'master' of github.com:pietrocaselani/CouchTracker into fix_trakt_login_label
* * Merge pull request #156 from pietrocaselani/fix_trakt_login_label
* * Setup playground
* * Clean up the playground
* * Merge pull request #157 from pietrocaselani/trying_playgrounds
* * Add Cocoapods and bundler cache
* * Merge pull request #159 from pietrocaselani/travis_cache
* * Update readme
* * Dont update pod repository
* * Fastlane was updating cocoapods repo
* * We need to update the cocoapods repo
* * Merge pull request #160 from pietrocaselani/testing_cache
* * Finish moving MovieDetails screen from storyboard to view code
* * Fix translation tests
* * Fix logic to know witch image is best
* * Update Swift version to 4.2
* * Add back pod install and repo update
* * Remove travis cache
* * Trying to fix CI things
* * Merge pull request #162 from pietrocaselani/mock_payground_screen
* * Sets alpha to 75%
* * Make all views let
* * Sets content insets, this way the top bar looks a little better
* * Finish moving ShowOverview to view code
* * Add Localization files back to the app target
* * Merge pull request #163 from pietrocaselani/show_overview_view_code
* * Create a enum to standardize colors and apply to all ViewControllers
* * Trying to replicate PosterCell on Playgrounds
* * Refact PosterCell and Trending module
* * Delete PosterCell.xib and only use the new PosterAndTitleCell
* * Remove dead code
* * Trying to standardize text colors
* * Ops - Forgot to rename a protocol on test target
* * Add flags to warn about long compile time
* * Merge pull request #164 from pietrocaselani/poster_cell_refactor
* * Just fixing some swiftlint and compilation warnings
* * Merge pull request #165 from pietrocaselani/fixing_warnings
* * Change AppFlow module to view state
* * Delete AppFlow storyboard
* * Merge pull request #166 from pietrocaselani/appflow_to_viewstate_no_storyboards
* * Change MoviesManager module to ViewState
* * Delete MoviesManager storyboard
* * Merge branch 'master' of github.com:pietrocaselani/CouchTracker into moviesmanager_to_viewstate_no_storyboard
* * Merge pull request #167 from pietrocaselani/moviesmanager_to_viewstate_no_storyboard
* * Change ShowsManager module to ViewState
* * erge branch 'master' of github.com:pietrocaselani/CouchTracker into showsmanager_to_viewstate_no_storyboard
* * Delete ShowsManager storyboard
* * Merge pull request #168 from pietrocaselani/showsmanager_to_viewstate_no_storyboard
* * Add CouchTrackerApp folder on sonar properties
* * Change ShowManager module to ViewState
* * Remove unnecessary import of UIKit
* * Delete ShowManager storyboard
* * Delete ShowsNow storyboard
* * Swiftlint autocorrect
* * Merge pull request #169 from pietrocaselani/showmanager_viewcode_no_storyboard
* * Finish refactoring ShowEpisodeView to ViewCode
* * Merge branch 'master' into showepisode_viewcode_no_storyboard
* * Merge pull request #170 from pietrocaselani/showepisode_viewcode_no_storyboard
* * Move AppConfigs Observable, Output and Store to a Store folder
* * Fix files reference
* * Change AppConfigurations module to ViewState
* * Remove AppConfigs module storyboard
* * Fixing AppConfigs Presenter tests
* * Merge pull request #171 from pietrocaselani/appconfigs_to_viewstate_no_storyboard
* * Change Search module to view state - CouchTrackerCore ok
* * Remove Search storyboard - but need to fix the SearchBar positioning
* * Fix shadow image
* * Merge pull request #172 from pietrocaselani/fix_shadow_showepisode
* * Merge branch 'master' of github.com:pietrocaselani/CouchTracker into search_viewstate_no_storyboard
* * Rataria (workaround) to show SearchBar at correct position
* * Finish implementing Search module and tests
* * Merge pull request #173 from pietrocaselani/search_viewstate_no_storyboard
