import Bugsnag

public enum CrashReporter {
  public static func initialize() {
    Bugsnag.start(withApiKey: Secrets.Bugsnag.apiKey)
  }
}
