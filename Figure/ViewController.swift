//
//  ViewController.swift
//  Figure
//
//  Created by Zhaoyang Li on 12/31/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var stageNode: SCNNode?
    var mikuNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        let stageScene = SCNScene(named: "art.scnassets/stage.scn")
        stageNode = stageScene?.rootNode
        let mikuScene =  SCNScene(named: "art.scnassets/miku.scn")
        mikuNode = mikuScene?.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Bases", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 1
        }

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(1)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            if let shapeNode = mikuNode, let baseNode = stageNode {
                let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 5)
                let repeatSpin = SCNAction.repeatForever(shapeSpin)
                shapeNode.runAction(repeatSpin)
                
//                node.addChildNode(baseNode)
                node.addChildNode(shapeNode)
            }
        }
        return node
    }
}
