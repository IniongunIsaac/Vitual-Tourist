//
//  NetworkApiClient.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 21/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation

class NetworkApiClient {
    
    struct Auth {
        static let apiKey = "a4f28588b57387edc18282228da39744"
    }
    
    enum Endpoints {
        
        static let baseUrl = "https://api.flickr.com/services/rest/"
        
        case fetchImages(Double, Double, Int)
        
        var stringValue: String {
            switch self {
            case .fetchImages(let latitude, let longitude, let page): return Endpoints.baseUrl + "?method=flickr.photos.search&api_key=\(Auth.apiKey)&format=json&nojsoncallback=1&safe_search=1&per_page=100&page=\(page)&lat=\(latitude)&lon=\(longitude)&extras=url_m"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    fileprivate class func getRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                runOnUIThread { completion(nil, error) }
                return
            }
            do {
                let responseObject = try ResponseType.mapFrom(data: data)
                runOnUIThread { completion(responseObject, nil) }
            } catch {
                runOnUIThread { completion(nil, error) }
            }
        }.resume()
    }
    
    class func fetchImages(latitude: Double, longitude: Double, page: Int = 1, completionHandler: @escaping (PhotosResponse?, Error?) -> Void) {
        getRequestTask(url: Endpoints.fetchImages(latitude, longitude, page).url, responseType: PhotosResponse.self) { response, error in
            completionHandler(response, error)
        }
    }
    
    class func downloadPinImage(url: URL, completion: @escaping(Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            runOnUIThread { completion(data, error) }
        }.resume()
    }
    
}
