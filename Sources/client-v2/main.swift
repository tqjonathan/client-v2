
import Socket
import Foundation
import Glibc

let server = "localhost"
let port: Int32 = 7667

func printMenu() {
    print("1. Int")
    print("2. String")
    print("3. Exit\n")
    print("Choose and Option")
}

func Option() -> Int {
    printMenu()
    let x = readLine()

    if x == "1" {
        return 1
    }else if x == "2" {
        return 2
    }else if x == "3"{
        return 3
    }else{
        return 0
    }
}

func sendMessage(_ option: Int) -> Data {
    let message1 = "hola"
    let message2 = "12"
    var buffer = Data(capacity: 1000) 
    if option == 2 {
        message1.utf8CString.withUnsafeBytes { buffer.append(contentsOf: $0) }
        return buffer
    }else if option == 1 {
        let message = Int(message2)
        withUnsafeBytes(of: message) { buffer.append(contentsOf: $0) }
        return buffer
    }else{
        return buffer
    }

}


var option = Option()
var buffer = sendMessage(option)
print(buffer)







// do {
//     guard let serverAddress = Socket.createAddress(for: server, on: port) else {
//     print("Error creating Address")
//     exit(1)
// }

//     let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
//     var buffer = Data(capacity: 1000)
//     "hello".utf8CString.withUnsafeBytes { buffer.append(contentsOf: $0) }
//     withUnsafeBytes(of: 42) { buffer.append(contentsOf: $0) }
//     withUnsafeBytes(of: Point(x: 0.7, y: -1.25)) { buffer.append(contentsOf: $0) }
//     try clientSocket.write(from: buffer, to: serverAddress)
// } catch let error {
//     print("Connection error: \(error)")
// }