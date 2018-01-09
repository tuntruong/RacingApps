//
//  ViewController.swift
//  RacingApps
//
//  Created by Cuong15tr on 1/8/18.
//  Copyright © 2018 Cuong15tr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var player: UIImageView!
    @IBOutlet weak var car1: UIImageView!
    @IBOutlet weak var car2: UIImageView!
    @IBOutlet weak var car3: UIImageView!
    @IBOutlet weak var playGroundView: UIView!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var welComeView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bestPointLabel: UILabel!
    
    var time: Timer?
    var w: CGFloat! , h: CGFloat!
    var mark = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstData()
    }
    
    func firstData(){
        // get with heght
        w = self.playGroundView.frame.width
        h = self.playGroundView.frame.height
        gameOverView.isHidden = true
        self.playGroundView.backgroundColor = UIColor.init(patternImage: UIImage(named: "road.png")!)
        
        //Set first location 
        car1.frame = CGRect(x: car1.frame.origin.x, y: car1.frame.origin.y - 600, width: car1.frame.size.width, height: car1.frame.size.height)
        car2.frame = CGRect(x: car2.frame.origin.x, y: car2.frame.origin.y - 600, width: car2.frame.size.width, height: car2.frame.size.height)
        car3.frame = CGRect(x: car3.frame.origin.x, y: car3.frame.origin.y - 600, width: car3.frame.size.width, height: car3.frame.size.height)
        
    }
    
    @IBAction func play(_ sender: Any) {
        callToPlay()
    }
    
    func callToPlay() {
        welComeView.isHidden = true
        gameOverView.isHidden = true
        mark = 0
        panGesture.isEnabled = true
        // Set position when replay
        car1.frame.origin.y = -300
        car2.frame.origin.y = -550
        car3.frame.origin.y = -800
        
        //Set time interval
        self.time = Timer.scheduledTimer(timeInterval: 0.0015, target: self, selector: #selector(self.playGame), userInfo: nil, repeats: true)
    }
    
    @objc func playGame(){
        var randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(w)))
        if randomX > self.playGroundView.frame.width - player.frame.width {
            randomX = self.playGroundView.frame.width - player.frame.width
        }
        car1.frame = CGRect(x: car1.frame.origin.x, y: car1.frame.origin.y + 1, width: car1.frame.size.width, height: car1.frame.size.height)
        if car1.frame.origin.y == h {
            car1.frame.origin.y = -car1.frame.size.height
            car1.frame.origin.x = randomX
            // show mark
            mark += 1
        }
        car2.frame = CGRect(x: car2.frame.origin.x, y: car2.frame.origin.y + 1, width: car2.frame.size.width, height: car2.frame.size.height)
        if car2.frame.origin.y == h {
            car2.frame.origin.y = -car2.frame.size.height
            car2.frame.origin.x = randomX
            // show mark
            mark += 1
        }
        car3.frame = CGRect(x: car3.frame.origin.x, y: car3.frame.origin.y + 1, width: car3.frame.size.width, height: car3.frame.size.height)
        if car3.frame.origin.y == h {
            car3.frame.origin.y = -car3.frame.size.height
            car3.frame.origin.x = randomX
            // show mark
            mark += 1
        }
        
        //Check and update Point to view
        markLabel.text = "\(mark)"
        guard let bestMark = UserDefaults.standard.object(forKey: "bestMark") as? Int else {return}
        if bestMark < mark{
            UserDefaults.standard.set(mark, forKey: "bestMark")
        }
        guard let best = UserDefaults.standard.object(forKey: "bestMark") as? Int else {return}
        bestPointLabel.text = "\(best)"
        //MARK: Check car accident
        if car1.frame.intersects(player.frame) || car2.frame.intersects(player.frame) || car3.frame.intersects(player.frame) {
            time?.invalidate()
            panGesture.isEnabled = false
            self.pointLabel.text = "\(self.mark)"
            self.gameOverView.isHidden = false
        }
    }
    //MARK: change player position
    @IBAction func chagePosition(sender: UIPanGestureRecognizer) {
        let playerPosition = sender.translation(in: self.playGroundView)
        let xPosition = (sender.view!.center.x + playerPosition.x)
        guard xPosition > self.view.frame.width/10 - self.player.frame.width/2 && xPosition < self.playGroundView.frame.width - self.player.frame.width/2 else{
            return
        }
        sender.view?.center = CGPoint(x: xPosition , y: sender.view!.center.y)
        sender.setTranslation(CGPoint.zero, in: self.playGroundView)
    }
    @IBAction func playAgain(_ sender: Any) {
        callToPlay()
    }
}

