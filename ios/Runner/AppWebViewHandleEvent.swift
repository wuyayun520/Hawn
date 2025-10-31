
//: Declare String Begin

/*: "typeName" :*/
fileprivate let main_collectionTapPath:[UInt8] = [0xb0,0xbd,0xb4,0xa1,0x8a,0xa5,0xa9,0xa1]

/*: "deviceID" :*/
fileprivate let constItemName:[UInt8] = [0xc8,0xc9,0xda,0xc5,0xcf,0xc9,0xe5,0xe8]

/*: "fireBaseID" :*/
fileprivate let k_warnMsg:[UInt8] = [0x25,0x2a,0x31,0x26,0x1,0x22,0x30,0x26,0xa,0x7]

private func queryIndex(screen num: UInt8) -> UInt8 {
    return num ^ 67
}

/*: "areaISO" :*/
fileprivate let const_countMessage:[UInt8] = [0x8e,0x9f,0x92,0x8e,0x76,0x80,0x7c]

fileprivate func decideMergeService(scale num: UInt8) -> UInt8 {
    let value = Int(num) - 45
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "isProxy" :*/
fileprivate let showFailureKey:[UInt8] = [0x9d,0xa7,0x84,0xa6,0xa3,0xac,0xad]

fileprivate func adjustmentWhite(foundation num: UInt8) -> UInt8 {
    let value = Int(num) - 52
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "langCode" :*/
fileprivate let main_mediaPath:[UInt8] = [0x65,0x64,0x6f,0x43,0x67,0x6e,0x61,0x6c]

/*: "timeZone" :*/
fileprivate let show_regionValue:[UInt8] = [0x19,0xe,0x12,0xa,0xff,0x14,0x13,0xa]

fileprivate func mKind(your num: UInt8) -> UInt8 {
    let value = Int(num) - 165
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "installedApps" :*/
fileprivate let appFullText:[UInt8] = [0x73,0x70,0x70,0x41,0x64,0x65,0x6c,0x6c,0x61,0x74,0x73,0x6e,0x69]

/*: "systemUUID" :*/
fileprivate let data_installName:[UInt8] = [0x69,0x63,0x69,0x6e,0x7f,0x77,0x4f,0x4f,0x53,0x5e]

private func valueFire(flexible num: UInt8) -> UInt8 {
    return num ^ 26
}

/*: "countryCode" :*/
fileprivate let dataUpId:[UInt8] = [0x3a,0x36,0x2c,0x37,0x2d,0x2b,0x20,0x1a,0x36,0x3d,0x3c]

private func captureZone(filter num: UInt8) -> UInt8 {
    return num ^ 89
}

/*: "status" :*/
fileprivate let main_keyToMsg:[UInt8] = [0xdd,0xde,0xcb,0xde,0xdf,0xdd]

fileprivate func valueStart(element num: UInt8) -> UInt8 {
    let value = Int(num) + 150
    if value > 255 {
        return UInt8(value - 256)
    } else {
        return UInt8(value)
    }
}

/*: "isAuth" :*/
fileprivate let appChallengeValue:[UInt8] = [0x13,0x9,0x3b,0xf,0xe,0x12]

private func productShared(adjustment num: UInt8) -> UInt8 {
    return num ^ 122
}

/*: "isFirst" :*/
fileprivate let showClickTitle:[UInt8] = [0x74,0x73,0x72,0x69,0x46,0x73,0x69]

/*: __LocalPush" :*/
fileprivate let k_stopTempName:[Character] = ["_","_","L","o","c","a","l","P","u","s","h"]

/*: "identifier" :*/
fileprivate let dataQuantityryPath:[UInt8] = [0x56,0x51,0x52,0x5b,0x61,0x56,0x53,0x56,0x52,0x5f]

fileprivate func blowOver(content num: UInt8) -> UInt8 {
    let value = Int(num) - 237
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "HTTPProxy" :*/
fileprivate let k_pathUrl:[Character] = ["H","T","T","P","P","r"]
fileprivate let dataNoText:[Character] = ["o","x","y"]

/*: "HTTPSProxy" :*/
fileprivate let const_removeServerEnterKey:[Character] = ["H","T"]
fileprivate let showFullId:String = "tpsp"

/*: "SOCKSProxy" :*/
fileprivate let const_indicatorMsg:[Character] = ["S","O","C","K","S","P","r"]
fileprivate let noti_filmData:String = "optionxy"

/*: "__SCOPED__" :*/
fileprivate let const_userScreenMessage:String = "__SCOPEre to key"
fileprivate let notiFilePath:[Character] = ["D","_","_"]

/*: "tap" :*/
fileprivate let constFailureUrl:String = "scalep"

/*: "tun" :*/
fileprivate let main_bridgeMsg:[Character] = ["t","u","n"]

/*: "ipsec" :*/
fileprivate let mainLayerName:[Character] = ["i","p","s","e","c"]

/*: "ppp" :*/
fileprivate let userCaptureMessage:String = "PPP"

/*: "Retry After or Go to " :*/
fileprivate let user_optionValue:String = "point extensionRetry "
fileprivate let kFoundData:[Character] = ["G","o"," ","t","o"," "]

/*: "Feedback" :*/
fileprivate let mainTimeText:String = "Feedbacks production close"

/*: " to contact us" :*/
fileprivate let kSucceedNoName:String = "object tun link black to cont"
fileprivate let kGrantContent:String = "fail info firstact us"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppWebViewHandleEvent.swift
//  OverseaH5
//
//  Created by young on 2025/9/23.
//

//: import CoreTelephony
import CoreTelephony
//: import FirebaseMessaging
import FirebaseMessaging
//: import HandyJSON
import HandyJSON
//: import StoreKit
import StoreKit
//: import UIKit
import UIKit

//: enum TypeName: String, HandyJSONEnum {
enum WritingComparable: String, HandyJSONEnum {
    //: case unDefaultMethod = "unDefaultMethod"    // 未定义方法
    case unDefaultMethod // 未定义方法
    //: case getDeviceID     = "getDeviceID"        // 获取设备号
    case getDeviceID // 获取设备号
    //: case getFireBaseID   = "getFirebaseID"      // 获取FireBaseToken
    case getFireBaseID = "getFirebaseID" // 获取FireBaseToken
    //: case getAreaISO      = "getAreaISO"         // 获取 SIM/运营商 地区ISO
    case getAreaISO // 获取 SIM/运营商 地区ISO
    //: case getProxyStatus  = "getProxyStatus"     // 获取是否使用了代理
    case getProxyStatus // 获取是否使用了代理
    //: case getMicStatus    = "getMicStatus"       // 获取麦克风权限
    case getMicStatus // 获取麦克风权限
    //: case getPhotoStatus  = "getPhotoStatus"     // 获取相册权限
    case getPhotoStatus // 获取相册权限
    //: case getCameraStatus = "getCameraStatus"    // 获取相机权限
    case getCameraStatus // 获取相机权限
    //: case reportAdjust    = "reportAdjust"       // 上报Adjust
    case reportAdjust // 上报Adjust
    //: case requestLocalPush = "requestLocalPush"  // APP在后台收到音视频通话推送
    case requestLocalPush // APP在后台收到音视频通话推送
    // 新增协议
    //: case getLangCode      = "getLangCode"        // 获取系统语言
    case getLangCode // 获取系统语言
    //: case getTimeZone      = "getTimeZone"        // 获取当前系统时区
    case getTimeZone // 获取当前系统时区
    //: case getInstalledApps = "getInstalledApps"   // 获取已安装应用列表
    case getInstalledApps // 获取已安装应用列表
    //: case getSystemUUID    = "getSystemUUID"      // 获取系统UUID
    case getSystemUUID // 获取系统UUID
    //: case getCountryCode   = "getCountryCode"     // 获取当前系统地区
    case getCountryCode // 获取当前系统地区
    //: case inAppRating      = "inAppRating"        // 应用内评分
    case inAppRating // 应用内评分
    //: case apPay            = "apPay"              // 苹果支付
    case apPay // 苹果支付
    //: case subscribe        = "subscribe"          // 苹果支付-订阅
    case subscribe // 苹果支付-订阅
    //: case openSystemBrowser = "openSystemBrowser" // 调用系统浏览器打开url
    case openSystemBrowser // 调用系统浏览器打开url
    //: case closeWebview     = "closeWebview"       // 关闭当前webview
    case closeWebview // 关闭当前webview
    //: case openNewWebview   = "openNewWebview"     // 使用新webview打开url
    case openNewWebview // 使用新webview打开url
    //: case reloadWebview    = "reloadWebview"      // 重载webView
    case reloadWebview // 重载webView
}

//: struct JSMessageModel: HandyJSON {
struct ConsentTelegramTransformable: HandyJSON {
    //: var typeName: TypeName = .unDefaultMethod
    var typeName: WritingComparable = .unDefaultMethod
    //: var token: String?
    var token: String?
    //: var totalCount: Double?
    var totalCount: Double?

    //: var showText: String?
    var showText: String?
    //: var data: UserInfoModel?
    var data: ProgressionModelType?
    // 内购/订阅 H5参数
    //: var goodsId: String?
    var goodsId: String? // 商品Id
    //: var source: Int?
    var source: Int? // 充值来源
    //: var type: Int?
    var type: Int? // 订阅入口；1：首页banner，2：全屏充值页，3：半屏充值页，4：领取金币弹窗
    //: var url: String?
    var url: String? // url
    //: var fullscreen: Int?
    var fullscreen: Int? // fullscreen：0:页面从状态栏以下渲染 1:全屏
    //: var transparency: Int?
    var transparency: Int? // transparency：0-webview白色背景 1-webview透明背景
}

//: struct UserInfoModel: HandyJSON {
struct ProgressionModelType: HandyJSON {
    //: var headPic: String?
    var headPic: String? // 头像
    //: var nickname: String?
    var nickname: String? // 昵称
    //: var uid: String?
    var uid: String? // 用户Id
}

//: extension AppWebViewController {
extension FromCuttingEdgeBaseDelegate {
    //: func handleH5Message(schemeDic: [String: Any], callBack: @escaping (_ backDic: [String: Any]) -> Void) {
    func agent(schemeDic: [String: Any], callBack: @escaping (_ backDic: [String: Any]) -> Void) {
        //: if let model = JSMessageModel.deserialize(from: schemeDic) {
        if let model = ConsentTelegramTransformable.deserialize(from: schemeDic) {
            //: switch model.typeName {
            switch model.typeName {
            //: case .getDeviceID:
            case .getDeviceID:
                //: let adidStr = AppAdjustManager.getAdjustAdid()
                let adidStr = FormAdjustDelegate.app()
                //: callBack(["typeName": model.typeName.rawValue, "deviceID": adidStr])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: constItemName.map{$0^172}, encoding: .utf8)!: adidStr])

            //: case .getFireBaseID:
            case .getFireBaseID:
                //: AppWebViewController.getFireBaseToken { str in
                FromCuttingEdgeBaseDelegate.block { str in
                    //: callBack(["typeName": model.typeName.rawValue, "fireBaseID": str])
                    callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: k_warnMsg.map{queryIndex(screen: $0)}, encoding: .utf8)!: str])
                }

            //: case .getAreaISO:
            case .getAreaISO:
                //: let arr = AppWebViewController.getCountryISOCode()
                let arr = FromCuttingEdgeBaseDelegate.timeManagerMessage()
                //: callBack(["typeName": model.typeName.rawValue, "areaISO": arr.joined(separator: ",")])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: const_countMessage.map{decideMergeService(scale: $0)}, encoding: .utf8)!: arr.joined(separator: ",")])

            //: case .getProxyStatus:
            case .getProxyStatus:
                //: let status = AppWebViewController.getUsedProxyStatus()
                let status = FromCuttingEdgeBaseDelegate.prompt()
                //: callBack(["typeName": model.typeName.rawValue, "isProxy": status])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: showFailureKey.map{adjustmentWhite(foundation: $0)}, encoding: .utf8)!: status])

            //: case .getLangCode:
            case .getLangCode:
                //: let langCode = UIDevice.langCode
                let langCode = UIDevice.langCode
                //: callBack(["typeName": model.typeName.rawValue, "langCode": langCode])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: main_mediaPath.reversed(), encoding: .utf8)!: langCode])

            //: case .getTimeZone:
            case .getTimeZone:
                //: let timeZone = UIDevice.timeZone
                let timeZone = UIDevice.timeZone
                //: callBack(["typeName": model.typeName.rawValue, "timeZone": timeZone])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: show_regionValue.map{mKind(your: $0)}, encoding: .utf8)!: timeZone])

            //: case .getInstalledApps:
            case .getInstalledApps:
                //: let apps = UIDevice.getInstalledApps
                let apps = UIDevice.getInstalledApps
                //: callBack(["typeName": model.typeName.rawValue, "installedApps": apps])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: appFullText.reversed(), encoding: .utf8)!: apps])

            //: case .getSystemUUID:
            case .getSystemUUID:
                //: let uuid = UIDevice.systemUUID
                let uuid = UIDevice.systemUUID
                //: callBack(["typeName": model.typeName.rawValue, "systemUUID": uuid])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: data_installName.map{valueFire(flexible: $0)}, encoding: .utf8)!: uuid])

            //: case .getCountryCode:
            case .getCountryCode:
                //: let countryCode = UIDevice.countryCode
                let countryCode = UIDevice.countryCode
                //: callBack(["typeName": model.typeName.rawValue, "countryCode": countryCode])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: dataUpId.map{captureZone(filter: $0)}, encoding: .utf8)!: countryCode])

            //: case .inAppRating:
            case .inAppRating:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: AppWebViewController.requestInAppRating()
                FromCuttingEdgeBaseDelegate.evaluate()

            //: case .apPay:
            case .apPay:
                //: if let goodsId = model.goodsId, let source = model.source {
                if let goodsId = model.goodsId, let source = model.source {
                    //: self.applePay(productId: goodsId, source: source, payType: .Pay) { success in
                    self.receive(productId: goodsId, source: source, payType: .Pay) { success in
                        //: callBack(["typeName": model.typeName.rawValue, "status": success])
                        callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: main_keyToMsg.map{valueStart(element: $0)}, encoding: .utf8)!: success])
                    }
                }

            //: case .subscribe:
            case .subscribe:
                //: if let goodsId = model.goodsId {
                if let goodsId = model.goodsId {
                    //: self.applePay(productId: goodsId, payType: .Subscribe) { success in
                    self.receive(productId: goodsId, payType: .Subscribe) { success in
                        //: callBack(["typeName": model.typeName.rawValue, "status": success])
                        callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: main_keyToMsg.map{valueStart(element: $0)}, encoding: .utf8)!: success])
                    }
                }

            //: case .openSystemBrowser:
            case .openSystemBrowser:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: if let urlStr = model.url, let openURL = URL(string: urlStr) {
                if let urlStr = model.url, let openURL = URL(string: urlStr) {
                    //: UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
                    UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
                }

            //: case .closeWebview:
            case .closeWebview:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: self.closeWeb()
                self.media()

            //: case .openNewWebview:
            case .openNewWebview:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: if let urlStr = model.url,
                if let urlStr = model.url,
                   //: let transparency = model.transparency,
                   let transparency = model.transparency,
                   //: let fullscreen = model.fullscreen {
                   let fullscreen = model.fullscreen
                {
                    //: AppWebViewController.openNewWebView(urlStr, transparency, fullscreen)
                    FromCuttingEdgeBaseDelegate.withBridgeView(urlStr, transparency, fullscreen)
                }

            //: case .reloadWebview:
            case .reloadWebview:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: self.reloadWebView()
                self.witnesser()

            //: case .getMicStatus:
            case .getMicStatus:
                //: AppPermissionTool.shared.requestMicPermission { auth, isFirst in
                SlashPermissionTool.shared.clearTitleFire { auth, isFirst in
                    //: callBack(["typeName": model.typeName.rawValue, "isAuth": auth, "isFirst": isFirst])
                    callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: appChallengeValue.map{productShared(adjustment: $0)}, encoding: .utf8)!: auth, String(bytes: showClickTitle.reversed(), encoding: .utf8)!: isFirst])
                }

            //: case .getPhotoStatus:
            case .getPhotoStatus:
                //: AppPermissionTool.shared.requestPhotoPermission { auth, isFirst in
                SlashPermissionTool.shared.mortal { auth, isFirst in
                    //: callBack(["typeName": model.typeName.rawValue, "isAuth": auth, "isFirst": isFirst])
                    callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: appChallengeValue.map{productShared(adjustment: $0)}, encoding: .utf8)!: auth, String(bytes: showClickTitle.reversed(), encoding: .utf8)!: isFirst])
                }

            //: case .getCameraStatus:
            case .getCameraStatus:
                //: AppPermissionTool.shared.requestCameraPermission { auth, isFirst in
                SlashPermissionTool.shared.collectionBlock { auth, isFirst in
                    //: callBack(["typeName": model.typeName.rawValue, "isAuth": auth, "isFirst": isFirst])
                    callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue, String(bytes: appChallengeValue.map{productShared(adjustment: $0)}, encoding: .utf8)!: auth, String(bytes: showClickTitle.reversed(), encoding: .utf8)!: isFirst])
                }

            //: case .reportAdjust:
            case .reportAdjust:
                //: if let token = model.token {
                if let token = model.token {
                    //: if let count = model.totalCount {
                    if let count = model.totalCount {
                        //: AppAdjustManager.addPurchasedEvent(token: token, count: count)
                        FormAdjustDelegate.barroom(token: token, count: count)
                        //: } else {
                    } else {
                        //: AppAdjustManager.addEvent(token: token)
                        FormAdjustDelegate.finish(token: token)
                    }
                }
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])

            //: case .requestLocalPush:
            case .requestLocalPush:
                //: callBack(["typeName": model.typeName.rawValue])
                callBack([String(bytes: main_collectionTapPath.map{$0^196}, encoding: .utf8)!: model.typeName.rawValue])
                //: AppWebViewController.pushLocalNotification(model)
                FromCuttingEdgeBaseDelegate.befog(model)

            //: default: break
            default: break
            }
        }
    }
}

// MARK: - Event

//: extension AppWebViewController {
extension FromCuttingEdgeBaseDelegate {
    /// 打开新的webview
    /// - Parameters:
    ///   - urlStr: web地址
    ///   - transparency: 0：白色背景 1：透明背景
    ///   - fullscreen: 0:页面从状态栏以下渲染  1：全屏
    //: class func openNewWebView(_ urlStr: String, _ transparency: Int = 0, _ fullscreen: Int = 1) {
    class func withBridgeView(_ urlStr: String, _ transparency: Int = 0, _ fullscreen: Int = 1) {
        //: let vc = AppWebViewController()
        let vc = FromCuttingEdgeBaseDelegate()
        //: vc.urlString = urlStr
        vc.urlString = urlStr
        //: vc.clearBgColor = (transparency == 1)
        vc.clearBgColor = (transparency == 1)
        //: vc.fullscreen = (fullscreen == 1)
        vc.fullscreen = (fullscreen == 1)
        //: vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        //: AppConfig.currentViewController()?.present(vc, animated: true)
        SortAreaAppConfig.substance()?.present(vc, animated: true)
    }

    /// 本地推送
    //: class func pushLocalNotification(_ model: JSMessageModel) {
    class func befog(_ model: ConsentTelegramTransformable) {
        //: guard UIApplication.shared.applicationState != .active else { return }
        guard UIApplication.shared.applicationState != .active else { return }
        //: UNUserNotificationCenter.current().getNotificationSettings { setting in
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            //: switch setting.authorizationStatus {
            switch setting.authorizationStatus {
            //: case .notDetermined, .denied, .ephemeral:
            case .notDetermined, .denied, .ephemeral:
                //: print("本地推送通知 -- 用户未授权\(setting.authorizationStatus)")
                //: print()
                print()

            //: case .provisional, .authorized:
            case .provisional, .authorized:
                //: if let dataModel = model.data {
                if let dataModel = model.data {
                    //: let content = UNMutableNotificationContent()
                    let content = UNMutableNotificationContent()
                    //: content.title = dataModel.nickname ?? ""
                    content.title = dataModel.nickname ?? ""
                    //: content.body = model.showText ?? ""
                    content.body = model.showText ?? ""
                    //: let identifier = dataModel.uid ?? "\(AppName)__LocalPush"
                    let identifier = dataModel.uid ?? "\(data_stuffMsg)" + (String(k_stopTempName))
                    //: content.userInfo = ["identifier": identifier]
                    content.userInfo = [String(bytes: dataQuantityryPath.map{blowOver(content: $0)}, encoding: .utf8)!: identifier]
                    //: content.sound = UNNotificationSound.default
                    content.sound = UNNotificationSound.default

                    //: let time = Date(timeIntervalSinceNow: 1).timeIntervalSinceNow
                    let time = Date(timeIntervalSinceNow: 1).timeIntervalSinceNow
                    //: let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                    //: let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    //: UNUserNotificationCenter.current().add(request) { _ in
                    UNUserNotificationCenter.current().add(request) { _ in
                    }
                }

            //: @unknown default:
            @unknown default:
                //: break
                break
            }
        }
    }

    /// 获取firebase token
    //: class func getFireBaseToken(tokenBlock: @escaping (_ str: String) -> Void) {
    class func block(tokenBlock: @escaping (_ str: String) -> Void) {
        //: Messaging.messaging().token { token, _ in
        Messaging.messaging().token { token, _ in
            //: if let token = token {
            if let token = token {
                //: tokenBlock(token)
                tokenBlock(token)
                //: } else {
            } else {
                //: tokenBlock("")
                tokenBlock("")
            }
        }
    }

    /// 获取ISO国家代码
    //: class func getCountryISOCode() -> [String] {
    class func timeManagerMessage() -> [String] {
        //: var tempArr: [String] = []
        var tempArr: [String] = []
        //: let info = CTTelephonyNetworkInfo()
        let info = CTTelephonyNetworkInfo()
        //: if let carrierDic = info.serviceSubscriberCellularProviders {
        if let carrierDic = info.serviceSubscriberCellularProviders {
            //: if !carrierDic.isEmpty {
            if !carrierDic.isEmpty {
                //: for carrier in carrierDic.values {
                for carrier in carrierDic.values {
                    //: if let iso = carrier.isoCountryCode, !iso.isEmpty {
                    if let iso = carrier.isoCountryCode, !iso.isEmpty {
                        //: tempArr.append(iso)
                        tempArr.append(iso)
                    }
                }
            }
        }
        //: return tempArr
        return tempArr
    }

    /// 获取用户代理状态
    //: class func getUsedProxyStatus() -> Bool {
    class func prompt() -> Bool {
        //: if AppWebViewController.isUsedProxy() || AppWebViewController.isUsedVPN() {
        if FromCuttingEdgeBaseDelegate.asRun() || FromCuttingEdgeBaseDelegate.shared() {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 判断用户设备是否开启代理
    /// - Returns: false: 未开启  true: 开启
    //: class func isUsedProxy() -> Bool {
    class func asRun() -> Bool {
        //: guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        //: guard let dict = proxy as? [String: Any] else { return false }
        guard let dict = proxy as? [String: Any] else { return false }

        //: if let httpProxy = dict["HTTPProxy"] as? String, !httpProxy.isEmpty { return true }
        if let httpProxy = dict[(String(k_pathUrl) + String(dataNoText))] as? String, !httpProxy.isEmpty { return true }
        //: if let httpsProxy = dict["HTTPSProxy"] as? String, !httpsProxy.isEmpty { return true }
        if let httpsProxy = dict[(String(const_removeServerEnterKey) + showFullId.uppercased() + "roxy")] as? String, !httpsProxy.isEmpty { return true }
        //: if let socksProxy = dict["SOCKSProxy"] as? String, !socksProxy.isEmpty { return true }
        if let socksProxy = dict[(String(const_indicatorMsg) + noti_filmData.replacingOccurrences(of: "option", with: "o"))] as? String, !socksProxy.isEmpty { return true }

        //: return false
        return false
    }

    /// 判断用户设备是否开启代理VPN
    /// - Returns: false: 未开启  true: 开启
    //: class func isUsedVPN() -> Bool {
    class func shared() -> Bool {
        //: guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        //: guard let dict = proxy as? [String: Any] else { return false }
        guard let dict = proxy as? [String: Any] else { return false }
        //: guard let scopedDic = dict["__SCOPED__"] as? [String: Any] else { return false }
        guard let scopedDic = dict[(String(const_userScreenMessage.prefix(7)) + String(notiFilePath))] as? [String: Any] else { return false }
        //: for keyStr in scopedDic.keys {
        for keyStr in scopedDic.keys {
            //: if keyStr.contains("tap") || keyStr.contains("tun") || keyStr.contains("ipsec") || keyStr.contains("ppp"){
            if keyStr.contains((constFailureUrl.replacingOccurrences(of: "scale", with: "ta"))) || keyStr.contains((String(main_bridgeMsg))) || keyStr.contains((String(mainLayerName))) || keyStr.contains((userCaptureMessage.lowercased())) {
                //: return true
                return true
            }
        }
        //: return false
        return false
    }

    /// 请求应用内评分 - iOS 13+ 优化版本
    //: class func requestInAppRating() {
    class func evaluate() {
        //: if #available(iOS 14.0, *) {
        if #available(iOS 14.0, *) {
            // iOS 14+ 使用新的 WindowScene API（推荐）
            //: if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                //: SKStoreReviewController.requestReview(in: windowScene)
                SKStoreReviewController.requestReview(in: windowScene)
            }
            //: } else {
        } else {
            // iOS 13.x 使用传统 API
            //: SKStoreReviewController.requestReview()
            SKStoreReviewController.requestReview()
        }
    }

    private func showToast() {
        TrimProgressHUD.waterCoolerToast((String(user_optionValue.suffix(6)) + "After or " + String(kFoundData)) + "\"" + (String(mainTimeText.prefix(8))) + "\"" + (String(kSucceedNoName.suffix(8)) + String(kGrantContent.suffix(6))))
    }
    
    // MARK: - Event

    /// 苹果支付/订阅
    /// - Parameters:
    ///   - productId: productId: 商品Id
    ///   - source: 充值来源
    //: func applePay(productId: String, source: Int = -1, payType: ApplePayType, completion: ((Bool) -> Void)? = nil) {
    func receive(productId: String, source: Int = -1, payType: FoundationType, completion: ((Bool) -> Void)? = nil) {
        //: ProgressHUD.show()
        TrimProgressHUD.zone()
        //: var index = 0
        var index = 0
        //: if source != -1 {
        if source != -1 {
            //: index = source
            index = source
        }
        //: AppleIAPManager.shared.iap_startPurchase(productId: productId, payType: payType, source: index) { status, _, _ in
        GrantRequestDelegate.shared.permissionWith(productId: productId, payType: payType, source: index) { status, _, _ in
            //: ProgressHUD.dismiss()
            TrimProgressHUD.info()
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: var isSuccess = false
                var isSuccess = false
                //: switch status {
                switch status {
                //: case .verityFail:
                case .verityFail:
                    //: ProgressHUD.toast( "Retry After or Go to \"Feedback\" to contact us")
                    self.showToast()

                //: case .veritySucceed, .renewSucceed:
                case .veritySucceed, .renewSucceed:
                    //: isSuccess = true
                    isSuccess = true
                    //: self.third_jsEvent_refreshCoin()
                    self.topographicPoint()

                //: default:
                default:
                    //: break
                    break
                }
                //: completion?(isSuccess)
                completion?(isSuccess)
            }
        }
    }
}
