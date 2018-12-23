import Tabman

protocol TMBarCouchTracker {}

extension TMBarCouchTracker {
  func defaultCTBar() -> TMBar.ButtonBar {
    let bar = TMBar.ButtonBar()

    bar.backgroundView.style = .flat(color: .ctdarkerBunker)
    bar.indicator.tintColor = .ctfog
    bar.indicator.weight = .light
    bar.buttons.customize { button in
      button.selectedTintColor = .white
      button.tintColor = .lightGray
      button.font = button.font.withSize(UIFont.systemFontSize)
      button.selectedFont = button.selectedFont?.withSize(UIFont.systemFontSize)
    }

    return bar
  }
}
