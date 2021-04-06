import UIKit
import Foundation
/*
 1. Описать класс Car c общими свойствами автомобилей и пустым методом действия по аналогии с прошлым заданием.

 2. Описать пару его наследников trunkCar и sportСar. Подумать, какими отличительными свойствами обладают эти автомобили. Описать в каждом наследнике специфичные для него свойства.

 3. Взять из прошлого урока enum с действиями над автомобилем. Подумать, какие особенные действия имеет trunkCar, а какие – sportCar. Добавить эти действия в перечисление.

 4. В каждом подклассе переопределить метод действия с автомобилем в соответствии с его классом.

 5. Создать несколько объектов каждого класса. Применить к ним различные действия.

 6. Вывести значения свойств экземпляров в консоль.
 */
enum Cargo{
    case put(cargo: Int)
    case take(cargo: Int)
}

enum Windows: String{
    case open = "Окна открыты"
    case close = "Окна закрыты"
}
NSCondition()

enum Motor: String{
    case start = "Двигатель запущен"
    case stop = "Двигатель остановлен"
}

enum Mark: String {
    case Buick
    case Cadillac
    case Chevrolet
    case Chrysler
    case Dodge
    case GMC
    case Hummer
    case Jeep
}

class Car: Equatable{
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.mark == rhs.mark
    }
    
    var mark: Mark
    var year: String
    var maxTrunkVolume: Int
    var motor: Motor
    var windows: Windows
    
    init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows){
        self.mark = mark
        self.year = year
        self.maxTrunkVolume = maxTrunkVolume
        self.motor = motor
        self.windows = windows
    }
    
    
    func trunc(_ cargo: Cargo){
        switch cargo {
        case .put(cargo: let value) where value <= maxTrunkVolume:
            print("Положили груз в багажник")
        case .put(cargo: _):
            print("Не достаточно места")
        case .take(cargo: let value) where value <= maxTrunkVolume:
            print("Забрали груз")
        case .take(cargo: _):
            print("Груза такого объема нету")
        }
    }
 }

class SportCar: Car{
    private var trunkVolume: Int
    
    override var motor: Motor {
        didSet{
            switch motor {
            case .start:
                print("Двигатель запущен")
            case .stop:
                print("Двигатель остановлен")
            }
        }
    }
    override init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows){
        self.trunkVolume = 0
        super.init(mark: mark, year: year, maxTrunkVolume: maxTrunkVolume, motor: motor, windows: windows)
    }
    
    override func trunc(_ cargo: Cargo) {
        print("В данной машине нету багажа")
    }
}
class TrunkCar: Car{
    private var trailer: Trailer
    
    override func trunc(_ cargo: Cargo) {
        if trailer == .none{
            print("У вас нету прицепа")
            return
        }
        super.trunc(cargo)
    }
    
    func addTrailer(trailer: Trailer){
        self.trailer = trailer
    }
    
    override init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows) {
        self.trailer = .none
        super.init(mark: mark, year: year, maxTrunkVolume: maxTrunkVolume, motor: motor, windows: windows)
    }
    
    enum Trailer {
        case none
        case pound
        case twoPound
    }
    
}
var car = SportCar(mark: .Dodge, year: "24.24.2002", maxTrunkVolume: 10, motor: .stop, windows: .close)
car.trunc(.put(cargo: 10))
var car2 = TrunkCar(mark: .Buick, year: "2020", maxTrunkVolume: 10, motor: .start, windows: .close)
car2.trunc(.put(cargo: 2))
car2.addTrailer(trailer: .pound)
car2.trunc(.put(cargo: 3))
print(car == car2)

