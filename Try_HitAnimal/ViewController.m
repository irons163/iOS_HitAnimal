//
//  ViewController.m
//  Try_HitAnimal
//
//  Created by irons on 2015/4/23.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "SelectModeViewController.h"
#import "GameOverViewController.h"
#import "WinDialogViewController.h"
#import "GameCenterUtil.h"

@implementation ViewController{
    ADBannerView * adBannerView;
    MyScene *scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    [self createGameScene:MyScene.GAME_BREAK];
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
    adBannerView.delegate = self;
    adBannerView.alpha = 1.0f;
    [self.view addSubview:adBannerView];
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

-(void)createGameScene:(int)mode{
    SKView * skView = (SKView *)self.view;
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size mode:mode];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    // Present the scene.
    [skView presentScene:scene];
    
}

-(void)showModeSelect{
    SelectModeViewController* selectModeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectModeViewController"];
    selectModeViewController.gameDelegate = self;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [selectModeViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    [self.navigationController presentViewController:selectModeViewController animated:YES completion:^{
        //        [reset];
    }];
}

-(void)goToGameBreak{
    [self createGameScene:MyScene.GAME_BREAK];
}

-(void)goToGameLimit{
    [self createGameScene:MyScene.GAME_LIMIT];
}

-(void)goToGameInfinity{
    [self createGameScene:MyScene.GAME_INFINITY];
}

-(void)restartGame{
    [self createGameScene:scene.mode];
}

-(void)showWinView{
    WinDialogViewController* winDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WinDialogViewController"];
    winDialogViewController.gameDelegate = self;
    winDialogViewController.score = [scene getScoreInBreakGameMode];
    winDialogViewController.icon10 = [scene getCoin10ForReward];
    winDialogViewController.icon30 = [scene getCoin30ForReward];
    winDialogViewController.icon50 = [scene getCoin50ForReward];
    //    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
    //    winDialogViewController.gameLevel = gameLevel;
    
    //    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
    //    [self.delegate BviewcontrollerDidTapButton:self];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [winDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    //    [self.navigationController presentViewController:winDialogViewController animated:YES completion:^{
    //        //        [reset];
    //    }];
    
    winDialogViewController.view.backgroundColor = [UIColor blackColor];
    winDialogViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    //    winDialogViewController.view.alpha = 0.5;
    //    [self.navigationController pushViewController:winDialogViewController animated:YES];
    
//    [self.navigationController presentViewController:winDialogViewController animated:YES completion:nil];
    
    [self presentViewController:winDialogViewController animated:YES completion:^{
        //        [reset];
    }];
}

-(void)showLoseView{
    GameOverViewController* gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.gameDelegate = self;
    
    gameOverDialogViewController.gameTime = [scene getScoreInBreakGameMode];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameOverDialogViewController animated:YES completion:^{
        //        [reset];
    }];
    
}

-(void)pauseGame{
    [scene setGameRun:false];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self layoutAnimated:true];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //    [adBannerView removeFromSuperview];
    //    adBannerView.delegate = nil;
    //    adBannerView = nil;
    [self layoutAnimated:true];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    //    [MyScene setAllGameRun:NO];
    return true;
}

- (void)layoutAnimated:(BOOL)animated
{
    //    CGRect contentFrame = self.view.bounds;
    
    CGRect contentFrame = self.view.bounds;
    //    contentFrame.origin.y = -50;
    CGRect bannerFrame = adBannerView.frame;
    if (adBannerView.bannerLoaded)
    {
        //        contentFrame.size.height -= adBannerView.frame.size.height;
        contentFrame.size.height = 0;
        bannerFrame.origin.y = contentFrame.size.height;
        [scene setAdClickable:false];
    } else {
        //        bannerFrame.origin.y = contentFrame.size.height;
        bannerFrame.origin.y = -50;
        [scene setAdClickable:true];
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        adBannerView.frame = contentFrame;
        [adBannerView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
}
@end
