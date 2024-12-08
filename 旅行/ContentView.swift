//
//  ContentView.swift
//  旅行
//
//  Created by 若杉泰周 on 2024/12/07.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject  var locationManager = LocationManager()
    @State  var address: String = "住所を取得中..."
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("ようこそ")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: DetailView(locationManager:locationManager)) {
                    Text("マップを表示")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let location = locationManager.location {
                    Text("緯度: \(location.latitude)")
                    Text("経度: \(location.longitude)")
                    Spacer()
                    Text("住所: \(address)")
                        .padding()
                        .multilineTextAlignment(.center)
                } else if locationManager.isLoading {
                    Text("位置情報を取得中...")
                } else {
                    Text("位置情報が利用できません")
                }
                Button("住所を取得") {
                    if let location = locationManager.location {
                        locationManager.fetchAddress(from: location) { fetchedAddress in
                            address = fetchedAddress ?? "住所を取得できませんでした"
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("ホーム")
        }
        
        .onAppear {
            locationManager.requestLocation()
        }
    }
}
// CLLocationCoordinate2Dをラップする型を作成
struct CoordinateWrapper: Equatable {
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: CoordinateWrapper, rhs: CoordinateWrapper) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
struct DetailView: View {
    @ObservedObject var locationManager:LocationManager
    @State private var cameraPosition: MapCameraPosition = .automatic
    var body: some View {
        
        if let location = locationManager.location{
            VStack {
                // ラッパー型に変換して比較可能にする
                let wrappedLocation = CoordinateWrapper(coordinate: location)
                Map(position: $cameraPosition){Marker("現在地", coordinate: location)}
                    .onAppear {
                        // 初期カメラ位置を現在地に設定
                        cameraPosition = .camera(
                            MapCamera(
                                centerCoordinate: location,
                                distance: 5000,
                                heading: 0,
                                pitch: 0
                            )
                        )
                    }
                    .onChange(of: wrappedLocation) {_, newLocationWrapper in
                        // 現在地が更新された場合にカメラ位置を変更
                        cameraPosition = .camera(
                            MapCamera(
                                centerCoordinate: newLocationWrapper.coordinate,
                                distance: 5000,
                                heading: 0,
                                pitch: 0
                            )
                        )
                    }
                .cornerRadius(10)
                Text("緯度: \(location.latitude)")
                Text("経度: \(location.longitude)")
                NavigationLink(destination: SubDetailView()) {
                    Text("さらに次の画面へ移動")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("マップ")
        }
    }
}

struct SubDetailView: View {
    var body: some View {
        Text("詳細な画面")
            .font(.largeTitle)
            .padding()
            .navigationTitle("さらに詳細")
    }
}

#Preview {
    ContentView()
}
