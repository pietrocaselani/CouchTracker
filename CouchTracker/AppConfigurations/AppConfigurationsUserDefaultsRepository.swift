import Foundation
import TraktSwift
import RxSwift
import Moya

final class AppConfigurationsUserDefaultsRepository: AppConfigurationsRepository {
	private static let localeKey = "preferredLocale"
	private static let traktUserKey = "traktUser"
	private let userDefaults: UserDefaults
	private let trakt: TraktProvider

	init(userDefaults: UserDefaults, traktProvider: TraktProvider) {
		self.userDefaults = userDefaults
		self.trakt = traktProvider
	}

	var preferredLocales: [Locale] {
		return Locale.preferredLanguages.map { Locale(identifier: $0) }
	}

	var preferredContentLocale: Locale {
		get {
			let localeIdentifier = userDefaults.string(forKey: AppConfigurationsUserDefaultsRepository.localeKey)
			return localeIdentifier.flatMap { Locale(identifier: $0) } ?? Locale.current
		}
		set {
			userDefaults.set(newValue.identifier, forKey: AppConfigurationsUserDefaultsRepository.localeKey)
			userDefaults.synchronize()
		}
	}

	func fetchLoggedUser(forced: Bool) -> Observable<User> {
		let apiObservable = fetchSettingsFromAPI().map { $0.user }

		guard !forced else { return apiObservable }

		let cacheObservable = fetchSettingFromLocalStorage().map { $0.user }

		return cacheObservable.catchError { _ in apiObservable }
				.ifEmpty(switchTo: apiObservable)
	}

	private func fetchSettingFromLocalStorage() -> Observable<Settings> {
		guard let jsonData = self.userDefaults.data(forKey: AppConfigurationsUserDefaultsRepository.traktUserKey) else {
			return Observable.empty()
		}

		do {
			let settings = try JSONDecoder().decode(Settings.self, from: jsonData)
			return Observable.just(settings)
		} catch {
			return Observable.error(error)
		}
	}

	private func fetchSettingsFromAPI() -> Observable<Settings> {
		return trakt.users.rx.request(.settings)
				.filterSuccessfulStatusCodes()
				.map(Settings.self)
				.do(onSuccess: { [unowned self] settings in
					let encoder = JSONEncoder()
					encoder.dateEncodingStrategy = .formatted(TraktDateTransformer.dateTimeTransformer.dateFormatter)

					let data = try encoder.encode(settings)
					self.userDefaults.set(data, forKey: AppConfigurationsUserDefaultsRepository.traktUserKey)
				})
				.asObservable()
	}
}
