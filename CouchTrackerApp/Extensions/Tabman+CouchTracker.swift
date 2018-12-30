import Tabman

protocol TMBarCouchTracker {}

extension TMBarCouchTracker {
  func defaultCTBar() -> TMBar.ButtonBar {
    let bar = TMBar.ButtonBar()

    bar.backgroundView.style = .flat(color: Colors.TopBar.backgroundColor)
    bar.indicator.tintColor = Colors.TopBar.indicatorColor
    bar.indicator.weight = .light
    bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    bar.buttons.customize { button in
      button.selectedTintColor = Colors.TopBar.tabSelectedTintColor
      button.tintColor = Colors.TopBar.tabTintColor
      button.font = button.font.withSize(UIFont.systemFontSize)
      button.selectedFont = button.selectedFont?.withSize(UIFont.systemFontSize)
    }

    return bar
  }
}
