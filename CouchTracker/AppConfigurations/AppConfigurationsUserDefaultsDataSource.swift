import TraktSwift
import RxSwift

final class AppConfigurationsUserDefaultsDataSource: AppConfigurationsDataSource {
	private static let traktUserKey = "traktUser"
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	func save(settings: Settings) throws {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(TraktDateTransformer.dateTimeTransformer.dateFormatter)

		let data = try encoder.encode(settings)
		self.userDefaults.set(data, forKey: AppConfigurationsUserDefaultsDataSource.traktUserKey)
	}

	func fetchSettings() -> Observable<Settings> {
		guard let jsonData = self.userDefaults.data(forKey: AppConfigurationsUserDefaultsDataSource.traktUserKey) else {
			return Observable.empty()
		}

		do {
			let settings = try JSONDecoder().decode(Settings.self, from: jsonData)
			return Observable.just(settings)
		} catch {
			return Observable.error(error)
		}
	}
}
