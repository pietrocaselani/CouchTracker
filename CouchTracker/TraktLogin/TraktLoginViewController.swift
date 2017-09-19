/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import UIKit
import WebKit
import RxSwift
import TraktSwift

final class TraktLoginViewController: UIViewController, TraktLoginView {
  fileprivate let disposeBag = DisposeBag()
  private weak var webView: WKWebView!
  var presenter: TraktLoginPresenter!
  var policyDecider: TraktLoginPolicyDecider!

  override func viewDidLoad() {
    super.viewDidLoad()

    webView = WKWebView(frame: view.bounds)
    webView.navigationDelegate = self
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

    policyDecider.allowedToProceed(with: navigationAction.request).subscribe(onNext: { _ in
      decisionHandler(.allow)
    }, onError: { error in
      print(error)
      decisionHandler(.cancel)
    }).disposed(by: disposeBag)
  }
}
