//
//  SelectModeViewController.h
//  Try_HitAnimal
//
//  Created by irons on 2015/6/27.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SelectModeViewController : UIViewController
- (IBAction)goToGameBreak:(id)sender;
- (IBAction)goToGameLimit:(id)sender;
- (IBAction)goToGameInfinity:(id)sender;

@property (weak) id<gameDelegate> gameDelegate;

@end
