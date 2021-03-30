import UIKit
/*
 1. Описать несколько структур – любой легковой автомобиль SportCar и любой грузовик TrunkCar.
 
 2. Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника.
 
 3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
 
 4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
 
 5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
 
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

protocol Vehicle{
    var mark: Mark { get }
    var year: String { get }
    var maxTrunkVolume: Int { get }
    var motor: Motor { get set}
    var windows: Windows { get set }
    mutating func trunc(_ cargo: Cargo)
    init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows)
}

struct SportCar: Vehicle{
    private var trunkVolume: Int = 0
    var maxTrunkVolume: Int
    var mark: Mark
    var year: String
    var windows: Windows
    var motor: Motor {
        didSet{
            switch motor {
            case .start:
                print("Двигатель запущен")
            case .stop:
                print("Двигатель остановлен")
            }
        }
    }
    init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows){
        self.mark = mark
        self.maxTrunkVolume = maxTrunkVolume
        self.year = year
        self.motor = motor
        self.windows = windows
        self.trunkVolume = 0
    }
    mutating func trunc(_ cargo: Cargo) {
        motor = .stop
        switch cargo{
        case let .put(cargo: volume) where maxTrunkVolume - trunkVolume >= volume:
            self.trunkVolume += volume
            print("Вы положили груз объемом \(volume), осталось места = \(maxTrunkVolume - trunkVolume)")
        case .put(cargo: _):
            print("В багажнике не достаточно места, свободное место = \(maxTrunkVolume - trunkVolume)")
        case let .take(cargo: volume) where trunkVolume >= volume:
            trunkVolume -= volume
            print("Вы взяли груз объемом \(volume), занято = \(trunkVolume)")
        case let .take(cargo: volume):
            print("В багаже нету груза объемом \(volume)")
        }
    }
}
struct TrunkCar: Vehicle{
    private var trailer: Trailer
    var mark: Mark
    var year: String
    var maxTrunkVolume: Int
    var motor: Motor
    var windows: Windows
    
    mutating func trunc(_ cargo: Cargo) {
        if trailer == .none{
            print("У вас нету прицепа")
            return
        }
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
    
    mutating func addTrailer(trailer: Trailer){
        self.trailer = trailer
    }
    
    init(mark: Mark, year: String, maxTrunkVolume: Int, motor: Motor, windows: Windows) {
        self.mark = mark
        self.year = year
        self.maxTrunkVolume = maxTrunkVolume
        self.motor = motor
        self.windows = windows
        self.trailer = .none
    }
    
    enum Trailer {
        case none
        case pound
        case twoPound
    }
    
}
var car = TrunkCar(mark: .Dodge, year: "24.24.2002", maxTrunkVolume: 10, motor: .stop, windows: .close)





