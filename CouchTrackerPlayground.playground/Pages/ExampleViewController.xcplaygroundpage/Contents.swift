import PlaygroundSupport
import UIKit

import CouchTrackerApp
import CouchTrackerCore
import TraktSwift
import TMDBSwift
import TVDBSwift
import Kingfisher
import SnapKit
import RxSwift

class ExampleViewController: UIViewController {
    private var exampleView: ExampleView {
        guard let v = self.view as? ExampleView else {
            Swift.fatalError("self.view should be an instance of ExampleView")
        }
        return v
    }

    override func loadView() {
        view = ExampleView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        exampleView.button.setTitle("Click me", for: .normal)
        exampleView.didTouch = {
            print("Clicked!")
        }
    }
}

class ExampleView: CouchTrackerApp.View {
    var didTouch: (() -> Void)?

    let button: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.system)
        b.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        return b
    }()

    override func initialize() {
        backgroundColor = Colors.View.background
        addSubview(button)
    }

    override func installConstraints() {
        button.snp.makeConstraints { $0.center.equalToSuperview() }
    }

    @objc private func didTouchUpInside() {
        didTouch?()
    }
}

PlaygroundPage.current.liveView = ExampleViewController()
