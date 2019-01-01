import Cartography

public final class SearchView: View {
  public let searchBar = UISearchBar(frame: CGRect.zero)
  public let collectionView: UICollectionView
  public let emptyView = DefaultEmptyView()

  private lazy var stackView: UIStackView = {
    let subviews = [searchBar, collectionView]
    let stackView = UIStackView(arrangedSubviews: subviews)

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    //		stackView.spacing = spacing
    //		stackView.layoutMargins = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    //		stackView.isLayoutMarginsRelativeArrangement = true
    //		stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPoster)))

    return stackView
  }()

  init(collectionViewLayout: UICollectionViewLayout = UICollectionViewLayout.ctDefault) {
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    super.init()
  }

  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public required convenience init() {
    self.init(collectionViewLayout: UICollectionViewLayout.ctDefault)
  }

  public override func initialize() {
    addSubview(stackView)
    addSubview(emptyView)

//    searchBar.isHidden = true
//    searchBar.alpha = 0
//    emptyView.backgroundColor = .red
  }

  public override func installConstraints() {
    constrain(stackView, emptyView, searchBar) { stack, empty, search in
      search.width == search.superview!.width
      search.topMargin == search.superview!.topMargin
      search.height == 56

//      collectionView.top == search.bottom
//      collectionView.bottom == collectionView.superview!.bottom
//      collectionView.left == collectionView.superview!.left
//      collectionView.right == collectionView.superview!.right

      stack.size == stack.superview!.size
      stack.top == stack.superview!.top
      stack.bottom == stack.superview!.bottom
      stack.left == stack.superview!.left
      stack.right == stack.superview!.right

      empty.top == empty.superview!.top
      empty.width == empty.superview!.width
      empty.height == empty.superview!.height * 0.5
//      empty.centerX == empty.superview!.centerX
//      empty.center == empty.superview!.center
    }
  }
}
