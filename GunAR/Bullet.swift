//
//  Bullet.swift
//  GunAR
//
//  Created by Michael Kronovet on 1/18/18.
//  Copyright © 2018 Team 41 Guys. All rights reserved.
//

import UIKit
import SceneKit

// Spheres that are shot at the "ships"
class Bullet: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategory.bullets.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.target.rawValue
        
        self.geometry?.materials.first?.diffuse.contents = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
