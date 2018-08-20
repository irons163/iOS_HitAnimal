//
//  WinDialogViewController.m
//  Try_downStage
//
//  Created by irons on 2015/6/24.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "WinDialogViewController.h"

@interface WinDialogViewController ()

@end

@implementation WinDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
    self.icon10Label.text = [NSString stringWithFormat:@"%d", self.icon10];
    self.icon30label.text = [NSString stringWithFormat:@"%d", self.icon30];
    self.icon50label.text = [NSString stringWithFormat:@"%d", self.icon50];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToMenuClick:(id)sender {
//    [self.gameDelegate goToMenu];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.gameDelegate restartGame];
}

- (IBAction)goToNextLevelClick:(id)sender {
//    [self.gameDelegate goToNextLevel];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.gameDelegate restartGame];
}
@end
