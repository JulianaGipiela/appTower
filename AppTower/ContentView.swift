//
//  ContentView.swift
//  AppTower
//
//  Created by Juliana Cecilia Gipiela Correa Dias on 13/10/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
           VStack {   Image("torre")
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.pink, lineWidth: 4)
                    }
                Text("Gestão de Torres!")
                    .font(.callout)
                    .foregroundColor(Color.pink)
                    .padding(4.0)
                    .frame(width: nil)
            }
            .navigationTitle("Home")
        }
    }
}

struct MappView: View {
    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                    
            }
            .navigationTitle("Mapa de Torres")
        }
    }
}

struct PostModel: Decodable {
    let nome: String
    let longitude: String
    let latitude: String
    
}

let postUrl = "https://3rx316jyid.execute-api.us-east-1.amazonaws.com/prd/postTorre"

class ViewPostModel: ObservableObject {
    @Published var items = [PostModel]()
    
    func postData(nome: String, longitude: String, latitude: String, callback: @escaping (Bool)->() ){
        guard let url = URL(string: postUrl) else {return}
        
        let body: [String: Any] = ["nome": nome, "longitude": longitude, "latitude": latitude]
        let finalData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) {(data, res, err) in
            do{
                
                if let data = data {
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                    print(result)
                    callback(true)
                } else {
                    print("sem dados")
                }
            } catch(let error) {
                print("error:", error.localizedDescription)
            }
        }.resume()
    }
    
   
}

struct AddView: View {
    @State var nome = ""
    @State var longitude = ""
    @State var latitude = ""
    @StateObject var viewPostModel = ViewPostModel()
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    TextField("Nome da Torre", text: $nome)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    TextField("Longitude", text: $longitude)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    TextField("Latitude", text: $latitude)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    
                    Button(action: buttonAction, label: {
                        Text("Salvar Torre")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.systemPink))
                    })
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Nova Torre"),
                            message: Text("Torre cadastrada com sucesso!")
                        )
                    }
                }
            }
            .navigationTitle("Nova Torre")
        }.padding()
    }
    
    func changeShowAlert (status: Bool) -> Void{
        if(status == true) {
            self.nome = ""
            self.latitude = ""
            self.longitude = ""
        }
        
        self.showAlert = status
    }
    
    var buttonAction: () -> Void{
        {
            viewPostModel.postData(nome: self.nome, longitude: self.longitude, latitude: self.latitude, callback: changeShowAlert)
            
        }
    }
    func actionOfButton() {
            
        print(self.nome)
        print(self.longitude)
        print(self.latitude)
            
        }
}




struct ListView: View {
   @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.courses, id: \.self) { course in
                        HStack {
                            Image("torre")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .background(Color.gray)
                            
                            Text(course.nome)
                                .bold()
                        }
                        .padding(3)
                    }
                }
                .onAppear{
                    viewModel.fetch()
                }
            }
            .navigationTitle("Lista de Torres")
        }
    }
}


struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Início")
                }
            
            MappView()
                .tabItem{
                    Image(systemName: "map")
                    Text("Mapa")
                }
            AddView()
                .tabItem{
                    Image(systemName: "plus")
                    Text("Nova")
                }
            ListView()
                .tabItem{
                    Image(systemName: "list.star")
                    Text("Torres")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
