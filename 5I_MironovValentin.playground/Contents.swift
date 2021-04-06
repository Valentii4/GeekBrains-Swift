import UIKit

/*
 1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
 
 2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
 
 3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
 
 4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
 
 5. Создать несколько объектов каждого класса. Применить к ним различные действия.
 
 6. Вывести сами объекты в консоль.
 */

enum Door: String {
    case drivers = "Водительская дверь"
    case passengerFront = "Передняя пассажирская дверь"
    case passengerLeftRear = "Задняя левая пассажирская дверь"
    case passengerRightRear = "Задняя правая пассажирская дверь"
    case hood = "Капот"
    case luggage = "Багаж"
    
    enum Selector {
        case open
        case close
    }
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

enum Light {
    case lowBeam(_ selector: Selector)
    case highBeam(_ selector: Selector)
    case parkingLights(_ selector: Selector)
    case fog(_ selector: Selector)
    
    enum Selector {
        case on
        case off
    }
}

protocol Motor{
    var isRunning: Bool { get }
    func start()
    func stop()
}


protocol Car: Motor, Equatable, CustomStringConvertible{
    var maxSpeed: Int { get }
    var isDoorOpens: [Door:Door.Selector] { get }
    func door(_ door: Door, selection: Door.Selector)
    func light(_ light: Light)
}
extension Car {
    func light(_ light: Light) {
        switch light {
        case .fog(let selector):
            var res = "Противотуманники "
            switch selector{
            case .on:
                res += "включены"
            case .off:
                res += "выключены"
            }
            print(res)
        case .highBeam(let selector):
            var res = "Дальний свет "
            switch selector{
            case .on:
                res += "включен"
            case .off:
                res += "выключен"
            }
            print(res)
        case .lowBeam(let selector):
            var res = "Ближний свет "
            switch selector{
            case .on:
                res += "включен"
            case .off:
                res += "выключен"
            }
            print(res)
        case .parkingLights(let selector):
            var res = "Габаритные огни "
            switch selector{
            case .on:
                res += "включены"
            case .off:
                res += "выключены"
            }
            print(res)
        }
    }
    func door(_ door: Door, selection: Door.Selector){
        var str = ""
        switch door {
        case .drivers:
            str = "Водительская дверь "
            switch selection {
            case .open:
                str += "открыта"
            case .close:
                str += "закрыта"
            }

        case .hood:
            str = "Капот "
            switch selection {
            case .open:
                str += "открыт"
            case .close:
                str += "закрыт"
            }
        case .luggage:
            str = "Багажник "
            switch selection {
            case .open:
                str += "открыт"
            case .close:
                str += "закрыт"
            }
        case .passengerFront:
            str = "Передняя пассажирская дверь "
            switch selection {
            case .open:
                str += "открыта"
            case .close:
                str += "закрыта"
            }
        case .passengerLeftRear:
            str = "Задняя левая пассажирская дверь "
            switch selection {
            case .open:
                str += "открыта"
            case .close:
                str += "закрыта"
            }
        case .passengerRightRear:
            str = "Задняя правая пассажирская дверь "
            switch selection {
            case .open:
                str += "открыта"
            case .close:
                str += "закрыта"
            }
        }
        print(str)
    }
}

//глобальная перменная, вообще ее наверное можно закинуть в DI подскажите стоит ли так делать?
let nsCodition = NSCondition()

class SportCar: Car {
    static func == (lhs: SportCar, rhs: SportCar) -> Bool {
        lhs.name == rhs.name
    }
    
    var description: String = "Это спортивная машина"
    let name: String
    private(set) var maxSpeed: Int
    private var waitingToStartUp = false
    
    private(set) var isRunning: Bool {
        didSet{
            if isRunning{
                print("Двигатель запущен")
            }else{
                print("Двигатель остановлен")
            }
        }
    }
    private(set) var isDoorOpens: [Door:Door.Selector]
    
    init(maxSpeed: Int, name: Mark) {
        isRunning = false
        isDoorOpens =  [:]
        self.maxSpeed = maxSpeed
        self.name = name.rawValue
    }
    
    func door(_ door: Door, selection: Door.Selector){
        let sel = SelectorDoor(car: self)
        sel.door(door, selection: selection)
    }
    
    func start() {
        let selector = SelectorMotors(car: self)
        selector.start()
    }
    
    func stop() {
        if(isRunning){
        isRunning = false
        }else{
            print("Двигатель еще не был заведен")
        }
    }
    
    private class SelectorMotors: Thread {
        var car: SportCar
        
        init(car: SportCar) {
            self.car = car
            super.init()
        }
        
        override func main() {
            if(car.isRunning){
                print("Двигатель уже запущен")
                return
            }
            nsCodition.lock()
            print("Поступила просьба завести двигатель!")
            while car.isDoorOpens.count != 0{
                print("Ждем пока все двери закроются...")
                car.waitingToStartUp = true
                nsCodition.wait()
            }
            print("Заводим двигатель")
            car.isRunning = true
            car.waitingToStartUp = false
            do {
                nsCodition.unlock()
            }
        }
    }
    
    private class SelectorDoor: Thread {
        let car: SportCar
        
        init(car: SportCar) {
            self.car = car
            super.init()
        }
        
        func door(_ door: Door, selection: Door.Selector){
            if car.isRunning{
                print("Заглушите двигатель прежде чем открывать дверь \(door.rawValue)")
                return
            }
            nsCodition.lock()
            switch selection {
            case .close:
                if let _ = car.isDoorOpens[door]{
                    car.isDoorOpens[door] = .close
                    car.isDoorOpens.removeValue(forKey: door)
                    print("Дверь \(door.rawValue) закрыта")
                }else{
                    print("\(door.rawValue) уже закрыта")
                }
            case .open:
                switch door {
                case  .passengerFront, .passengerLeftRear, .passengerRightRear, .luggage:
                    car.isDoorOpens[door] = .open
                    print("Дверь \(door.rawValue) открыта")
                case .drivers, .hood:
                    
                    if let chooseDoor = car.isDoorOpens[door], chooseDoor == .open{
                        print("\(door.rawValue) уже открыта")
                    }else{
                        car.isDoorOpens[door] = .open
                        print("Дверь \(door.rawValue) открыта")
                    }
                }
            }
            if(car.isDoorOpens.count == 0 && !car.isRunning){
                print("Можем заводить мотор!")
                if(car.waitingToStartUp){
                    nsCodition.signal()
                    car.waitingToStartUp = false
                }
            }
            nsCodition.unlock()
        }
    }
}

class Carting: SportCar{
    static func == (lhs: Carting, rhs: Carting) -> Bool {
        lhs.maxSpeed == rhs.maxSpeed
    }
}

class TrunkCar: Car{
    var description: String = "Это грузовой автомобиль"
    var maxSpeed: Int
    var maxWeight: Int
    var isDoorOpens: [Door : Door.Selector] = [:]
    var isRunning: Bool = false

    init(maxSpeed: Int, maxWeight: Int) {
        self.maxWeight = maxWeight
        self.maxSpeed = maxWeight
    }

    func start() {
        isRunning = true
    }

    func stop() {
        isRunning = false
    }

    static func == (lhs: TrunkCar, rhs: TrunkCar) -> Bool {
        lhs.maxWeight == rhs.maxWeight
    }


}



let mySportCar = SportCar(maxSpeed: 10, name: .Cadillac)
print(mySportCar.description)
let truncCar = TrunkCar(maxSpeed: 10, maxWeight: 20)
print(truncCar.description)
let carting = Carting(maxSpeed: 100, name: .Cadillac)
print(carting == mySportCar)

//разные запуски приведут к разному результату
mySportCar.start()
mySportCar.door(.drivers, selection: .open)
mySportCar.door(.passengerLeftRear, selection: .open)
mySportCar.door(.passengerLeftRear, selection: .close)
mySportCar.door(.drivers, selection: .close)
mySportCar.light(.fog(.on))
mySportCar.stop()

mySportCar.door(.drivers, selection: .open)
mySportCar.door(.passengerLeftRear, selection: .open)
mySportCar.door(.passengerLeftRear, selection: .close)
mySportCar.door(.drivers, selection: .close)
