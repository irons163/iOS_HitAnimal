//
//  ViewController.h
//  Try_HitAnimal
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@import iAd;

@protocol gameDelegate<NSObject>
-(void)showModeSelect;
-(void)goToGameBreak;
-(void)goToGameLimit;
-(void)goToGameInfinity;
-(void)showRankView;
-(void)showLoseView;
-(void)showWinView;
-(void)restartGame;
@end

@protocol pauseGameDelegate <NSObject>
- (void)pauseGame;
@end

@interface ViewController : UIViewController<gameDelegate,pauseGameDelegate,ADBannerViewDelegate>

@end
