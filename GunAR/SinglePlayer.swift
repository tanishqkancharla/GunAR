//
//  ViewController.swift
//  GunAR
//
//  Created by Michael Kronovet on 1/17/18.
//  Copyright © 2018 Team 41 Guys. All rights reserved.
//

import UIKit
import SceneKit
import ARKit



class SinglePlayer: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    var fireParticleNode : SCNNode?
    let gameHelper = GameHelper.sharedInstance
    
    var userScore: Int = 0
    {
        didSet {
            // ensure UI update runs on main thread
            DispatchQueue.main.async {
                self.statusLabel.text = String(self.userScore)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        /*let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/alien.jpg")
        sphere.materials = [material]
        
        // Will this Work?
        let scene = SCNScene(named: "art.scnassets/ufo.scn")!
        sceneView.scene = scene
        
        var enemyDict = [String: [Float]]()
        
        var nameL = [String]()
        nameL.append("node1")
        nameL.append("node2")
        nameL.append("node3")
        nameL.append("node4")
        nameL.append("node5")
        nameL.append("node6")
        nameL.append("node7")
        nameL.append("node8")
        nameL.append("node9")
        
        for i in 0...3{
            let name = nameL[i]
            var tempL = [Float]()
            for _ in 0...3{
                let x = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let y = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let z = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                tempL.append(x)
                tempL.append(y)
                tempL.append(z)}
            enemyDict[name] = tempL}
        for j in 3...6{
            let name = nameL[j]
            var tempL = [Float]()
            for _ in 0...3{
                let x = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let y = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let z = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                tempL.append(-1*x)
                tempL.append(y)
                tempL.append(-1*z)}
            enemyDict[name] = tempL}
        for k in 6...8{
            let name = nameL[k]
            var tempL = [Float]()
            for _ in 0...3{
                let x = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let y = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                let z = (Float(arc4random()) / 0xFFFFFFFF) * (8) + 1
                tempL.append(-1*x)
                tempL.append(-1*y)
                tempL.append(z)}
            enemyDict[name] = tempL}
        
        
        for value in enemyDict.values{
            let node = SCNNode()
            node.position = SCNVector3(x: value[0], y: value[1], z: value[2])
            node.geometry = sphere
            sceneView.scene.rootNode.addChildNode(node)
        }*/
        
        
        // Create a new empty scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureSession()
        self.beginPlaying()
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        // sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.delegate = self
        sceneView.session.run(configuration)
    }
    
    // MARK: - Actions
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // fire bullet in direction camera is facing
        switch gameHelper.state {
        case .Playing:
            self.shootBullet()
        case .TapToPlay:
            self.beginPlaying()
        }
    }
    
    func shootBullet() {
        let bulletsNode = Bullet()
        
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position // SceneKit/AR coordinates are in meters
        let bulletDirection = direction
        
        let impulseVector = SCNVector3(
            x: bulletDirection.x * Float(20),
            y: bulletDirection.y * Float(20),
            z: bulletDirection.z * Float(20)
        )
        
        bulletsNode.physicsBody?.applyForce(impulseVector, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
        
        //3 seconds after shooting the bullet, remove the bullet node
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            // remove node
            bulletsNode.removeFromParentNode()
        })
    }
    
    func addTarget() {
        let targetNode = Target()
        let posX = floatBetween(-0.5, and: 0.5)
        let posY = Float(0)
        let posZ = -2
        targetNode.position = SCNVector3(posX, posY, Float(posZ)) // SceneKit/AR coordinates are in meters
        sceneView.scene.rootNode.addChildNode(targetNode)
        gameHelper.liveTargets.append(targetNode)
        
        self.directNodeTowardCamera(targetNode)
        
        print("Added Target! Position:\(targetNode.position)")
    }
    
    func addInitialTarget() {
        //Add initial target after 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.addTarget()
        })
    }
    
    func beginPlaying() {
        self.userScore = 0
        gameHelper.state = .Playing
        self.fireParticleNode?.removeFromParentNode()
        
        self.addInitialTarget()
    }
    
    func directNodeTowardCamera(_ node: SCNNode) {
        node.physicsBody?.clearAllForces()
        //Make cube node go towards camera
        let impulseVector = SCNVector3(
            x: self.randomOneOfTwoInputFloats(-0.50, and: 0.50),
            y: self.randomOneOfTwoInputFloats(-0.50, and: 0.50),
            z: self.randomOneOfTwoInputFloats(-0.50, and: 0.50)
        )
        
        //Makes generated nodes rotate when applied with force
        let positionOnNodeToApplyForceTo = SCNVector3(x: 0.005, y: 0.005, z: 0.005)
        
        node.physicsBody?.applyForce(impulseVector, at: positionOnNodeToApplyForceTo, asImpulse: true)
    }
    
    func removeNode(_ node: SCNNode) {
        
        
        if let target = node as? Target
        {
            if let targetIndex = gameHelper.liveTargets.index(of: target)
            {
                gameHelper.liveTargets.remove(at: targetIndex)
            }
        }
        node.removeFromParentNode()
    }
    
    func getTargetVector(for target: Target?) -> (SCNVector3, SCNVector3) { // (direction, position)
        guard let target = target else {return (SCNVector3Zero, SCNVector3Zero)}
        
        let mat = target.presentation.transform // 4x4 transform matrix describing target node in world space
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of target node in world space
        let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of target node world space
        
        return (dir, pos)
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3Zero, SCNVector3Zero)
    }
    
    func getCameraVector() -> (SCNVector3, SCNVector3)  { // (direction, position)
        
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(mat.m31, mat.m32, mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3Zero, SCNVector3Zero)
    }
    
    func getCameraPosition() -> SCNVector3 {
        let (_ , position) = self.getCameraVector()
        return position
    }
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    func randomOneOfTwoInputFloats(_ first: Float, and second: Float) -> Float {
        let array = [first, second]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        return array[randomIndex]
    }

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension SinglePlayer: SCNPhysicsContactDelegate
{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.target.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.bullets.rawValue) ||
            (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.bullets.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.target.rawValue){
            //target was hit from bullet!
            print("Hit target!")
            
            self.removeNode(contact.nodeB)
            self.removeNode(contact.nodeA)
            self.userScore += 1
            
            self.addTarget()
        }
    }
}

// MARK: - SCNSceneRendererDelegate
extension SinglePlayer : SCNSceneRendererDelegate
{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
}

