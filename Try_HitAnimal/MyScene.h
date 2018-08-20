//
//  MyScene.h
//  Try_HitAnimal
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
@protocol gameDelegate;

typedef enum{
    NONE_MODE = 0,
    GAME_BREAK = 1,
    GAME_LIMIT = 2,
    GAME_INFINITY = 3
}MODE;

@interface MyScene : SKScene<UIActionSheetDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastCreateCatTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnEatedCoinTimeInterval;

@property (weak) id<gameDelegate> gameDelegate;

@property (nonatomic) SKSpriteNode * hpBar;

@property int mode;

+(id)sceneWithSize:(CGSize)size mode:(int)mode;

+(int)GAME_BREAK;
+(int)GAME_LIMIT;
+(int)GAME_INFINITY;

-(int)getGameTime;
-(void)setAdClickable:(bool)clickable;
-(void)setGameRun:(bool)isrun;

-(int)getScore;
-(int)getScoreInBreakGameMode;

-(int)getCoin10ForReward;
-(int)getCoin30ForReward;
-(int)getCoin50ForReward;
@end
