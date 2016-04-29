////
////  Error].swift
////  Donando
////
////  Created by Halil Gursoy on 29/04/16.
////  Copyright © 2016 Donando. All rights reserved.
////
//
import Foundation


public enum DonandoError: ErrorType {
    case GenericError
}

//
//public protocol DonandoErrorType: ErrorType {
//    var code: Int {get}
//    var domain: String {get}
//    var domainBase: String {get}
//    var localizedDescriptionKey: String {get}
//    var localizedDescription: String {get}
//}
//
///**
// Default implementaion for the LoungeErrorType
// */
//extension DonandoErrorType {
//    
//    public var code: Int {
//        return _code
//    }
////    public var domain: String {
////        return _domain
////    }
////    public var domainBase: String {
////        return "mobile.ios.donando"
////    }
////    public var localizedDescriptionKey: String {
////        let endIndex = "\(self)".rangeOfString("(")?.startIndex ?? "\(self)".endIndex
////        return "\(domain)."+"\(self)".substringToIndex(endIndex)
////    }
////    public var localizedDescription: String {
////        return LocalizedString(localizedDescriptionKey)
////    }
//}
//
//public enum DonandoError: DonandoErrorType {
//    
////    public var _domain: String {
////        return domainBase+".error"
////    }
//    
//    case InvalidLoginResponse(errorMessage: String?)
//    case LoginErrorOneBeforeBlocked
//    case LoginErrorBlocked
//    case InvalidServerResponse
//    case UnavailableLoginTokens
//    case KeychainSaveFailed
//    case NoCartForUser
//    case ProlongCartFailed
//    case ConfirmPassword
//    case ConfirmTnC
//    case DOIError
//    case SaveAccessToken(accessToken: String)
//    case FacebookError
//    case GoogleError
//    case GenericServerError
//    case ServerTimeout
//    case SocialLoginError
//    case ShowSizeSelection(existingSKU: String)
//    case MaxDifferentSimples(existingSKU: String)
//    case ServerErrorMessage(message: String)
//    case NotModified
//    case Conflict(errorMessage: String?)
//    case TouchIDNotAvailable
//    case TouchIDError
//    case LogoutFailed
//    case CustomerError
//}
