//
//  GameScene.swift
//  DungeonCrawler
//
//  Created by Mooseker, William Parker on 12/2/18.
//  Copyright © 2018 Mooseker, William Parker. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var upButtonIsPressed = false
    var downButtonIsPressed = false
    var leftButtonIsPressed = false
    var rightButtonIsPressed = false
    
    let cam = SKCameraNode()
    var playerCharacter: SKSpriteNode!
    var platform = SKTileMapNode()
    var gridGraph = GKGridGraph()
    var isMoveButtonPressed = false
    var leftButton = Button(defaultButtonImage: "roman", activeButtonImage: "roman", buttonAction: {
    })
    var rightButton = Button(defaultButtonImage: "roman", activeButtonImage: "roman", buttonAction: {
        let moveDirection = MovementDirection.right
    })
    var upButton = Button(defaultButtonImage: "roman", activeButtonImage: "roman", buttonAction: {
        let moveDirection = MovementDirection.up
    })
    var downButton = Button(defaultButtonImage: "roman", activeButtonImage: "roman", buttonAction: {
        let moveDirection = MovementDirection.left
    })
    
    enum MovementDirection: Int {
        case up = 1
        case down = -1
        case left = -2
        case right = 2
    }
    
    func loadButtonNodes() {
//        upButton.position = CGPoint(x: (self.frame.midX - (self.frame.midX / 2)), y: (self.frame.midY - (self.frame.midY / 2)) + 12)
//        rightButton.position = CGPoint(x: (self.frame.midX - (self.frame.midX / 2)) + 12, y: self.frame.midY - (self.frame.midY / 2))
//        downButton.position = CGPoint(x: (self.frame.midX - (self.frame.midX / 2)), y: (self.frame.midY - (self.frame.midY / 2)) - 12)
//        leftButton.position = CGPoint(x: (self.frame.midX - (self.frame.midX / 2)) - 12, y: self.frame.midY - (self.frame.midY / 2))
        
        upButton.position = CGPoint(x: 250,y: 200)
        addChild(upButton)
       // addChild(rightButton)
        //addChild(downButton)
       // addChild(leftButton)
    }
    
    
    func loadSceneNodes() {
 
        
        guard let playerCharacter = childNode(withName: "playerCharacter") as? SKSpriteNode else{
            fatalError("error with loading player node")
        }
        guard let platformTileMap = childNode(withName: "platform") as? SKTileMapNode else {
            fatalError("error with loading player node")
        }
        self.platform = platformTileMap
        print("\(platform.numberOfColumns)")
        self.playerCharacter = playerCharacter
        loadButtonNodes()
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0,0), width: Int32(platform.numberOfRows) , height: Int32(platform.numberOfColumns), diagonalsAllowed: false)
        self.gridGraph = graph
        
        var obstacles = [GKGridGraphNode]()
        for column in 0..<self.platform.numberOfColumns
        {
            for row in 0..<self.platform.numberOfRows
            {
                let position = self.platform.centerOfTile(atColumn: column, row: row)
                
                guard let definition = self.platform.tileDefinition(atColumn: column, row: row) else { continue }
                guard let isObstacle: Bool = definition.userData?.value(forKey: "isObstacle") as? Bool else { continue }
                
                if isObstacle
                {
                    let wallNode = self.gridGraph.node(atGridPosition: vector_int2(Int32(column),Int32(row)))!
                    obstacles.append(wallNode)
                }
            }
        }
        
        graph.remove(obstacles)
    }
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        self.camera = cam
        
    }
    
        
    
    
    func movePlayerInDirection(direction: Direction) {
        
        var xMove = CGFloat()
        var yMove = CGFloat()
        
        if direction == MovementDirection.up {
            xMove = CGFloat(integerLiteral: 0)
            yMove = CGFloat(integerLiteral: 128)
        } else if direction == MovementDirection.down {
            xMove = CGFloat(integerLiteral: 0)
            yMove = CGFloat(integerLiteral: -128)
        } else if direction == MovementDirection.left {
            xMove = CGFloat(integerLiteral: -128)
            yMove = CGFloat(integerLiteral: 0)
        } else if direction == MovementDirection.right {
            xMove = CGFloat(integerLiteral: 128)
            yMove = CGFloat(integerLiteral: 0)
        }
        let currentLocation = playerCharacter.position
        let newLocation = CGPoint(x: currentLocation.x + xMove, y: currentLocation.y + yMove)
        let moveAction = SKAction.move(to: newLocation , duration: 0.5)
        //let repeatMove = SKAction.re
        playerCharacter.run(moveAction)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = playerCharacter.position
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        if let touch = touches.first {
////            if leftButton.contains(touch.location(in: self)) {
////                leftButtonIsPressed = true
////            }
////            if rightButton.contains(touch.location(in: self)) {
////                rightButtonIsPressed = true
////            }
////            if upButton.contains(touch.location(in: self)) {
////                upButtonIsPressed = true
////            }
////            if downButton.contains(touch.location(in: self)) {
////                downButtonIsPressed = true
////            }
////        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////        if let touch = touches.first {
////            if leftButton.contains(touch.location(in: self)) {
////                leftButtonIsPressed = false
////            }
////            if rightButton.contains(touch.location(in: self)) {
////                rightButtonIsPressed = false
////            }
////            if upButton.contains(touch.location(in: self)) {
////                upButtonIsPressed = false
////            }
////            if downButton.contains(touch.location(in: self)) {
////                downButtonIsPressed = false
////            }
////        }
//    }
    
    
    var touches = Set<UITouch>()
    var firstTouchLocation = CGPoint(x: 0, y: 0)
    
    var dPadDirection: Direction? {
        if self.touches.count != 1 {
            return nil
        }
        let touch = self.touches.first!
        let loc = touch.location(in: self.view)
        let coordX = loc.x - firstTouchLocation.x
        let coordY = loc.y - firstTouchLocation.y
        if (coordX < 3 && coordY < 3) { // minimum distance to be considered movement
            return nil
        }
        let coords = CGPoint(x: coordX, y: coordY)
        let degrees = 180 + Int(Float(Double.pi/2) - Float(180 / Double.pi) * atan2f(Float(coords.x), Float(coords.y)))
        return Direction(degrees: degrees)
    }
    
    func updateTouches(touches: Set<UITouch>) {
        if self.touches.count <= 0 && touches.count > 0 {
            firstTouchLocation = touches.first!.location(in: self.view)
        }
        //self.touches.unionInPlace(touches: touches)
    }
    
    func endTouches(touches: Set<UITouch>) {
        //self.touches.subtractInPlace(touches: touches)
        firstTouchLocation = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.updateTouches(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endTouches(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endTouches(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.updateTouches(touches: touches)
    }
}
