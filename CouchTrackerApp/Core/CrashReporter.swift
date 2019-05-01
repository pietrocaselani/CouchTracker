import Crashlytics

public enum CrashReporter {
  public static func initialize() {
    Crashlytics.start(withAPIKey: Secrets.Crashlytics.apiKey)
  }
}
