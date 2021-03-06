//
//  Service.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/19.
//  Copyright © 2020 Leon. All rights reserved.
//

import Foundation
import Alamofire

class Service {
    var baseUrl = "https://sheetdb.io/api/v1/frtiim0wfb3dr"
    typealias jsonCallBack = (_ countries:Any?, _ status: Bool, _ message:String) -> Void
    
    var callBack:jsonCallBack?
    
    func getList<T:Codable>(endPoint:String, type:T.Type)  {
        AF.request(self.baseUrl + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
//            debugPrint(responseData)
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode([T].self, from: data)
                self.callBack?(data, true,"")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
            
        }
    }
    
    func getCount<T:Codable>(endPoint:String, type:T.Type)  {
        AF.request(self.baseUrl + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode(T.self, from: data)
                self.callBack?(data, true,"")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func cudAction(endPoint:String, params: Parameters?, method: HTTPMethod){
        
        AF.request(self.baseUrl + endPoint, method: method, parameters: params, encoding: JSONEncoding.default , headers: nil, interceptor: nil).response { (responseData) in
//            debugPrint(responseData)
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode(CUDReturn.self, from: data)
                self.callBack?(data, true,"")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping jsonCallBack) {
        self.callBack = callBack
    }
        
}
