//
//  ContentView.swift
//  tenYearChallenge
//
//  Created by 林湘羚 on 2021/6/29.
//
import Combine
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var showHomeView=true
    @State private var showNasaView=false
    @State private var showTenYearsView=false
    var body: some View {
        ZStack{
            Color(red:255/255, green:225/255, blue:148/255)
            Image("butter")
                .resizable(resizingMode: .tile)
            VStack(spacing:10){
                if showHomeView {
                    homeView(showHomeView:$showHomeView, showNasaView:$showNasaView, showTenYearsView:$showTenYearsView)
                }else if showTenYearsView {
                    tenYearsView(showHomeView:$showHomeView,showTenYearsView:$showTenYearsView)
                }else if showNasaView {
                    nasaView(showHomeView:$showHomeView, showNasaView:$showNasaView)
                }
            }.padding()
        }
        .ignoresSafeArea(.all)
        .onAppear{
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct homeView: View {
    @Binding var showHomeView:Bool
    @Binding var showNasaView:Bool
    @Binding var showTenYearsView:Bool
    var body: some View{
        ZStack{
            Image("archeologist")
                .resizable()
                .scaledToFit()
                .frame(width:200)
                //.offset()
            HStack{
                Button(action:{
                    showHomeView=false
                    showNasaView=true
                }){
                    Text("宇宙歷史")
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                        .shadow(color: Color.gray, radius: 5)
                        .foregroundColor(.white)
                }
                Button(action:{
                    showHomeView=false
                    showTenYearsView=true
                }){
                    Text("我的歷史")
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                        .shadow(color: Color.gray, radius: 5)
                        .foregroundColor(.white)
                }
            }
            .offset(y:200)
        }
    }
}

struct tenYearsView: View {
    @Binding var showHomeView:Bool
    @Binding var showTenYearsView:Bool
    @State private var image = 22
    @State private var datePickerDate = Date()
    @State private var sliderYear:Double = 2021
    @State private var play=false
    var body: some View{
        VStack{
            HStack{
                Button(action:{
                    showHomeView=true
                    showTenYearsView=false
                }){
                    Image(systemName: "arrow.left.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height:30)
                        .foregroundColor(.orange)
                }
                Spacer()
                Text("#10YearChallenge")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                Spacer()
            }
            if !play {
                Text(String(Int(sliderYear)))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .font(.system(size: 30))
            }
            VStack{
                Image(String(image))
                    .resizable()
                    .cornerRadius(10)
                    .scaledToFit()
                    .frame(width:UIScreen.main.bounds.width-50, height: 400)
            }
            .frame(height:400)
            Toggle(isOn: $play, label: {
                Text("輪播")
            })
            .toggleStyle(SwitchToggleStyle(tint: Color.orange))
            .onChange(of: play, perform: { value in
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if !play {
                        timer.invalidate()
                    }
                    if image < 22 {
                        image += 1
                    }else{
                        image = 0
                    }
                }
            })
            if !play {
                DatePicker("照片日期", selection:$datePickerDate, in:Date().addingTimeInterval(-86400*365*10)...Date(),  displayedComponents: .date)
                    .accentColor(.orange)
                    .onChange(of: datePickerDate, perform: { value in
                        sliderYear=Double(datePickerDate.description.split(separator: "-")[0]) ?? 2011
                        if sliderYear <= 2013 {
                            image = (Int(sliderYear) - 2011) * 3 + Int.random(in: 0...2)
                        }else{
                            image = 9 + (Int(sliderYear) - 2011 - 4) * 2 + Int.random(in: 0...1)
                        }
                    })
                HStack{
                    Text("照片年份"+String(Int(sliderYear)))
                    Slider(value:$sliderYear, in:2011...2021,  step: 1)
                        .accentColor(.orange)
                        .onChange(of: sliderYear, perform: { value in
                            let currentDate = Date()
                            var dateComponent = DateComponents()
                            dateComponent.year = Int(sliderYear-2021)
                            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                            datePickerDate = futureDate ?? Date()
                            
                            if sliderYear <= 2013 {
                                image = (Int(sliderYear) - 2011) * 3 + Int.random(in: 0...2)
                            }else{
                                image = 9 + (Int(sliderYear) - 2011 - 4) * 2 + Int.random(in: 0...1)
                            }
                        })
                }
            }
        }
    }
}

struct nasaView:View{
    @Binding var showHomeView:Bool
    @Binding var showNasaView:Bool
    @State private var datePickerDate:Date=Date()
    @State private var pictureRUL:String=""
    @State private var explanarion:String=""
    var body: some View{
        VStack{
            HStack{
                Button(action:{
                    showHomeView=true
                    showNasaView=false
                }){
                    Image(systemName: "arrow.left.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height:30)
                        .foregroundColor(.orange)
                }
                Spacer()
                Text("Universe")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 20)
            DatePicker("照片日期", selection:$datePickerDate, in:...Date(),  displayedComponents: .date)
                .accentColor(.orange)
                .onChange(of: datePickerDate, perform: { value in
                    fetchNasaAPIJson(date: String(value.description.split(separator: " ")[0]))
                })
            VStack{
                ImageView(withURL: pictureRUL)
            }
            .frame(height:400)
            TextEditor(text: .constant(explanarion))
                .background(Color(red:255/255, green:225/255, blue:148/255))
                .frame(height:300)
            //Text(explanarion)
        }
    }
    func fetchNasaAPIJson(date:String){
        let urlStr = "https://api.nasa.gov/planetary/apod?api_key=doeXWWSn9QG1DqxGZwaT4ZPJBnKjwhBw2xud85G8&date="+date
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data {
                    do {
                        let searchResponse = try decoder.decode(nasaAPI.self, from: data)
                        pictureRUL=searchResponse.url
                        explanarion=searchResponse.explanation
                        //                        print(searchResponse.url)
                    } catch {
                        print(error)
                    }
                } else {
                    print("error")
                }
            }.resume()
        }
    }
}

struct nasaAPI: Codable {
    let url:String
    let copyright:String?
    let date:String
    let explanation:String
    let hdurl:String
    let media_type:String
    let service_version:String
    let title:String
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .cornerRadius(10)
            .scaledToFit()
            .frame(width:UIScreen.main.bounds.width-50, height: 400)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
