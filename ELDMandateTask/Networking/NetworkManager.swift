//
//  NetworkManager.swift
//  ELDMandateTask
//
//  Created by Vineet Singh on 10/07/20.
//  Copyright © 2020 ELDMandate. All rights reserved.
//

import Foundation
import Alamofire

enum Service: String {
    case baseurl = "https://qgkpjarwfl.execute-api.us-east-1.amazonaws.com/dev/getNormalVideoFiles"
}

class NetworkManager : NSObject{
    
    static let sharedInstance = NetworkManager()
    
    func apiGetCall(api:String,method: HTTPMethod, parameters: Parameters?,completion:@escaping (_ data:Any?, _ error:Error?)->() ){

        let url = api

        let headers: HTTPHeaders = [
            "x-api-key": "jvmNAyPNr1JhiCeUlYmB2ae517p3Th0aGG6syqMb"
        ]
        
        AF.request(url, method: .get, headers: headers).responseJSON
            { (response) in

                print("***API***\(url)")
                print("***Response***\(response)")
                print("\(response.response?.statusCode)")

                switch(response.result)
                {
                case .success(let value):
                    print("This is success value*** :\(value)")
                    completion(value,nil)
                case .failure(let error):
                    print("This is error*** :\(error)")
                    completion(nil,error)
                    break
                }
        }
        
        
    }
    
}
