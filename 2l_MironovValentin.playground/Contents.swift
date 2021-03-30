import UIKit
//1. Написать функцию, которая определяет, четное число или нет.
func isTheNumberEven(_ number: Int) -> Bool{
    number % 2 == 0
}
//2. Написать функцию, которая определяет, делится ли число без остатка на 3.
func isTheNumberWithoutRemainderDivisibleByThree(_ number: Int) -> Bool{
    number % 3 == 0
}

//3. Создать возрастающий массив из 100 чисел.
func getFillArray(firstElement: Int, count: Int) -> [Int]{
    var result: [Int] = []
    for i in 0...count{
        result.append(firstElement+i)
    }
    return result
}
var myArray = getFillArray(firstElement: 0, count: 100)
//4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.
func deleteItemsByRule(array: inout Array<Int>){
    var index = 0
    for value in array {
        if isTheNumberEven(value) || !isTheNumberWithoutRemainderDivisibleByThree(value){
            array.remove(at: index)
            index -= 1
        }
        index += 1
    }
}
deleteItemsByRule(array: &myArray)

//5. * Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 50 элементов.
func getFibonacciNumber(n: Int) -> Int{
    //по формуле Бине
    let a = pow(((1+sqrt(5))/2), Double(n))
    let b = pow(((1-sqrt(5))/2), Double(n))
    let c = Int((a-b)/sqrt(5))
    return c
}
// немного не понял как добавить числа последовательно ли (учитывать сколько было до этого просто чисел или же с 0)
//
func appendFibonacciNumberInArray(array: inout [Int], count: Int){
    // если последовательно
    let firstElemet = array.count
    let lastElement = firstElemet + count
    for i in firstElemet..<lastElement{
        array.append(getFibonacciNumber(n: i))
    }
    /*
     Если с 0
     for i in 0..<count{
     array.append(getFibonacciNumber(n: i))
     }
     */
}

appendFibonacciNumberInArray(array: &myArray, count: 50)

/*
 6. * Заполнить массив из 100 элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:
 
 a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
 b. Пусть переменная p изначально равна двум — первому простому числу.
 c. Зачеркнуть в списке числа от 2 + p до n, считая шагом p..
 d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
 e. Повторять шаги c и d, пока возможно.
 */

func getArrayNumeroNaturale(firstElement: Int, lastElement: Int) -> [Int]{
    var newArray: [Int?] = getFillArray(firstElement: firstElement, count: lastElement-firstElement)
    
    func dellP(p: Int, array: inout [Int?], indexP: Int){
        let index = indexP + p
        for i in stride(from: index, to: array.count, by: p){
            if let element = array[i], element % p == 0 {
                array[i] = nil
            }
        }
    }
    
    for (index, value) in newArray.enumerated(){
        if let value = value{
            dellP(p: value, array: &newArray, indexP: index)
        }
    }
    
    func clearOptional(array: [Int?]) -> [Int]{
        var result: [Int] = []
        for element in newArray{
            if let element = element{
                result.append(element)
            }
        }
        return result
    }
    return clearOptional(array: newArray)
}

print(getArrayNumeroNaturale(firstElement: 2, lastElement: 100))
