//
//  ContentView.swift
//  DesignPatterns
//
//  Created by Erison Veshi on 15.5.24.
//

import SwiftUI

// MARK: - Abstract Factory Visualization

struct TaxiOrderingView: View {
    @State private var selectedServiceType = 0
    private let serviceTypes = ["Economy", "Premium", "Van"]
    
    var body: some View {
        VStack(alignment: .center) {
            Picker("Service Type", selection: $selectedServiceType) {
                ForEach(0..<serviceTypes.count) { index in
                    Text(serviceTypes[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            Text(getTaxiInfo())
                .padding()
            
            Spacer()
        }
        .padding()
    }
    
    private func getTaxiInfo() -> String {
        let factory: TaxiServiceFactory
        
        switch selectedServiceType {
        case 0:
            factory = EconomyServiceFactory()
        case 1:
            factory = PremiumServiceFactory()
        case 2:
            factory = VanServiceFactory()
        default:
            fatalError("Invalid service type")
        }
        
        let taxiApp = TaxiOrderingApp(factory: factory)
        taxiApp.orderTaxi()
        return taxiApp.displayTaxiInfo()
    }
}

#Preview {
    TaxiOrderingView()
}

// MARK: - Abstract Factory Example

protocol Car {
    func getDescription() -> String
}

// Concrete Product A1
class EconomyCar: Car {
    func getDescription() -> String {
        return "Economy Car"
    }
}

// Concrete Product A2
class PremiumCar: Car {
    func getDescription() -> String {
        return "Premium Car"
    }
}

// Abstract Product B
protocol Driver {
    func getInfo() -> String
}

// Concrete Product B1
class EconomyDriver: Driver {
    func getInfo() -> String {
        return "Economy Driver"
    }
}

// Concrete Product B2
class PremiumDriver: Driver {
    func getInfo() -> String {
        return "Premium Driver"
    }
}

// Abstract Factory
protocol TaxiServiceFactory {
    func createCar() -> Car
    func createDriver() -> Driver
}

// Concrete Factory 1
class EconomyServiceFactory: TaxiServiceFactory {
    func createCar() -> Car {
        return EconomyCar()
    }
    
    func createDriver() -> Driver {
        return EconomyDriver()
    }
}

// Concrete Factory 2
class PremiumServiceFactory: TaxiServiceFactory {
    func createCar() -> Car {
        return PremiumCar()
    }
    
    func createDriver() -> Driver {
        return PremiumDriver()
    }
}

// Concrete Product A3
class VanCar: Car {
    func getDescription() -> String {
        return "Van Car"
    }
}

// Concrete Product B3
class VanDriver: Driver {
    func getInfo() -> String {
        return "Van Driver"
    }
}
// Concrete Factory 3
class VanServiceFactory: TaxiServiceFactory {
    func createCar() -> Car {
        return VanCar()
    }
    
    func createDriver() -> Driver {
        return VanDriver()
    }
}

// Client code
class TaxiOrderingApp {
    private var factory: TaxiServiceFactory
    private var car: Car?
    private var driver: Driver?
    
    init(factory: TaxiServiceFactory) {
        self.factory = factory
    }
    
    func orderTaxi() {
        car = factory.createCar()
        driver = factory.createDriver()
    }
    
    func displayTaxiInfo() -> String {
        guard let car = car, let driver = driver else {
            return "No taxi ordered yet."
        }
        
        return """
            Taxi Service:
            Car: \(car.getDescription())
            Driver: \(driver.getInfo())
            """
    }
}
