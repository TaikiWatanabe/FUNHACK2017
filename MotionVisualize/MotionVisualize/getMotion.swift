//
//  getMotion.swift
//  MotionVisualize
//
//  Created by 合田 和馬 on 2017/01/14.
//  Copyright © 2017年 Project. All rights reserved.
//

import UIKit
import CoreMotion

class getMotion: UIViewController {
    
    private var motionManager: CMMotionManager!//CMMotion使うためのやつ1
    private var size:CGFloat = 0.0
    private var alpha:CGFloat = 0.0
    
    private var addedLayers = [CAShapeLayer]()
    
    /*-----------------テストラベルstart-------------*/
    @IBOutlet weak var testLabel: UILabel!
    /*-----------------テストラベルend-------------*/
    
    override func viewDidLoad() {
        
        //センサー情報の通知の開始
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.05//加速度の取得間隔
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {deviceManager, error in
            
            let accel: CMAcceleration = deviceManager!.userAcceleration
        })
        
        //タイマーの生成
        //Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(getMotion.onTick(_:)), userInfo: nil, repeats: true)
        //self.circle(size: size,alphaValue:alpha)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTick(_ timer: Timer){
        
        size += 1.5
        alpha += 0.01
        if(alpha>=0.49){
            alpha = 0
            size = 0
        }
        //self.circle(size: size,alphaValue:alpha)
    }
}
