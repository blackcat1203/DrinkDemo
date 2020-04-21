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
    typealias jsonCallBack<T> = (_ countries:[T]?, _ status: Bool, _ message:String) -> Void
    typealias objectJsonCallBack<T> = (_ countries:T?, _ status: Bool, _ message:String) -> Void
    
    var callBack:jsonCallBack<Any>?
    var objectCallBack:objectJsonCallBack<Any>?
    
    func getGroupList(endPoint:String)  {
        AF.request(self.baseUrl + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
//            debugPrint(responseData)
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode([Group].self, from: data)
                self.callBack?(data, true,"")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
            
        }
    }
    
    func getAllGroupCount(endPoint:String)  {
        AF.request(self.baseUrl + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.objectCallBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode(GetCount.self, from: data)
                self.objectCallBack?(data, true,"")
            } catch {
                self.objectCallBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    
    func getOrderList(endPoint:String){
        AF.request(self.baseUrl + endPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode([Order].self, from: data)
                self.callBack?(data, true,"")
            } catch {
                self.callBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func cudAction(endPoint:String, params: Parameters, method: HTTPMethod){
        
        AF.request(self.baseUrl + endPoint, method: method, parameters: params, encoding: JSONEncoding.default , headers: nil, interceptor: nil).response { (responseData) in
//            debugPrint(responseData)
            guard let data = responseData.data else {
                self.objectCallBack?(nil, false, "")
                return}
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let data = try decoder.decode(CUDReturn.self, from: data)
                self.objectCallBack?(data, true,"")
            } catch {
                self.objectCallBack?(nil, false, error.localizedDescription)
            }
        }
    }
    
    func completionHandler(callBack: @escaping jsonCallBack<Any>) {
        self.callBack = callBack
    }
    
    func completionHandlerForObject(callBack: @escaping objectJsonCallBack<Any>) {
        self.objectCallBack = callBack
    }
        
}
