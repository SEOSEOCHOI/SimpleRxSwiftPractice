//
//  Network.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class BoxOfficeNetwork {
    
    static func fetchBoxOfficeData(date: String) {
        
        guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)") else {
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            print("DataTask Succeed")
            
            if let _ = error {
                print("Error")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("Response Error")
                return
            }
            
            if let data = data,
                let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                print(appData)
            }
        }.resume()
        
        
    }
}
