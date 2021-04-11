import UIKit

var str = "Home work 7"

class Queue<T: Equatable>  {
    //read write lock
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()

    private var threads: [String : T] = [:]
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    func set(name: String, value: T) throws {
        pthread_rwlock_wrlock(&lock)
        if let _ = threads[name]{
            pthread_rwlock_unlock(&lock)
            throw QueueError.setError
        }
        threads[name] = value
        pthread_rwlock_unlock(&lock)
    }
    
    func get(_ name: String) throws -> T {
        pthread_rwlock_wrlock(&lock)
        guard let value = threads[name] else{
            pthread_rwlock_unlock(&lock)
            throw QueueError.getError
        }
        pthread_rwlock_unlock(&lock)
        return value
    }
}

enum QueueError: Error {
    case getError
    case setError
}

let value: Queue<Int> =  Queue()
try? value.set(name: "name", value: 5)

if let element = try? value.get("name"){
    print("элемент = \(element)")
}

do{
    print(try value.get("one"))
}catch let error {
    print(error.localizedDescription)
    print("Нету элемента")
}



