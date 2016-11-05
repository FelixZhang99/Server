//
//  wifi.swift
//  测试
//
//  Created by Zhangfutian on 15/12/22.
//  Copyright © 2015年 Zhangfutian. All rights reserved.
//

import SwiftSockets
import Foundation

class wificonnect{
    
    var port : Int = 0
    var listensocket : PassiveSocketIPv4?
    let lockqueue = dispatch_queue_create("socket", nil)
    var opensockets  = [FileDescriptor:ActiveSocket<sockaddr_in>](minimumCapacity: 8)
    var sendsocket : ActiveSocketIPv4?
    var name = String()
    
   
    func setsocket(Port:Int){
        
        listensocket = PassiveSocketIPv4(address: sockaddr_in(address: IP.deviceIPAddress(), port: Port))
        if listensocket == nil || !listensocket!{
            text += "Error:can't create socket\n"
            return
        }
        
        text += "socket:\(listensocket)\n"
        
        let queue = dispatch_get_global_queue(0, 0)
        
        listensocket?.listen(queue, backlog: 5, accept: { (newSock) -> Void in
            text += "got new socket: \(newSock) nio=\(newSock.isNonBlocking)\n"
            self.sendsocket = newSock
            newSock.isNonBlocking = true
            
            dispatch_async(self.lockqueue) {
                self.opensockets[newSock.fd] = newSock
                print(self.opensockets)
            }
            
            
            
            newSock.onRead  { self.handleIncomingData($0, expectedCount: $1) }
                .onClose { ( fd: FileDescriptor ) -> Void in
                    
                    dispatch_async(self.lockqueue) { [unowned self] in
                        _ = self.opensockets.removeValueForKey(fd)
                    }
            }
            
        })
        
        text += "start listening\n"
        
    }
    
    func handleIncomingData<T>(socket: ActiveSocket<T>, expectedCount: Int) {
        
        //text += "read:\(socket.read())\n"
        repeat{
//            print("something:/n")
//            
//            let (count, block, errno) = socket.read()
//        
//            if count < 0 && errno == EWOULDBLOCK {
//                break
//            }
//        
//            if count < 1 {
//                text += "EOF \(socket) (err=\(errno))\n"
//                socket.close()
//                return
//            }
//        
//            text += "\(block)\n"
//            
//            var mblock = [CChar](count: count + 1, repeatedValue: 42)
//            for var i = 0; i < count; i++ {
//                let c = block[i]
//                mblock[i] = c == 83 ? 90 : (c == 115 ? 122 : c)
//            }
//            mblock[count] = 0
//            
//            print(mblock)
//            socket.asyncWrite(mblock, length: count)
        
            let (count, block, errno) = socket.read()
            
            if count < 0 && errno == EWOULDBLOCK {
                break
            }
            
            //text += "got bytes: \(count)\n"
            
            if count < 1 {
                text += "EOF \(socket)\n"
                socket.close()
                return
            }
            
            //text += "BLOCK: \(block)\n"
            let data = String.fromCString(block)! // ignore error, abort
            
            dispatch_async(dispatch_get_main_queue()) {
                text += "\(data)\n"
                if data.hasPrefix("$name:"){
                
                }

            }
        }while(true)
    }
    
    
    func write(content:String){
        
        //text += "send:\(content)\n"
        sendsocket?.write(content)
    }

    
}



