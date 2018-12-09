//
//  Button.swift
//  DungeonCrawler
//
//  Created by Mooseker, William Parker on 12/4/18.
//  Copyright © 2018 Mooseker, William Parker. All rights reserved.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {
    var defaultButtonSprite = SKSpriteNode()
    var activeButtonSprite = SKSpriteNode()
    var action: () -> Void
    var timer = Timer()
    
    init(defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> Void) {
        defaultButtonSprite = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButtonSprite = SKSpriteNode(imageNamed: activeButtonImage)
        action = buttonAction
        super.init()
        isUserInteractionEnabled = true
        addChild(defaultButtonSprite)
    }
   //
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
