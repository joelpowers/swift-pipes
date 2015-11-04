//
//  GameViewController.swift
//  swift-pipes
//
//  Created by Joel Powers on 10/28/15.
//  Copyright (c) 2015 Joel Powers. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView: SCNView!
    var camera: SCNNode!
    var ground: SCNNode!
    var light: SCNNode!
    var button: SCNNode!
    var sphere1: SCNNode!
    var sphere2: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = SCNView(frame: self.view.frame)
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: "sceneTapped:")
        sceneView.gestureRecognizers = [tapRecognizer]
        
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.blueColor()
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        let camera = SCNCamera()
        camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        self.camera.position = SCNVector3(x: -20, y: 15, z: 20)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.gimbalLockEnabled = true
        self.camera.constraints = [constraint]
        
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGrayColor()
        ambientLight.type = SCNLightTypeAmbient
        self.camera.light = ambientLight
        
        let spotLight = SCNLight()
        spotLight.type = SCNLightTypeSpot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 70.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: 0, y: 25, z: 25)
        light.constraints = [constraint]
        
        let sphereGeometry = SCNSphere(radius: 1.5)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.greenColor()
        sphereGeometry.materials = [sphereMaterial]
        
        sphere1 = SCNNode(geometry: sphereGeometry)
        sphere1.position = SCNVector3(x: -15, y: 1.5, z: 0)
        sceneView.scene?.rootNode.addChildNode(sphere1)
        
        sphere2 = SCNNode(geometry: sphereGeometry)
        sphere2.position = SCNVector3(x: 15, y: 1.5, z: 0)
        sceneView.scene?.rootNode.addChildNode(sphere2)
        
        let buttonGeometry = SCNBox(width: 4, height: 1, length: 4, chamferRadius: 0)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor.redColor()
        buttonGeometry.materials = [buttonMaterial]
        button = SCNNode(geometry: buttonGeometry)
        button.position = SCNVector3(x: 8, y: 0.5, z: 0)
        
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(button)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            node.removeFromParentNode()
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
