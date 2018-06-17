import UIKit
import WebKit
import RxSwift
import TraktSwift
import CouchTrackerCore

final class TraktLoginViewController: UIViewController, TraktLoginView {
	fileprivate let disposeBag = DisposeBag()
	private weak var webView: WKWebView!
	var presenter: TraktLoginPresenter!
	var policyDecider: TraktLoginPolicyDecider!

	override func viewDidLoad() {
		super.viewDidLoad()

		let webView = WKWebView(frame: view.bounds)
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.navigationDelegate = self
		self.webView = webView
		view.addSubview(webView)

		presenter.viewDidLoad()
	}

	func loadLogin(using url: URL) {
		webView.load(URLRequest(url: url))
	}
}

extension TraktLoginViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
														decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

		policyDecider.allowedToProceed(with: navigationAction.request).subscribe(onSuccess: { _ in
			decisionHandler(.allow)
		}, onError: { _ in
			decisionHandler(.cancel)
		}).disposed(by: disposeBag)
	}
}
