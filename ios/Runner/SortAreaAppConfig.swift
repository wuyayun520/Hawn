
//: Declare String Begin

/*: "socoay" :*/
fileprivate let showLevelUrl:String = "socoruny"

/*: "https://m. :*/
fileprivate let kLaunchKey:String = "hprivacy"
fileprivate let const_serverControlValue:[Character] = ["t","p","s",":","/","/","m","."]

/*: .com" :*/
fileprivate let dataItemName:String = ".comdecide create up track m"

/*: "1.9.1" :*/
fileprivate let showToFoundationId:String = "1.9.1"

/*: "997" :*/
fileprivate let showWillStr:String = "997"

/*: "4x7jjlf8crgg" :*/
fileprivate let appTriggerName:String = "transform state var4x7jj"
fileprivate let kLaterName:String = "scriptf"
fileprivate let userBuildData:String = "component indicator object dismiss8crgg"

/*: "22jwxh" :*/
fileprivate let noti_triggerMsg:[Character] = ["2"]
fileprivate let data_mortalLargeId:String = "media body process copy name2jwxh"

/*: "CFBundleShortVersionString" :*/
fileprivate let kWillMsg:[Character] = ["C","F","B","u","n","d","l","e","S"]
fileprivate let dataWithValue:String = "dismiss base mortalhortVersi"
fileprivate let main_inputUrl:[Character] = ["o","n","S","t","r","i","n","g"]

/*: "CFBundleDisplayName" :*/
fileprivate let data_stuffAdText:[Character] = ["C","F","B","u","n","d","l","e","D","i","s","p","l","a","y","N","a"]
fileprivate let user_versionStr:String = "can"

/*: "CFBundleVersion" :*/
fileprivate let noti_failureStr:[Character] = ["C","F","B","u","n","d"]
fileprivate let dataHeadMsg:String = "leVersionfield contact option"

/*: "weixin" :*/
fileprivate let notiOptionName:String = "WEIXIN"

/*: "wxwork" :*/
fileprivate let dataFullStr:String = "wxwmick"

/*: "dingtalk" :*/
fileprivate let show_revenueName:String = "dincancelta"
fileprivate let notiTrackReduceText:String = "fromk"

/*: "lark" :*/
fileprivate let user_challengeFormat:String = "contactrk"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  SortAreaAppConfig.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "socoay"
let app_upFormat = (showLevelUrl.replacingOccurrences(of: "run", with: "a"))
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let mainCurrencyUrl = (kLaunchKey.replacingOccurrences(of: "privacy", with: "t") + String(const_serverControlValue)) + "\(app_upFormat)" + (String(dataItemName.prefix(4)))
/// 网络版本号
//: let AppNetVersion = "1.9.1"
let userInsideId = (showToFoundationId.capitalized)
/// 包ID
//: let PackageID = "997"
let userMergeContent = (showWillStr.capitalized)
/// Adjust
//: let AdjustKey = "4x7jjlf8crgg"
let dataProgressId = (String(appTriggerName.suffix(5)) + kLaterName.replacingOccurrences(of: "script", with: "l") + String(userBuildData.suffix(5)))
//: let AdInstallToken = "22jwxh"
let userAdjustPlatformData = (String(noti_triggerMsg) + String(data_mortalLargeId.suffix(5)))

//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let show_foundMsg = Bundle.main.infoDictionary![(String(kWillMsg) + String(dataWithValue.suffix(9)) + String(main_inputUrl))] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let show_modeValue = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let data_stuffMsg = Bundle.main.infoDictionary![(String(data_stuffAdText) + user_versionStr.replacingOccurrences(of: "can", with: "me"))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let dataFutureMsg = Bundle.main.infoDictionary![(String(noti_failureStr) + String(dataHeadMsg.prefix(9)))] as! String

//: class AppConfig: NSObject {
class SortAreaAppConfig: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func third() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
            //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func showWindow() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
            //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func substance() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = SortAreaAppConfig.showWindow()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return viewOccurrentUser(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func viewOccurrentUser(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return viewOccurrentUser(presentVC)
            //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return viewOccurrentUser(selectVC)
            }
            //: return nil
            return nil
            //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return viewOccurrentUser(naiVC.visibleViewController)
            //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device

//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.doing()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return "en"
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(dataProgressId) {
            //: return value
            return value
            //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: dataProgressId)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.handCenter((notiOptionName.lowercased())) {
            //: appsArr.append("weixin")
            appsArr.append((notiOptionName.lowercased()))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.handCenter((dataFullStr.replacingOccurrences(of: "mic", with: "or"))) {
            //: appsArr.append("wxwork")
            appsArr.append((dataFullStr.replacingOccurrences(of: "mic", with: "or")))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.handCenter((show_revenueName.replacingOccurrences(of: "cancel", with: "g") + notiTrackReduceText.replacingOccurrences(of: "from", with: "l"))) {
            //: appsArr.append("dingtalk")
            appsArr.append((show_revenueName.replacingOccurrences(of: "cancel", with: "g") + notiTrackReduceText.replacingOccurrences(of: "from", with: "l")))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.handCenter((user_challengeFormat.replacingOccurrences(of: "contact", with: "la"))) {
            //: appsArr.append("lark")
            appsArr.append((user_challengeFormat.replacingOccurrences(of: "contact", with: "la")))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func handCenter(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func doing() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? "en"
    }
}
