//
//  Constants.swift
//
//  Created by TawfiqSweedy on 10/08/2021.
//

import Foundation

struct BGConstants {
    
    // MARK: - Network response status
    static var success:Int {return 200}
    static var added:Int {return 202}
    static var failed:Int {return 400}
    static var created:Int {return 201}
    static var unprocessableEntity : Int {return 401}
    static var notActive : Int {return 405}
    static var unauthenticated : Int {return 403}
    static var notAcceptable : Int {return 422}
    static var notFound : Int {return 404}
    static var userType : Int {return 1}
        
    // MARK: - APIs Constants
    static var baseURL:String {return "https://"}
    static var apiURL:String {return "\(baseURL)"}
    static var imagesURL:String {return baseURL + "storage/"}
}
