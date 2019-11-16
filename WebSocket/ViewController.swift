//
//  ViewController.swift
//  WebSocket
//
//  Created by shiga on 16/11/19.
//  Copyright © 2019 Shigas. All rights reserved.
//
//https://medium.com/better-programming/websockets-in-ios-13-using-swift-and-xcode-11-18fa3000d802


import UIKit

// 3Ways To Deal with Websockets

protocol WebSocket {
    func websocketTask(with: URL) -> URLSessionWebSocketTask
    func websocketTask(with: URLRequest) -> URLSessionWebSocketTask
    func websocketTask(with: URL, protocols: [String]) -> URLSessionWebSocketTask
}

class ViewController: UIViewController {
    
    var websocketTask: URLSessionWebSocketTask!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

// Opening Connection
    
    func openingConnection(){
        let urlSession = URLSession(configuration: .default)
         websocketTask = urlSession.webSocketTask(with: URL(string: "www.//apple.websocket.org")!)
        websocketTask.resume()
    }
    
    // sending message
    
    func sendingMessage() {
        let message = URLSessionWebSocketTask.Message.string("Hello Swift!!!")
        websocketTask.send(message) {error in
            if let error = error {
                print("websocket couldn't send message because: \(error)")
            }
        }
    }
    
    // receiving message
    
    func receivingMessage() {
        websocketTask.receive { result in
            switch result{
            case .failure(let error):
                print("message not receiving because: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("receiving message: \(text)")
                case .data(let data):
                    print("received data: \(data)")
                @unknown default:
                    print("")
                }
                // if continuously receving message then call it self
                self.receivingMessage()
            }
            
        }
    }
    
    // pings and pongs To keep the connection active
    
    func sendPing() {
          websocketTask.sendPing{ error in
              if let error = error {
                  print("Sending PING failed: \(error)")
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 10){
                 self.sendPing()
              }
          }
    }
    
    // close connection
    func closeConnection(){
        websocketTask.cancel(with: .goingAway, reason: nil)
    }
}


// Checking Connection States


extension ViewController: URLSessionWebSocketDelegate{
    /// connection disconnected
    func urlSession(_ session: URLSession,
      webSocketTask: URLSessionWebSocketTask,
      didCloseWith
      closeCode: URLSessionWebSocketTask.CloseCode,
      reason: Data?){
        print("connection disconnected")
    }
    // connection established
    func urlSession(_ session: URLSession,
      webSocketTask: URLSessionWebSocketTask,
      didOpenWithProtocol protocol: String?){
        print("connection established")
    }
    
}


