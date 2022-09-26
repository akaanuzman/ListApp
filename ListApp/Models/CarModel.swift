import Foundation

class CarModel : Identifiable {
    let uuid : UUID = UUID()
    let name : String
    let model : String
    let price : Double
    
    init(name: String, model: String, price: Double) {
        self.name = name
        self.model = model
        self.price = price
    }
}

extension CarModel {
    static let cars = [
        CarModel(name: "Bmv", model: "320i", price: 100000),
        CarModel(name: "Audi", model: "A3", price: 150000),
        CarModel(name: "Volkswagen", model: "Passat", price: 75000),
        CarModel(name: "Opel", model: "Corsa", price: 50000),
        CarModel(name: "Hyundai", model: "Elantra", price: 60000),
    ]
}
