import SnapKit

public final class ScrollableStackView: View {
  public let stackView: UIStackView
  public let scrollView: UIScrollView

  public init(subviews: [UIView]) {
    stackView = UIStackView(arrangedSubviews: subviews)
    scrollView = UIScrollView()
    super.init()
  }

  public required init() {
    stackView = UIStackView()
    scrollView = UIScrollView()
    super.init()
  }

  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func initialize() {
    scrollView.addSubview(stackView)

    addSubview(scrollView)
  }

  public override func installConstraints() {
    scrollView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.width)
      $0.height.equalTo(self.snp.height)
    }

    stackView.snp.makeConstraints {
      $0.leading.equalTo(scrollView.snp.leading)
      $0.trailing.equalTo(scrollView.snp.trailing)
      $0.top.equalTo(scrollView.snp.top)
      $0.bottom.equalTo(scrollView.snp.bottom)
      $0.width.equalTo(self.snp.width)
      $0.height.equalTo(self.snp.height)
    }
  }
}
