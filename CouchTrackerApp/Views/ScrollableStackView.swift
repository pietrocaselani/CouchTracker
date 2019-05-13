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
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.snp.edges)
      $0.width.equalTo(self.snp.width)
    }
  }
}
