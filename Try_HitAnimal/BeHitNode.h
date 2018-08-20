//
//  BeHitNode.h
//  Try_HitAnimal
//
//  Created by irons on 2015/10/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum{
    COIN = 0,
    CAT = 1
}Type;

@interface BeHitNode : SKSpriteNode

@property Type type;
@property int money;
@property bool isHited;
@property SKTexture * beHitedTextture;
@property NSArray* beHitedTextturesArray;

@end
