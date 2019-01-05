import Cartography

public final class SearchView: View {
  public let collectionView: UICollectionView
  public let emptyView = DefaultEmptyView()

  public let searchBar: UISearchBar = {
    let searchBar = UISearchBar(frame: CGRect.zero)
    searchBar.isUserInteractionEnabled = true
    searchBar.barTintColor = Colors.NavigationBar.barTintColor
    return searchBar
  }()

  private lazy var stackView: UIStackView = {
    let subviews = [searchBar, collectionView]
    let stackView = UIStackView(arrangedSubviews: subviews)

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing

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
  }

  public override func installConstraints() {
    constrain(stackView, emptyView, searchBar) { stack, empty, search in
      /*
       CT-TODO Fix this + 43
       Without this constant, the search bar appears behind the top bar
       */
      search.top == search.superview!.top + 43
      search.width == search.superview!.width

      stack.size == stack.superview!.size
      stack.top == stack.superview!.top
      stack.bottom == stack.superview!.bottom
      stack.left == stack.superview!.left
      stack.right == stack.superview!.right

      empty.center == empty.superview!.center
    }
  }
}
