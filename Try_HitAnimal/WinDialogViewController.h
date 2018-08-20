//
//  WinDialogViewController.h
//  Try_downStage
//
//  Created by irons on 2015/6/24.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface WinDialogViewController : UIViewController

@property (weak) id<gameDelegate> gameDelegate;
@property int level;
@property int score;
@property int icon10;
@property int icon30;
@property int icon50;
@property (strong, nonatomic) IBOutlet UIButton *goToMenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *goToNextLevel;
@property (strong, nonatomic) IBOutlet UILabel *icon10Label;
@property (strong, nonatomic) IBOutlet UILabel *icon30label;
@property (strong, nonatomic) IBOutlet UILabel *icon50label;

- (IBAction)goToMenuClick:(id)sender;
- (IBAction)goToNextLevelClick:(id)sender;

@end
