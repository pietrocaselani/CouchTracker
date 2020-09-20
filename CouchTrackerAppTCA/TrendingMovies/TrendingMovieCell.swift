import UIKit

final class TrendingMovieCell: UICollectionViewCell {
    struct ViewModel: Hashable {
        let title: String
        let imageURL: URL
    }

    static let cellIdentifier = "TrendingMovieCell"

    private let posterImageView = UIImageView()

    private let titleLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 2
      label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
      label.textColor = Colors.Text.primaryTextColor
      return label
    }()

    private lazy var stackView: UIStackView = {
      let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel])

      stackView.axis = .vertical
      stackView.distribution = UIStackView.Distribution.equalSpacing

      return stackView
    }()

    func apply(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
}
