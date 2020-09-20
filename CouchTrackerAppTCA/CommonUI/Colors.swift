import UIKit

enum Colors {
  enum View {
    static let background = UIColor.ctdarkerBunker
  }

  enum NavigationBar {
    static let barTintColor = UIColor.ctdarkerBunker
    static let tintColor = UIColor.white
    static let titleTextColor = UIColor.ctzircon
  }

  enum TopBar {
    static let backgroundColor = UIColor.ctblack
    static let indicatorColor = UIColor.ctzircon
    static let tabSelectedTintColor = UIColor.ctzircon
    static let tabTintColor = UIColor.white
  }

  enum TabBar {
    static let backgroundColor = UIColor.ctjaguar
    static let tintColor = UIColor.ctzircon
  }

  enum Cell {
    static let foregroundColor = UIColor.ctconcord
    static let backgroundColor = UIColor.ctdarkerBunker
  }

  enum Text {
    static let primaryTextColor = UIColor.white
    static let secondaryTextColor = UIColor.lightGray
  }
}

/**
 CouchTracker Palette
 **/

extension UIColor {
  /**
   name: Darker Bunker
   red: 0.1764705926
   green: 0.1764705926
   blue: 0.1764705926
   alpha: 1.0000000000
   hex: #2D2D2D
   **/

  static var ctdarkerBunker: UIColor {
    UIColor(red: 0.1764705926, green: 0.1764705926, blue: 0.1764705926, alpha: 1.0000000000)
  }

  /**
   name: Bunker
   red: 0.1725489944
   green: 0.1725489944
   blue: 0.1725489944
   alpha: 1.0000000000
   hex: #2C2C2C
   **/

  static var ctbunker: UIColor {
    UIColor(red: 0.1725489944, green: 0.1725489944, blue: 0.1725489944, alpha: 1.0000000000)
  }

  /**
   name: Zircon
   red: 0.8823528886
   green: 0.8823528886
   blue: 0.8823528886
   alpha: 1.0000000000
   hex: #E1E1E1
   **/

  static var ctzircon: UIColor {
    UIColor(red: 0.8823528886, green: 0.8823528886, blue: 0.8823528886, alpha: 1.0000000000)
  }

  /**
   name: Black
   red: 0.1333332956
   green: 0.1333332956
   blue: 0.1333332956
   alpha: 1.0000000000
   hex: #222222
   **/

  static var ctblack: UIColor {
    UIColor(red: 0.1333332956, green: 0.1333332956, blue: 0.1333332956, alpha: 1.0000000000)
  }

  /**
   name: Jaguar
   red: 0.1647059023
   green: 0.1647059023
   blue: 0.1647059023
   alpha: 1.0000000000
   hex: #2A2A2A
   **/

  static var ctjaguar: UIColor {
    UIColor(red: 0.1647059023, green: 0.1647059023, blue: 0.1647059023, alpha: 1.0000000000)
  }

  /**
   name: Concord
   red: 0.4862745106
   green: 0.4862745106
   blue: 0.4862745106
   alpha: 1.0000000000
   hex: #7C7C7C
   **/

  static var ctconcord: UIColor {
    UIColor(red: 0.4862745106, green: 0.4862745106, blue: 0.4862745106, alpha: 1.0000000000)
  }

  /**
   name: Fog
   red: 0.8274509907
   green: 0.7960783839
   blue: 0.8941177130
   alpha: 1.0000000000
   hex: #D3CBE4
   **/

  static var ctfog: UIColor {
    UIColor(red: 0.8274509907, green: 0.7960783839, blue: 0.8941177130, alpha: 1.0000000000)
  }
}
