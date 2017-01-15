//
//  getMotion.swift
//  MotionVisualize
//
//  Created by 合田 和馬 on 2017/01/14.
//  Copyright © 2017年 Project. All rights reserved.
//

import UIKit
import CoreMotion
import Pulsator
import SpriteKit
import Starscream

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10

class getMotion: UIViewController, WebSocketDelegate {
    
    @IBOutlet weak var sourceView: UIImageView!
    @IBOutlet weak var graphView: UIView!

    private var motionManager: CMMotionManager!//CMMotion使うためのやつ1
    let pulsator = Pulsator()

    let socket = WebSocket(url: URL(string: "ws://motionvisualizer.herokuapp.com")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.delegate = self
        socket.connect()
        
        //波紋の描画
        sourceView.layer.addSublayer(pulsator)
        pulsator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        pulsator.numPulse = 3
        pulsator.radius = 120.0
        
        //センサー情報の通知の開始
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.2//加速度の取得間隔
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {deviceManager, error in
            let accel: CMAcceleration = deviceManager!.userAcceleration
            let text:String = "".appendingFormat("%.4f", accel.x) + "," + "".appendingFormat("%.4f", accel.y)
            self.socket.write(string: text)
        })
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getMotion.onTick(_:)), userInfo: nil, repeats: false)

    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Received data: \(data.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        pulsator.start()
    }
    
    //0.1秒間隔の定期処理
    func onTick(_ timer: Timer){
        pulsator.start()
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func result(_ sender: AnyObject) {
        let targetView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "result")
        targetView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(targetView, animated: true, completion: nil)
    }
}
