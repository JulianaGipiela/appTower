//
//  MapView.swift
//  AppTower
//
//  Created by Juliana Cecilia Gipiela Correa Dias on 13/10/22.
//

import SwiftUI
import MapKit


struct MapView: View {
    @StateObject var viewModel = ViewModel()
    @State private var places: [Location] = []
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -25.41726, longitude: -49.28684),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    func getTorres(){
        
        places.append(Location(coordinate: CLLocationCoordinate2D(latitude: -25.4114, longitude: -49.28722)))
        places.append(Location(coordinate: CLLocationCoordinate2D(latitude: -25.41771, longitude: -49.28765)))
        places.append(Location(coordinate: CLLocationCoordinate2D(latitude: -25.41741, longitude: -49.28788)))
        
        
    }
    
    var body: some View {
        
        Map(coordinateRegion: $region, annotationItems: places, annotationContent: { place in
            MapMarker(coordinate: place.coordinate, tint: .blue)
        }).onAppear{
            getTorres()
        }
        }
}

struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
