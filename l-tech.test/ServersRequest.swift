//
//  ServersRequest.swift
//  l-tech.test
//
//  Created by Евгений on 20/06/2019.
//  Copyright © 2019 Евгений. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerRequest{
    
    static let standard = ServerRequest()
    private init() {}
    
    func authorization(phone: String?, password: String?, authAfter: @escaping (Bool, [String: Any])->()){
        
        if let phoneNumber = phone, let password = password{
            
            let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/auth")!
            
            let params: [String: Any] = ["phone": phoneNumber,
                                         "password": password]
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success:
                        
                        let authSucceed = JSON(response.result.value!)["success"] == true
                        authAfter(authSucceed, params)
                        
                    case .failure:
                        print(response.result.error!)
                    }
            }
        }
    }
    
    func getPhoneMask(setPhoneMaskAfter: @escaping (String)->()){
        let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/phone_masks")!
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
                
            case .success:
                
                let maskString = JSON(response.result.value!)["phoneMask"].stringValue
                setPhoneMaskAfter(maskString)
                
            case .failure(_):
                
                print(response.result.error!)
            }
        }
        
    }
    
    
    func getPosts(getPostAfter: @escaping ([Post])->()) {
        
        let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/posts")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
            .responseJSON { (response) in
                
                switch response.result {
                    
                case .success:
                    
                    print(response.result.value!)
                    
                    var serverPosts: [Post] = []
                    
                    let jsonArray = JSON(response.result.value!).array
                    
                    for post in jsonArray! {
                        
                        let title = post["title"].stringValue
                        let info = post["text"].stringValue
                        let sort = post["sort"].intValue
                        let pictureURL = URL(string: "http://dev-exam.l-tech.ru" + post["image"].stringValue)!
                        
                        let dateString = post["date"].stringValue
                        let date = dateFormatter.date(from: dateString)
                        
                        let postToAdd = Post(title: title, info: info, pictureURL: pictureURL, date: date!, sort: sort)
                        serverPosts.append(postToAdd)
                        
                    }
                    
                    getPostAfter(serverPosts)
                    
                case .failure:
                    
                    print(response.result.error!)
                    
                }
                
        }
        
    }
    
}
