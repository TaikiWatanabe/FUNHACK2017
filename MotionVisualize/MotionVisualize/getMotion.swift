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

let kMaxRadius: CGFloat = 200
let kMaxDuration: TimeInterval = 10

class getMotion: UIViewController {
    
    @IBOutlet weak var sourceView: UIImageView!
    private var motionManager: CMMotionManager!//CMMotion使うためのやつ1
    let pulsator = Pulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceView.layer.addSublayer(pulsator)
        pulsator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        pulsator.numPulse = 3
        pulsator.radius = 120.0
        
        //センサー情報の通知の開始
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.05//加速度の取得間隔
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {deviceManager, error in
            
            let accel: CMAcceleration = deviceManager!.userAcceleration
        })
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getMotion.onTick(_:)), userInfo: nil, repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //sourceView.layer.layoutIfNeeded()
        //pulsator.position = sourceView.layer.position
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        pulsator.start()
    }
    
    //0.1秒間隔の定期処理
    func onTick(_ timer: Timer){
        pulsator.start()
    }
}
