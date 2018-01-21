import Tabman

extension TabmanBar.Config {

  func defaultCTAppearance() {
    self.style = .scrollingButtonBar
    self.appearance = TabmanBar.Appearance({ (appearance) in
      appearance.style.background = .solid(color: UIColor.ctdarkerBunker)
      appearance.state.selectedColor = UIColor.white
      appearance.state.color = UIColor.lightGray
      appearance.indicator.color = UIColor.ctfog
    })
  }

}
