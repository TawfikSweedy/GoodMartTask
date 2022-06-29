//
//  BGNetworkHelper.swift
//
//  Created by TawfiqSweedy on 10/08/2021.
//

import Foundation
import Moya
import SystemConfiguration

struct BGNetworkHelper {
    // MARK: - print response
    fileprivate static func printResponse(_ response: Response) {
        // print request data
        print("URL:")
        print(response.request?.urlRequest ?? "")
        print("Header:")
        print((response.request?.headers ?? nil) as Any)
        print("STATUS:")
        print(response.statusCode)
        print("Response:")
        if let json = try? JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) {
            print(json)
        } else {
            let response = String(data: response.data, encoding: .utf8)!
            print(response)
        }
    }
    // MARK: - validate all APIs responses
    static func validateResponse (response:Response) ->Bool {
        printResponse(response)
        guard response.statusCode == BGConstants.success else{
            if response.statusCode == 401 {
            }
            return false
        }
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(NewsModel.self, from: response.data)
            switch responseModel.totalResults {
            case BGConstants.success? :
                return true
            case BGConstants.added? , BGConstants.created?:
                BGAlertPresenter.displayToast(title: "",message: "", type: .success)
                return true
            case BGConstants.unprocessableEntity?:
                BGAlertPresenter.displayToast(title: "",message: "", type: .error)
                return false
            case BGConstants.notFound?:
                BGAlertPresenter.displayToast(title: "",message: "", type: .error)
                return false
            case BGConstants.unauthenticated?:
                BGAlertPresenter.displayToast(title: "",message: "", type: .error)
                return false
            case BGConstants.notActive?:
                BGAlertPresenter.displayToast(title: "",message: "", type: .error)
                return  true
            default:
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
}
