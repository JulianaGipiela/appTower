//
//  ViewModel.swift
//  AppTower
//
//  Created by Juliana Cecilia Gipiela Correa Dias on 13/10/22.
//

import Foundation
import SwiftUI

struct Course: Hashable, Codable {
    let nome: String
    let longitude: String
    let latitude: String
    
}

class ViewModel: ObservableObject{
    @Published var courses: [Course] = []
    
    func fetch(){
        guard let url = URL(string: "https://3rx316jyid.execute-api.us-east-1.amazonaws.com/prd/todasTorres") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _,
            error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                let courses = try JSONDecoder().decode([Course].self,
                                                       from:data)
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
