import CouchTrackerCore
import RxSwift
import TraktSwift

import WebKit

final class TraktLoginViewController: UIViewController, TraktLoginView {
  fileprivate let disposeBag = DisposeBag()
  // swiftlint:disable implicitly_unwrapped_optional
  private weak var webView: WKWebView!
  var presenter: TraktLoginPresenter!
  // swiftlint:enable implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()

    let webView = WKWebView(frame: view.bounds)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self
    self.webView = webView
    view.addSubview(webView)

    presenter.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    webView.navigationDelegate = nil
    super.viewWillDisappear(animated)
  }

  func loadLogin(using url: URL) {
    webView.load(URLRequest(url: url))
  }

  func showError(error _: Error) {}
}

extension TraktLoginViewController: WKNavigationDelegate {
  func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    presenter.allowedToProcess(request: navigationAction.request)
      .observeOn(MainScheduler.instance)
      .subscribe(onCompleted: {
        decisionHandler(.allow)
      }, onError: { _ in
        decisionHandler(.cancel)
      }).disposed(by: disposeBag)
  }
}
