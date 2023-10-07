//
//  NetworkManager.swift
//  FlickrClinetAppSwift
//
//  Created by Soner Demirci on 3.09.2023.
//

import Foundation

class NetworkManager{
    static let shared = NetworkManager()
    
    func fetcImage(with url:String?, compenetion: @escaping (Data) -> Void){
        if let urlSting = url, let url = URL(string: urlSting){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                if let data = data{
                    DispatchQueue.main.async {
                        compenetion(data)
                        
                    }
                }
            }.resume()
        }
        
    }
}
