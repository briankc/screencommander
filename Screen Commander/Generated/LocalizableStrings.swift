// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Screen Commander was unable to blank the display due to the following error:
  /// 
  ///  “%@”
  internal static func blankingErrorAlertMessage(_ p1: Any) -> String {
    return L10n.tr("Localizable", "blanking_error.alert.message", String(describing: p1))
  }
  /// Unable to blank display
  internal static let blankingErrorAlertTitle = L10n.tr("Localizable", "blanking_error.alert.title")
  /// disable
  internal static let launchAtLoginErrorAlertDisable = L10n.tr("Localizable", "launchAtLogin_error.alert.disable")
  /// enable
  internal static let launchAtLoginErrorAlertEnable = L10n.tr("Localizable", "launchAtLogin_error.alert.enable")
  /// Screen Commander was unable to %@ itself as a login item with the system due to an unknown error.
  internal static func launchAtLoginErrorAlertMessage(_ p1: Any) -> String {
    return L10n.tr("Localizable", "launchAtLogin_error.alert.message", String(describing: p1))
  }
  /// register
  internal static let launchAtLoginErrorAlertRegister = L10n.tr("Localizable", "launchAtLogin_error.alert.register")
  /// Unable to %@ login item
  internal static func launchAtLoginErrorAlertTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "launchAtLogin_error.alert.title", String(describing: p1))
  }
  /// unregister
  internal static let launchAtLoginErrorAlertUnregister = L10n.tr("Localizable", "launchAtLogin_error.alert.unregister")
  /// You can always change this setting later by opening Screen Commander's preferences in the menubar.
  internal static let launchAtLoginPromptAlertMessage = L10n.tr("Localizable", "launchAtLogin_prompt.alert.message")
  /// Launch Automatically At Login
  internal static let launchAtLoginPromptAlertPrimaryButton = L10n.tr("Localizable", "launchAtLogin_prompt.alert.primaryButton")
  /// Don't Launch At Login
  internal static let launchAtLoginPromptAlertSecondaryButton = L10n.tr("Localizable", "launchAtLogin_prompt.alert.secondaryButton")
  /// Should Screen Commander launch automatically and become available in your Mac's menubar when you log in?
  internal static let launchAtLoginPromptAlertTitle = L10n.tr("Localizable", "launchAtLogin_prompt.alert.title")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
