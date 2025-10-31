
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let showReceiveValue:String = "appear session main substanceNet "
fileprivate let notiInputCountStr:String = "layer magnitude space build fail, Tr"
fileprivate let showSquareMsg:String = "ain lacount true dismiss interval"
fileprivate let show_frameFormatTitle:String = "TER"

/*: "data" :*/
fileprivate let kFeedbackId:[Character] = ["d","a","t","a"]

/*: ":null" :*/
fileprivate let userFinishLaterMessage:String = ":nulltext app body tag activity"

/*: "json error" :*/
fileprivate let noti_waterText:String = "jslink"
fileprivate let mainMakeData:[Character] = ["n"," ","e","r","r","o","r"]

/*: "platform=iphone&version= :*/
fileprivate let userModelMessage:[Character] = ["p","l","a","t","f","o","r","m","=","i","p","h"]
fileprivate let notiTotalName:String = "one&vmessage activity"

/*: &packageId= :*/
fileprivate let k_appClearData:String = "currency load evaluate kind session&packa"

/*: &bundleId= :*/
fileprivate let app_feedbackPath:[Character] = ["&","b","u","n","d","l","e","I","d","="]

/*: &lang= :*/
fileprivate let kPresentMsg:String = "&lang=tag result us by"

/*: ; build: :*/
fileprivate let app_appearName:[Character] = [";"," ","b","u","i","l","d",":"]

/*: ; iOS  :*/
fileprivate let data_magnitudeValue:[Character] = [";"," ","i","O","S"," "]

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: SlipErrorResponse?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class BindingRequestTool: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func usedField(model: WritingColorRequestModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.filmMakeUponOutlook(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.track(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                rawData(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, SlipErrorResponse(errorCode: MatchTextConvertible.NetError.rawValue, errorMsg: (String(showReceiveValue.suffix(4)) + "Error" + String(notiInputCountStr.suffix(4)) + "y ag" + String(showSquareMsg.prefix(6)) + show_frameFormatTitle.lowercased())))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func rawData(model _: WritingColorRequestModel, response _: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (String(kFeedbackId)) + "\"" + (String(userFinishLaterMessage.prefix(5))), with: "" + "\"" + (String(kFeedbackId)) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<TableTransformable>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == MatchTextConvertible.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, SlipErrorResponse(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case MatchTextConvertible.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, SlipErrorResponse(errorCode: MatchTextConvertible.NetError.rawValue, errorMsg: (noti_waterText.replacingOccurrences(of: "link", with: "o") + String(mainMakeData))))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func filmMakeUponOutlook(model: WritingColorRequestModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (String(userModelMessage) + String(notiTotalName.prefix(5)) + "ersion=") + "\(userInsideId)" + (String(k_appClearData.suffix(6)) + "geId=") + "\(userMergeContent)" + (String(app_feedbackPath)) + "\(show_modeValue)" + (String(kPresentMsg.prefix(6))) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func track(model _: WritingColorRequestModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(data_stuffMsg)/\(show_foundMsg) (\(show_modeValue)" + (String(app_appearName)) + "\(dataFutureMsg)" + (String(data_magnitudeValue)) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
