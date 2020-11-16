
import Socket
import Foundation
import Glibc

let server = "localhost"
let port: Int32 = 7667

enum clientError: Error {
    case optionError
    case valueError
}

func printMenu() {
    print("\n1. Int")
    print("2. String")
    print("3. Exit\n")
    print("Choose and Option")
}

func menuOption() -> Int {
    printMenu()
    let option = readLine()
    if option == "1" {
        return 1
    }else if option == "2" {
        return 2
    }else if option == "3"{
        return 3
    }else{
        return 0
    }
}

func toBuffer(_ option: Int,_ mess: String,_ buffer: Data) -> Data {
    var auxBuffer = buffer
    if option == 1 {
        do{
            if let num = Int(mess) {
                withUnsafeBytes(of: num) { auxBuffer.append(contentsOf: $0) }
            }else{
                throw clientError.valueError
            }
        }catch let error {
            print("\n\(error): Wrong type of data")
            exit(1)
        }
        return auxBuffer
    }else{
        mess.utf8CString.withUnsafeBytes { auxBuffer.append(contentsOf: $0) }
        return auxBuffer
    }
}


do {
    var quit = false
    repeat{
        let option = menuOption()
        if option == 0 {
            throw clientError.optionError
        }else if option == 3 {
            quit = true
        }else{
            do {
                guard let serverAddress = Socket.createAddress(for: server, on: port) else {
                    print("Error creating Address")
                    exit(1)
                }
                let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
                var buffer = Data(capacity: 1000) 
                let mess = readLine()!
                var dataType: String
                if option == 1 {
                    dataType = "int"
                    dataType.utf8CString.withUnsafeBytes {buffer.append(contentsOf: $0) }
                    try clientSocket.write(from: buffer, to: serverAddress)
                    buffer.removeAll()
                    buffer = toBuffer(option, mess, buffer)
                    try clientSocket.write(from: buffer, to: serverAddress)

                }else{
                    dataType = "string"
                    dataType.utf8CString.withUnsafeBytes {buffer.append(contentsOf: $0) }
                    try clientSocket.write(from: buffer, to: serverAddress)
                    buffer.removeAll()
                    buffer = toBuffer(option, mess, buffer)
                    try clientSocket.write(from: buffer, to: serverAddress)
                }
                buffer.removeAll()
                
                (_, _) = try clientSocket.readDatagram(into: &buffer) //coge los datos recibidos
                let message = String(decoding: buffer, as: UTF8.self)
                print(message)
                buffer.removeAll()

            }catch let error{
                print("Connection error: \(error)")
            }
        }       

    }while !quit

}catch let error{
    print("\n\(error): Options allowed (1, 2 or 3)")
}


// do {
//     repeat{
//         let option = menuOption()
//         if option == 0 {
//             throw clientError.optionError
//         }

//     }while option != 3
    
//     let option = menuOption()
//     if option == 3 {
//         exit(1)
//     }else if option == 0  {
//         throw clientError.optionError
//     }
//     do {
//         guard let serverAddress = Socket.createAddress(for: server, on: port) else {
//             print("Error creating Address")
//             exit(1)
//         }
//         let clientSocket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
//         var buffer = Data(capacity: 1000) 
//         let mess = readLine()!
//         var dataType: String
//         if option == 1{
//             dataType = "int"
//             dataType.utf8CString.withUnsafeBytes {buffer.append(contentsOf: $0) }
//             try clientSocket.write(from: buffer, to: serverAddress)
//             buffer.removeAll()
//             buffer = toBuffer(option, mess, buffer)
//             try clientSocket.write(from: buffer, to: serverAddress)

//         }else{
//             dataType = "string"
//             dataType.utf8CString.withUnsafeBytes {buffer.append(contentsOf: $0) }
//             try clientSocket.write(from: buffer, to: serverAddress)
//             buffer.removeAll()
//             buffer = toBuffer(option, mess, buffer)
//             try clientSocket.write(from: buffer, to: serverAddress)
//         }
//         buffer.removeAll()
        
//         (_, _) = try clientSocket.readDatagram(into: &buffer) //coge los datos recibidos
//         let message = String(decoding: buffer, as: UTF8.self)
//         print(message)
//         buffer.removeAll()

//     }catch let error{
//         print("Connection error: \(error)")
//     }

// }catch let error{
//     print("\n\(error): Options allowed (1, 2 or 3)")
// }