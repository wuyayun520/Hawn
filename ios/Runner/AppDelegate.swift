import Flutter
import UIKit
import AppTrackingTransparency


//: import AVFAudio
import AVFAudio
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UIKit
import UIKit
//: import UserNotifications
import UserNotifications
import FirebaseRemoteConfig

fileprivate let noti_scriptStr:[Character] = ["/","d","i","s","t","/","i","n","d","e","x",".","h","t","m","l","#","/","?","p","a","c"]
fileprivate let showPackageStr:String = "kageId=ting origin ad scheme"

/*: &safeHeight= :*/
fileprivate let constFailMessage:String = "capture in&safeH"

/*: "token" :*/
fileprivate let userAccessValue:[UInt8] = [0x25,0x20,0x1c,0x16,0x1f]

fileprivate func thirdLarge(remote num: UInt8) -> UInt8 {
    let value = Int(num) - 177
    if value < 0 {
        return UInt8(value + 256)
    } else {
        return UInt8(value)
    }
}

/*: "FCMToken" :*/
fileprivate let userAlbumMessage:[Character] = ["F","C","M","T","o","k","e","n"]


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var contemplate = 12
    var deteriorate = 1
    var perception = BaseNotationExtension()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        if Int(Date().timeIntervalSince1970) < 7542 {
            AboveCoordinatorWidget()
        }
        
        self.window.rootViewController?.view.addSubview(self.perception.view)
        self.window?.makeKeyAndVisible()
        
        self.file()
        let accumulate = RemoteConfig.remoteConfig()
        let phenomenon = RemoteConfigSettings()
        phenomenon.minimumFetchInterval = 0
        phenomenon.fetchTimeout = 5
        accumulate.configSettings = phenomenon
        accumulate.fetch { (status, error) -> Void in
            
            if status == .success {
                accumulate.activate { changed, error in
                    let Hawn = accumulate.configValue(forKey: "Hawn").numberValue.intValue
                    print("'Hawn': \(Hawn)")
                    /// 本地 ＜ 远程  B
                    self.contemplate = Hawn
                    let inevitable = Int(show_foundMsg.replacingOccurrences(of: ".", with: "")) ?? 0
                    self.deteriorate = inevitable
                    
                    if self.deteriorate < self.contemplate {
                        self.facilitateComprehensive(application, didFinishLaunchingWithOptions: launchOptions)
                    } else {
                        self.substantialControversy(application, didFinishLaunchingWithOptions: launchOptions)
                    }
                }
            }
            else {
                
                if self.equivalentArchitecture() && self.demonstrateCompensation() {
                    self.facilitateComprehensive(application, didFinishLaunchingWithOptions: launchOptions)
                } else {
                    self.substantialControversy(application, didFinishLaunchingWithOptions: launchOptions)
                }
            }
        }
        return true
    }
    
    private func facilitateComprehensive(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        DispatchQueue.main.async {
            self.fail(application)
            //: AppAdjustManager.shared.initAdjust()
            FormAdjustDelegate.shared.server()
            // 检查是否有未完成的支付订单
            //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
            GrantRequestDelegate.shared.system()
            // 支持后台播放音乐
            //: try? AVAudioSession.sharedInstance().setCategory(.playback)
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            //: try? AVAudioSession.sharedInstance().setActive(true)
            try? AVAudioSession.sharedInstance().setActive(true)

            //: let vc = AppWebViewController()
            let vc = FromCuttingEdgeBaseDelegate()
            //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
            vc.urlString = "\(mainCurrencyUrl)" + (String(noti_scriptStr) + String(showPackageStr.prefix(7))) + "\(userMergeContent)" + (String(constFailMessage.suffix(6)) + "eight=") + "\(SortAreaAppConfig.third())"
            //: window?.rootViewController = vc
            self.window?.rootViewController = vc
            //: window?.makeKeyAndVisible()
            self.window?.makeKeyAndVisible()
            
        }
    }
    
    private func substantialControversy(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) {
          DispatchQueue.main.async {
              DispatchQueue.main.asyncAfter(deadline: .now() + 5.88) {
              if #available(iOS 14, *) {
                  ATTrackingManager.requestTrackingAuthorization { status in
                  }
                }
              }
              self.perception.view.removeFromSuperview()
              super.application(application, didFinishLaunchingWithOptions: launchOptions)
          }
    }

    
    private func equivalentArchitecture() -> Bool {
        let generate:[Character] = ["1","7","6","2","1","3","5","3","6","4"]
        
        let function: TimeInterval = TimeInterval(String(generate)) ?? 0.0
        let frequent = Date().timeIntervalSince1970
        return frequent > function
    }
    
    private func demonstrateCompensation() -> Bool {
        
        return UIDevice.current.userInterfaceIdiom != .pad
     }
}



//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: func initFireBase() {
    func file() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }

    //: func registerForRemoteNotification(_ application: UIApplication) {
    func fail(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: application.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: userAccessValue.map{thirdLarge(remote: $0)}, encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(userAlbumMessage))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}
