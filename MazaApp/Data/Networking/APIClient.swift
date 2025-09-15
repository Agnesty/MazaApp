//
//  APIClient.swift
//  MazaApp
//
//  Created by Agnes Triselia Yudia on 25/08/25.
//

import Foundation
import RxSwift
import Alamofire
import Combine

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: endpoint.urlRequest) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data else {
                    observer.onError(APIError.decoding)
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
                    observer.onCompleted()
                } catch {
                    if let raw = String(data: data, encoding: .utf8) {
                           print("❌ Failed to decode. Raw response:\n\(raw)")
                       }
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
    
    func requestWithAlamofire<T: Decodable>(_ endpoint: APIEndpoint, type: T.Type) -> Observable<T> {
           return Observable.create { observer in
               AF.request(endpoint.urlRequest)
                   .validate()
                   .responseDecodable(of: T.self) { response in
                       switch response.result {
                       case .success(let value):
                           observer.onNext(value)
                           observer.onCompleted()
                       case .failure(let error):
                           observer.onError(error)
                       }
                   }
               return Disposables.create()
           }
       }
    
    //Use this code if u want to use with combine
    func requestWithCombine<T: Decodable>(_ endpoint: APIEndpoint, type: T.Type) -> AnyPublisher<T, Error> {
         return URLSession.shared.dataTaskPublisher(for: endpoint.urlRequest)
             .map(\.data)
             .decode(type: T.self, decoder: JSONDecoder())
             .eraseToAnyPublisher()
     }
}
