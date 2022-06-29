//
//  AuthServices.swift
//  TemplateMVVM
//
//  Created by Tawfik Sweedy✌️ on 3/22/22.
//

import Foundation
import Moya

enum Services {
    case Stocks
    case News
}
extension Services : URLRequestBuilder {
    var  baseURL: URL {
        switch self {
        case .Stocks:
            return URL(string: "https://raw.githubusercontent.com/dsancov/TestData/main/")!
        case .News :
            return URL(string: "https://saurav.tech/NewsAPI/everything/")!
        }
    }
    var path: String {
        switch self {
        case.News:
            return EndPoints.news.rawValue
        case .Stocks:
            return EndPoints.stocks.rawValue
        }
    }
    var method: Moya.Method {
        switch self {
        case .Stocks , .News  :
            return .get
        }
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .Stocks , .News :
        return .requestPlain
        }
    }
}
