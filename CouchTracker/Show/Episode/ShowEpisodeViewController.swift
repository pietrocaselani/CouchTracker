import UIKit
import Kingfisher
import RxCocoa
import RxSwift

final class ShowEpisodeViewController: UIViewController, ShowEpisodeView {
  var presenter: ShowEpisodePresenter!

  private let disposeBag = DisposeBag()

	@IBOutlet weak var screenshotImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var watchedLabel: UILabel!
	@IBOutlet weak var watchedSwich: UISwitch!

	override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else { fatalError("view loaded without presenter") }

    watchedSwich.isOn = false

    watchedSwich.rx.isOn.changed.asDriver().drive(onNext: { [unowned self] _ in
      self.presenter.handleWatch()
    }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  func showEmptyView() {
    print("Nothing to show here!")
  }

  func showEpisodeImage(with url: URL) {
    screenshotImageView.kf.setImage(with: url)
  }

  func show(viewModel: ShowEpisodeViewModel) {
    titleLabel.text = viewModel.title
    numberLabel.text = viewModel.number
    dateLabel.text = viewModel.date
    watchedSwich.isOn = viewModel.watched
  }
}
