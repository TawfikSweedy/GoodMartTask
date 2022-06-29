//
//  HomeViewModel.swift
//  GoodsMartTask
//
//  Created by Tawfik Sweedy✌️ on 6/26/22.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import PromiseKit
import SVProgressHUD
import CoreData

class HomeViewModel {
    // MARK: - Public variables
    var loadingBehavior           = BehaviorRelay<Bool>(value: false)
    var stocksModelObservable     : Observable<[Stocks]> {
        return StocksModelSubject
    }
    var newsModelObservable       : Observable<[Articles]> {
        return NewsModelSubject
    }
    // MARK: - private valriables
    private var StocksModelSubject  = PublishSubject<[Stocks]>()
    private var NewsModelSubject    = PublishSubject<[Articles]>()
    private let stocksServices      = MoyaProvider<Services>()
    private let newsServices        = MoyaProvider<Services>()
    private var stocksData          = [Stocks]()
    private var newsData            = [Articles]()
    var stockData   : [Stocks]{
        return stocksData
    }
    var newData     : [Articles]{
        return newsData
    }
    var historyData : [NSManagedObject]{
        return getHistory()
    }
    // MARK: - Private functions
    func convertCSVIntoArray(result : Data) {
        guard let data = String(data: result, encoding: .utf8)else {return}
        var rows = data.components(separatedBy: "\n")
        rows.removeFirst()
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 2 {
                let stock = columns[0].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
                let price = columns[1]
                let person = Stocks(stock: stock , price: price )
                stocksData.append(person)
                self.StocksModelSubject.onNext(stocksData)
            }
        }
    }
    // MARK: - API Services
    func getStocks(){
        firstly { () -> Promise<Any> in
            loadingBehavior.accept(true)
            return BGServicesManager.CallApi(self.stocksServices,Services.Stocks)
        }.done({ [self] response in
            let result = response as! Response
            convertCSVIntoArray(result: result.data)
        }).ensure {
            self.loadingBehavior.accept(false)
        }.catch { (error) in
            BGAlertPresenter.displayToast(title: "" , message: "\(error)", type: .error)
        }
    }
    func getNews(){
        firstly { () -> Promise<Any> in
            loadingBehavior.accept(true)
            return BGServicesManager.CallApi(self.newsServices,Services.News)
        }.done({ [self] response in
            let result = response as! Response
            let data : NewsModel = try BGDecoder.decode(data: result.data)
            self.distroyHistory()
            self.newsData = data.articles ?? []
            self.NewsModelSubject.onNext(data.articles ?? [])
            for new in newsData.suffix(10) {
                self.saveToHistory(descriptions: new.description ?? "", image: new.urlToImage ?? "" , title: new.title ?? "" , date: new.publishedAt ?? "")
            }
        }).ensure {
            self.loadingBehavior.accept(false)
        }.catch { (error) in
            BGAlertPresenter.displayToast(title: "" , message: "\(error)", type: .error)
        }
    }
    // MARK: - Save To History
    func saveToHistory(descriptions : String, image: String, title: String, date: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managedContext)!
        let new = NSManagedObject(entity: entity, insertInto: managedContext)
        new.setValue(date        , forKeyPath: "date")
        new.setValue(title       , forKeyPath: "title")
        new.setValue(descriptions, forKeyPath: "descriptions")
        new.setValue(image       , forKeyPath: "image")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        BGAlertPresenter.displayToast(title: "Success" , message: "News added to History successfully", type: .error)
    }
    // MARK: - Get History
    func getHistory() -> [NSManagedObject] {
        var historyData: [NSManagedObject] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        do {
            historyData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return historyData
    }
    // MARK: - Distroy History
    func distroyHistory() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
