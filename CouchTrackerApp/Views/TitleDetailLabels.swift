import SnapKit

public final class TitleDetailLabels: View {
  public let titleLabel = UILabel()
  public let detailLabel = UILabel()
  private let stackView = UIStackView()

  public func setText(title: String, detail: String) {
    titleLabel.text = title
    detailLabel.text = detail
  }

  public override func initialize() {
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(detailLabel)

    titleLabel.textColor = Colors.Text.primaryTextColor
    detailLabel.textColor = Colors.Text.secondaryTextColor

    titleLabel.font = Fonts.secondaryText
    detailLabel.font = Fonts.secondaryText
    detailLabel.numberOfLines = 0

    titleLabel.setContentHuggingPriority(.required, for: .horizontal)

    addSubview(stackView)
  }

  public override func installConstraints() {
    stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

    detailLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(2)
    }
  }
}
