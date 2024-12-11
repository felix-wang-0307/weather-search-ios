import SwiftUI

struct WeatherDetailsView: View {
    
    let details = [
        ("Humidity", "Humidity", "89 %"),
        ("Wind Speed", "WindSpeed", "12.02 mph"),
        ("Visibility", "Visibility", "9.94 mi"),
        ("Pressure", "Pressure", "29.92 inHg")
    ]
    
    var body: some View {
        ViewThatFits(in: .horizontal, content: {
            HStack {
                ForEach(details, id: \.0) { detail in
                    VStack(spacing: 20) {
                        Text(detail.0)
                        Image(detail.1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(detail.2)
                    }.padding(.horizontal, 2)
                }
            }
        })
    }
}

#Preview {
    WeatherDetailsView()
}
