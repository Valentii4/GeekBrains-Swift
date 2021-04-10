import UIKit

class Queue<T: Equatable>  {
private var threads: [T] = []

func appendThread(_ thread: T){
    threads.append(thread)
}

subscript(index: Int) -> T{
    threads[index]
}

func filter (predicate: (T) -> Bool) -> [T]{
    var result: [T] = []
    for tread in threads{
        if predicate(tread){
            result.append(tread)
        }
    }
    return result
}

func forEach(predicate: (T) -> ()){
    threads.forEach(predicate)
}
    
}

let value: Queue<Int> =  Queue()
value.appendThread(5)
value.appendThread(4)
print(value.filter { (element) in
return element % 2 == 0
})


