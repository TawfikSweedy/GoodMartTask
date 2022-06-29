//
//  NewsModel.swift
//  GoodsMartTask
//
//  Created by Tawfik Sweedy✌️ on 6/26/22.
//

import Foundation

struct NewsModel : Codable {
    let status : String?
    let totalResults : Int?
    let articles : [Articles]?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
}
struct Articles : Codable {
    let source : Source?
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
}
struct Source : Codable {
    let id : String?
    let name : String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
