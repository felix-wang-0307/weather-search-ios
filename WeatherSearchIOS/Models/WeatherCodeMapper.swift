import Foundation
import SwiftyJSON

struct WeatherMapping {
    let code: String
    let desc: String
    let icon: String
}

class WeatherCodeMapper {
    private var mappings: [String: WeatherMapping] = [:]

    init() {
        loadMappings()
    }

    private func loadMappings() {
        guard let url = Bundle.main.url(forResource: "weatherCode", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not find or load weatherCodes.json")
            return
        }

        let json = JSON(data)
        // The JSON is a dictionary keyed by weather code strings (like "1000")
        for (key, subJson): (String, JSON) in json {
            // subJson is something like {"desc":"Clear", "icon":"/images/weather_symbols/clear_day.svg"}
            let desc = subJson["desc"].stringValue
            let icon = subJson["icon"].stringValue
            let mapping = WeatherMapping(code: key, desc: desc, icon: icon)
            mappings[key] = mapping
        }
    }

    func descriptionForCode(_ code: Int) -> String {
        return mappings["\(code)"]?.desc ?? "Unknown"
    }
    
    func descriptionForCode(_ code: String) -> String {
        print(code)
        return mappings[code]?.desc ?? "Unknown"
    }

    func iconPathForCode(_ code: Int) -> String {
        return mappings["\(code)"]?.icon ?? "/images/weather_symbols/unknown.svg"
    }
}
