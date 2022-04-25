//
//  CelebrateController.swift
//  VictoryHQ
//
//  Created by John McCants on 2/17/22.
//

import Foundation
import UIKit

class CelebrateController: UIViewController {
    
    var int: Int? {
        didSet {
            presentMessage()
        }
    }
    
    var label : UILabel = {
        let label = UILabel()
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.alpha = 0
        self.view.backgroundColor = .black
        setupFireworks()
        setupDismissTap()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2) {
            self.label.alpha = 1
        }
    }
    
    func setupDismissTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
 
    
    func setupFireworks() {
        let size = CGSize(width: 824.0, height: 962.0)
        let width = self.view.frame.width
        let height = self.view.frame.height
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        self.view.addSubview(host)
       
        let particlesLayer = CAEmitterLayer()
        particlesLayer.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        host.layer.addSublayer(particlesLayer)
        host.layer.masksToBounds = true

//        particlesLayer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        particlesLayer.backgroundColor = UIColor.clear.cgColor
        particlesLayer.emitterShape = .point
        particlesLayer.emitterPosition = CGPoint(x: width / 2, y: height / 2)
        particlesLayer.emitterSize = CGSize(width: 0.0, height: 0.0)
        particlesLayer.emitterMode = .outline
        particlesLayer.renderMode = .additive


        let cell1 = CAEmitterCell()

        cell1.name = "Parent"
        cell1.birthRate = 1.0
        cell1.lifetime = 2.5
        cell1.velocity = 60.0
        cell1.velocityRange = 100.0
        cell1.yAcceleration = -70.0
        cell1.emissionLongitude = -110.0 * (.pi / 180.0)
        cell1.emissionRange = 85.0 * (.pi / 180.0)
        cell1.scale = 0.0
        cell1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        cell1.redRange = 0.9
        cell1.greenRange = 0.9
        cell1.blueRange = 0.9



        let image1_1 = UIImage(named: "Spark")?.cgImage

        let subcell1_1 = CAEmitterCell()
        subcell1_1.contents = image1_1
        subcell1_1.name = "Trail"
        subcell1_1.birthRate = 45.0
        subcell1_1.lifetime = 0.5
        subcell1_1.beginTime = 0.01
        subcell1_1.duration = 1.7
        subcell1_1.velocity = 80.0
        subcell1_1.velocityRange = 100.0
        subcell1_1.xAcceleration = 100.0
        subcell1_1.yAcceleration = 350.0
        subcell1_1.emissionLongitude = -360.0 * (.pi / 180.0)
        subcell1_1.emissionRange = 22.5 * (.pi / 180.0)
        subcell1_1.scale = 0.5
        subcell1_1.scaleSpeed = 0.13
        subcell1_1.alphaSpeed = -0.7
        subcell1_1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor



        let image1_2 = UIImage(named: "Spark")?.cgImage

        let subcell1_2 = CAEmitterCell()
        subcell1_2.contents = image1_2
        subcell1_2.name = "Firework"
        subcell1_2.birthRate = 20000.0
        subcell1_2.lifetime = 15.0
        subcell1_2.beginTime = 1.6
        subcell1_2.duration = 0.1
        subcell1_2.velocity = 190.0
        subcell1_2.yAcceleration = 80.0
        subcell1_2.emissionRange = 360.0 * (.pi / 180.0)
        subcell1_2.spin = 114.6 * (.pi / 180.0)
        subcell1_2.scale = 0.1
        subcell1_2.scaleSpeed = 0.09
        subcell1_2.alphaSpeed = -0.7
        subcell1_2.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        cell1.emitterCells = [subcell1_1, subcell1_2]

        particlesLayer.emitterCells = [cell1]

    }
    
    func presentMessage() {
        if let int = int {
            label.text = "Congrats! We've reached \(int) victories! Great Work! 🥳"
            label.numberOfLines = 2
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .center
            
            self.view.addSubview(label)
            label.centerX(inView: self.view)
            label.centerY(inView: self.view)
            label.anchor(width: 300)
        }
    }
}
