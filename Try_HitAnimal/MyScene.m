//
//  MyScene.m
//  Try_HitAnimal
//
//  Created by irons on 2015/4/23.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "TextureHelper.h"
#import "MyUtils.h"
#import "CommonUtil.h"
#import "BeHitNode.h"
#import "MyADView.h"
#import "GameCenterUtil.h"
#import <AudioToolbox/AudioToolbox.h>

#define DEFAULT_HP  1
int catMaxHp = DEFAULT_HP;

@implementation MyScene{
    int catCurrentHp;
    int catLevel;

    int playerInitX, playerInitY;
    Boolean isGameRun, isGameStart;
    int ccount;
    int gameLevel;
    int delaytime;
    int createCatFrequenceRate;
    int randomMaxCatLimit;
    int randomMinCatLimit;
    int score;
    int scoreInBreakGameMode;
    int coin;
    float eatedCoinFrequence;
    float eatedFrequenceFasterFactor;
    float eatedFrequenceSlowerFactor;
    int coin10Num;
    int coin30Num;
    int coin50Num;
    
    SKSpriteNode * backgroundNode;
    SKSpriteNode * player;
    SKSpriteNode * controller;
    SKSpriteNode * textureBox;
    //    SKSpriteNode * coin;
    SKSpriteNode * coin10Btn, * coin30Btn, * coin50Btn;
    SKLabelNode * coin10NumNode,*coin30NumNode,*coin50NumNode;
    SKSpriteNode * controlPoint;
    SKLabelNode * gameLevelNode;
    SKSpriteNode * buttonNode;
    
    SKSpriteNode * panel;
    SKSpriteNode * itemBar;
    SKSpriteNode * item1, * item2, * item3;
    SKSpriteNode * skillArea;
    SKSpriteNode * infoArea;
    SKLabelNode * scoreLabel;
    SKLabelNode * scoreByBreakGameModeLabel;
    
    NSMutableArray * scoreArray;
    NSMutableArray * contactQueue;
    NSMutableArray * catArray;
    NSMutableArray * catInRunActionArray;
    NSMutableArray * catOriganalPositionY;
    NSArray * currentCatTextures;
    
    CGPoint coin10BtnOraginPosition, coin30BtnOraginPosition,coin50BtnOraginPosition;
    
    SKSpriteNode * labaHole;
    SKSpriteNode * hamer;
    
    SKSpriteNode * bigCat;
    
    SKSpriteNode * rankBtn;
    SKSpriteNode * musicBtn;
    SKSpriteNode * modeBtn;
    
    NSMutableArray * musicBtnTextures;
    
    SKLabelNode * gameTimeNode;
    
    MODE willChangeGameMode;
    
    NSTimer * theGameTimer;
    
    int gameTime;
    
    int answerCorrectNUm;
    
    int cloudMoveSpeed;
    
    bool isSheepTouchable;
    
    float upSpeed;
    float downSpeed;
    
    int coin10NumForReward;
    int coin30NumForReward;
    int coin50NumForReward;
}

MyADView *myAdView;

int maxTime = 15;

const int MONEY_COIN_10 = 10;
const int MONEY_COIN_30 = 30;
const int MONEY_COIN_50 = 50;
const static int MONEY_INIT = 2000;
const static int MONEY_INIT_EVERYDAY = 1000;

int currentMoneyLevel = MONEY_COIN_10;
static int currentMoney = MONEY_INIT;

const int displayADPerTimes = 10;
int displayADCount = 1;

bool isFocusStopFallWithCoinsRun = false;
bool isAutoStop = false;
bool isCanPressStartBtn = true;
bool isCanPressStopBtn = false;

int lineCount = 0;

const int AUTO_STOP_TIME_MS = 5000;
int firstStopTimeMs = AUTO_STOP_TIME_MS;
int secondStopTimeMs = AUTO_STOP_TIME_MS;
int thirdStopTimeMs = AUTO_STOP_TIME_MS;

//static const uint32_t projectileCategory     =  0x1 << 0;
//static const uint32_t monsterCategory        =  0x1 << 1;
//static const uint32_t toolCategory        =  0x1 << 2;
//static const uint32_t catCategory        =  0x1 << 3;
//static const uint32_t hamsterCategory        =  0x1 << 5;
//static const uint32_t coinCategory        =  0x1 << 6;
//static const uint32_t groundCategory        =  0x1 << 7;
//static int barInitX, barInitY;

int GAME_TIME_LIMIT_LEVEL2_START_LEVEL = 3;
int GAME_TIME_LIMIT_LEVEL3_START_LEVEL = 6;
int GAME_TIME_LIMIT_LEVEL4_START_LEVEL = 9;
int GAME_TIME_LIMIT_LEVEL5_START_LEVEL = 12;

int GAME_LEVEL2_START_LEVEL = 10;
int GAME_LEVEL3_START_LEVEL = 20;
int GAME_LEVEL4_START_LEVEL = 30;
int GAME_LEVEL5_START_LEVEL = 40;
int GAME_SUCCESS_LEVEL = 50;

const int CLOUD_DEFAULT_MOVE_SPEED = 7;
const int CLOUD_LEVEL2_MOVE_SPEED = 9;
const int CLOUD_LEVEL3_MOVE_SPEED = 11;
const int CLOUD_LEVEL4_MOVE_SPEED = 13;
const int CLOUD_LEVEL5_MOVE_SPEED = 15;

+(id)sceneWithSize:(CGSize)size mode:(int)mode{
    MyScene* scene = [MyScene sceneWithSize:size];
    scene.mode = mode;
    return scene;
}

-(void)initWithBg{
    backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"bg02.jpg"];
    backgroundNode.size = self.frame.size;
    backgroundNode.anchorPoint = CGPointMake(0, 0);
    backgroundNode.position = CGPointMake(0, 0);
    [self addChild:backgroundNode];
    [self setBgByGameLevel];
}

-(void)initWithLabaHoleAndCoin{
    labaHole = [SKSpriteNode spriteNodeWithImageNamed:@"money_in_bar.jpg"];
    labaHole.size = CGSizeMake(30, 100);
    //        labaHole.position = CGPointMake(self.size.width/2.0-startBtn.size.width, stopBtn.position.y + stopBtn.size.height/2.0 + labaHole.size.height/2.0);
    labaHole.position = CGPointMake(15, scoreLabel.position.y);
    //        labaHole.zPosition = holeZposition;
    int disapearX = labaHole.position.x;
    [self addChild:labaHole];
    
    coin10Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_10_btn01"];
    coin10Btn.size = CGSizeMake(50, 50);
    coin10Btn.position = CGPointMake(40 + coin10Btn.size.width, scoreLabel.position.y-10);
//    [self addChild:coin10Btn];
    
    CGSize coinMaskDisplaySise = CGSizeMake((coin10Btn.position.x - disapearX)*2, coin10Btn.size.height);
    
    SKSpriteNode *coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
    
    coinMask.anchorPoint = coin10Btn.anchorPoint;
    
    coinMask.position = coin10Btn.position;
    //        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
    
    SKCropNode * coinCropNode = [SKCropNode node];
    //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
    
    [coinCropNode addChild:coin10Btn];
    
    coinCropNode.maskNode = coinMask;
    
    //        [node addChild:mask];
    
    [self addChild:coinCropNode];
    
    //        [coin10 runAction:[SKAction group:@[[SKAction sequence:@[upAction, upEnd, downAction, end]], horzAction]]];
    
    coin30Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_30_btn01"];
    coin30Btn.size = CGSizeMake(50, 50);
    coin30Btn.position = CGPointMake(60 + coin30Btn.size.width*2, scoreLabel.position.y-10);
    
//    [self addChild:coin30Btn];
    
    coinMaskDisplaySise = CGSizeMake((coin30Btn.position.x - disapearX)*2, coin30Btn.size.height);
    
    coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
    
    coinMask.anchorPoint = coin30Btn.anchorPoint;
    
    coinMask.position = coin30Btn.position;
    //        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
    
    coinCropNode = [SKCropNode node];
    //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
    
    [coinCropNode addChild:coin30Btn];
    
    coinCropNode.maskNode = coinMask;
    
    [self addChild:coinCropNode];
    
    coin50Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_50_btn01"];
    coin50Btn.size = CGSizeMake(50, 50);
    coin50Btn.position = CGPointMake(80 + coin50Btn.size.width*3, scoreLabel.position.y-10);
    
//    [self addChild:coin50Btn];
    
    coinMaskDisplaySise = CGSizeMake((coin50Btn.position.x - disapearX)*2, coin50Btn.size.height);
    
    coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
    
    coinMask.anchorPoint = coin50Btn.anchorPoint;
    
    coinMask.position = coin50Btn.position;
    //        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
    
    coinCropNode = [SKCropNode node];
    //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
    
    [coinCropNode addChild:coin50Btn];
    
    coinCropNode.maskNode = coinMask;
    
    [self addChild:coinCropNode];
    
    coin10NumNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coin10NumNode.text = @"0";
    coin10NumNode.fontSize = 30;
    coin10NumNode.fontColor = [UIColor redColor];
    coin10NumNode.position = CGPointMake(coin10Btn.position.x,
                                      coin10Btn.position.y-20);
    
    [self addChild:coin10NumNode];
    
    coin30NumNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coin30NumNode.text = @"0";
    coin30NumNode.fontSize = 30;
    coin30NumNode.fontColor = [UIColor redColor];
    coin30NumNode.position = CGPointMake(coin30Btn.position.x,
                                         coin30Btn.position.y-20);
    
    [self addChild:coin30NumNode];
    
    coin50NumNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coin50NumNode.text = @"0";
    coin50NumNode.fontSize = 30;
    coin50NumNode.fontColor = [UIColor redColor];
    coin50NumNode.position = CGPointMake(coin50Btn.position.x,
                                         coin50Btn.position.y-20);
    
    [self addChild:coin50NumNode];
    
    coin10BtnOraginPosition = coin10Btn.position;
    coin30BtnOraginPosition = coin30Btn.position;
    coin50BtnOraginPosition = coin50Btn.position;
    
    [self initWithBigCat];
}

-(void)initWithScoreLabelAndScoreByBreakGameModeLabel{
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 70;
    scoreLabel.fontColor = [UIColor redColor];
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame)+135);
    
    [self addChild:scoreLabel];
    
    scoreByBreakGameModeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreByBreakGameModeLabel.text = @"0";
    scoreByBreakGameModeLabel.fontSize = 50;
    scoreByBreakGameModeLabel.fontColor = [UIColor redColor];
    scoreByBreakGameModeLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame)+50);
    
    [self addChild:scoreByBreakGameModeLabel];
    scoreByBreakGameModeLabel.hidden = YES;
}

-(void)initWithBigCat{
    bigCat = [SKSpriteNode spriteNodeWithTexture:currentCatTextures[0]];
    bigCat.size = CGSizeMake(50, 50);
    bigCat.position = CGPointMake(self.size.width/2, 460);
    bigCat.zPosition = 10;
    
    [self addChild:bigCat];
}

-(void)bigCatBigger{
    SKAction* bigger = [SKAction scaleBy:1.1 duration:1.0];
    [bigCat runAction:bigger];
}

-(void)bigCatSmaller:(float)scale{
    SKAction* smaller = [SKAction scaleBy:0.9 duration:1.0];
    [bigCat runAction:smaller];
}

-(bool)checkBigCatEnoughBig{
    bool isBig = false;
    if(bigCat && bigCat.position.y - bigCat.size.height/2 <= scoreLabel.position.y){
        isBig = true;
    }
    return isBig;
}

-(void)bigCatEatCoin:(SKSpriteNode*)coin level:(int)coinLevel{
    SKSpriteNode* beEatedCoin = [SKSpriteNode spriteNodeWithTexture:coin.texture];
    beEatedCoin.position = CGPointMake(coin.position.x, coin.position.y);
    beEatedCoin.size = CGSizeMake(50, 50);
    beEatedCoin.zPosition = 2;
    
    CGPoint p = CGPointMake(bigCat.position.x, bigCat.position.y);
    SKAction* beEated = [SKAction moveTo:p duration:1.0];
    SKAction* end = [SKAction runBlock:^{
        [beEatedCoin removeFromParent];
//        score -= 10;
//        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
//        [self bigCatBigger];
        
        if(coinLevel==10)
            [self bigCatSmaller:0.9f];
        else if(coinLevel==30)
            [self bigCatSmaller:0.8f];
        else if(coinLevel==50)
            [self bigCatSmaller:0.7f];
        
    }];
    
    [beEatedCoin runAction:[SKAction sequence:@[beEated, end]]];
    
    [self addChild:beEatedCoin];
}

-(void)didMoveToView:(SKView *)view {
//    if (self = [super initWithSize:size]) {
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        isGameRun = true;
        catCurrentHp = DEFAULT_HP;
    
    upSpeed = 1;
    downSpeed = 1;

        createCatFrequenceRate = 2;
        delaytime = 1.0;
        randomMaxCatLimit = 3;
        randomMinCatLimit = 1;
    
        eatedCoinFrequence = 3.0;
        eatedFrequenceFasterFactor = 0.9;
        eatedFrequenceSlowerFactor = 1.1;
        
        [TextureHelper initTextures];
        [TextureHelper initCatTextures];
        [self randomCurrentCatTextures];
        
        contactQueue = [[NSMutableArray alloc] init];
        catArray = [[NSMutableArray alloc] init];
        catInRunActionArray = [[NSMutableArray alloc] init];
    catOriganalPositionY = [NSMutableArray array];
    
        [self initWithBg];
        
        textureBox = [SKSpriteNode spriteNodeWithImageNamed:@"s0"];
        textureBox.size = CGSizeMake(100, 100);
        textureBox.position = CGPointMake(200, 400);
        
        /*
        SKAction* upAction = [SKAction moveByX:0 y:50 duration:0.5];
        upAction.timingMode = SKActionTimingEaseOut;
        SKAction* downAction = [SKAction moveByX:0 y:-50 duration: 0.5]; downAction.timingMode = SKActionTimingEaseIn;
        
        SKAction * end;
        
        end = [SKAction runBlock:^{
            [coin10Btn removeAllActions];
        }];
        */
        
        [self addChild:textureBox];
     

        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self initWithScoreLabelAndScoreByBreakGameModeLabel];
        
        [self initBoard];
        
        hamer = [SKSpriteNode spriteNodeWithImageNamed:@"images"];
        hamer.size = CGSizeMake(50, 50);
        [self addChild:hamer];
        
        modeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Menu-hd"];
        modeBtn.size = CGSizeMake(42,42);
        modeBtn.anchorPoint = CGPointMake(0, 0);
        modeBtn.position = CGPointMake(self.frame.size.width - modeBtn.size.width, self.frame.size.height/2 - modeBtn.size.height*2);
        [self addChild:modeBtn];
        
        gameTimeNode = [SKLabelNode labelNodeWithText:@"00:00"];
        gameTimeNode.fontName = @"Blod";
        gameTimeNode.fontSize = 25;
        gameTimeNode.position = CGPointMake(self.frame.size.width-gameTimeNode.frame.size.width/2, self.frame.size.height-gameTimeNode.frame.size.height - 50);
        [self addChild:gameTimeNode];
        gameTimeNode.hidden = YES;
        gameTimeNode.zPosition =20;
    
        musicBtnTextures = [NSMutableArray array];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music-hd"]];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music_Select-hd"]];
        [MyUtils preparePlayBackgroundMusic:@"am_white.mp3"];
        
        id isPlayMusicObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayMusic"];
        BOOL isPlayMusic = true;
        if(isPlayMusicObject==nil){
            isPlayMusicObject = false;
        }else{
            isPlayMusic = [isPlayMusicObject boolValue];
        }
        
        if(isPlayMusic){
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
        }else{
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
        }
        
        cloudMoveSpeed = CLOUD_DEFAULT_MOVE_SPEED;
    
        if(self.mode==MyScene.GAME_BREAK){
            isCanPressStartBtn = true;
            [self initWithLabaHoleAndCoin];
            scoreLabel.hidden = NO;
            scoreByBreakGameModeLabel.hidden = NO;
            self.hpBar = [SKSpriteNode spriteNodeWithImageNamed:@"hp_bar"];
            
            self.hpBar.zPosition = 2;
            
            SKSpriteNode * hpFrame = [SKSpriteNode spriteNodeWithImageNamed:@"hp_frame"];
            hpFrame.size = CGSizeMake(self.frame.size.width, 42);
            
            hpFrame.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMaxY(self.frame) - hpFrame.size.height/2);
            
            hpFrame.zPosition = 2;
            
            [self addChild:hpFrame];
            [self addChild:self.hpBar];
            [self changeCatHpBar];
        }else if(self.mode==MyScene.GAME_INFINITY){
//            [self initWithLabaHoleAndCoin];
            isGameStart = true;
            scoreLabel.hidden = NO;
        }else{
            //            [self initWithLabaHoleAndCoin];
            gameTimeNode.hidden = NO;
            [self initGameTimer];
            isGameStart = true;
            scoreLabel.hidden = YES;
            scoreByBreakGameModeLabel.hidden = NO;
        }
    
    [self loadScore];
    [self updateLoadScore];
    
    [self loadCoin];
    [self updateCoinNumNode];
    
    if(myAdView)
        [myAdView stop];
    myAdView = [MyADView spriteNodeWithTexture:nil];
    myAdView.size = CGSizeMake(self.frame.size.width, 50);
    //        myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 35);
    myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - myAdView.size.height);
    [myAdView startAd];
    myAdView.zPosition = 1;
    myAdView.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:myAdView];
    
//    }
//    return self;
}

-(void) randomCurrentCatTextures{
    int r = arc4random_uniform(5);
    
    switch (r) {
        case 0:
            currentCatTextures = [TextureHelper cat1Textures];
            break;
        case 1:
            currentCatTextures = [TextureHelper cat2Textures];
            break;
        case 2:
            currentCatTextures = [TextureHelper cat3Textures];
            break;
        case 3:
            currentCatTextures = [TextureHelper cat4Textures];
            break;
        case 4:
            currentCatTextures = [TextureHelper cat5Textures];
            break;
        default:
            break;
    }
}

-(NSArray *) randomCatTextures{
    int r = arc4random_uniform(5);
    NSArray* randomCatTextures;
    
    switch (r) {
        case 0:
            randomCatTextures = [TextureHelper cat1Textures];
            break;
        case 1:
            randomCatTextures = [TextureHelper cat2Textures];
            break;
        case 2:
            randomCatTextures = [TextureHelper cat3Textures];
            break;
        case 3:
            randomCatTextures = [TextureHelper cat4Textures];
            break;
        case 4:
            randomCatTextures = [TextureHelper cat5Textures];
            break;
        default:
            break;
    }
    
    return randomCatTextures;
}

-(void)initBoard{
    
    for (int i = 0; i<3; i++) {
        for(int j = 0; j <3; j++){
            BeHitNode * cat = [self createCatWithPosition:CGPointMake(i*120+40, j*110+50)];
            cat.isHited = YES;
            [self addChild:cat];
            [catArray addObject:cat];
            [catOriganalPositionY addObject:[NSNumber numberWithInt:cat.position.y]];
            
            SKSpriteNode * obstac = [SKSpriteNode spriteNodeWithImageNamed:@"treatureBox01"];
            obstac.position = cat.position;
            obstac.size = CGSizeMake(cat.size.width*1.3, cat.size.height*1.3);
            [self addChild:obstac];
        }
    }
    
//    SKSpriteNode * s = [SKSpriteNode ];
    
}

-(void)setCatSequenceDelay:(float)m_delaytime{
    delaytime = m_delaytime;
}

-(SKSpriteNode*)createCatWithPosition:(CGPoint)position{
    BeHitNode * cat = [BeHitNode spriteNodeWithTexture:currentCatTextures[0]];
    cat.size = CGSizeMake(50, 50);
    cat.position = position;
    return cat;
}


//-(void)createCat{
//    
//    BeHitNode * cat = [BeHitNode spriteNodeWithTexture:currentCatTextures[0]];
//    cat.size = CGSizeMake(50, 50);
//    cat.position = CGPointMake(200, 200);
//    
//    [self addChild:cat];
//    
//    [catArray addObject:cat];
//    
//}

-(void)randomCatApearAction{
    int randomCatNum = arc4random_uniform(randomMaxCatLimit - randomMinCatLimit + 1)+randomMinCatLimit;
    
    for(int i = 0; i < randomCatNum ; i++){
        int catIndex = arc4random_uniform(catArray.count);
        
        int goodPercent = 5;
        bool isGood = arc4random_uniform(10)<goodPercent?true:false;
        
        if(![catInRunActionArray containsObject:catArray[catIndex]]){
        
            BeHitNode * cat = catArray[catIndex];
//            cat.isHited = NO;
            
            if(isGood){
                if (self.mode == GAME_INFINITY || self.mode == GAME_LIMIT){
                    int r = arc4random_uniform(3);
                    if(r==0){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_10_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money  = 10;
                    }else if(r==1){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_30_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money = 30;
                    }else if(r==2){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_50_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money = 50;
                    }
                }else{
                    if(currentMoneyLevel==10){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_10_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money  = 10;
                    }else if(currentMoneyLevel==30){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_30_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money = 30;
                    }else if(currentMoneyLevel==50){
                        cat.texture = [SKTexture textureWithImageNamed:@"coin_50_btn01"];
                        cat.beHitedTextture = cat.texture;
                        cat.money = 50;
                    }
                }
                
                cat.type = COIN;
//                cat.money = 10;
            }else{
                NSArray * tmp = [self randomCatTextures];
                cat.texture = tmp[0];
                cat.beHitedTextture = tmp[3];
                cat.type = CAT;
                cat.beHitedTextturesArray = tmp;
            }
            
            SKAction * a = [self createCatUpDownAction:catArray[catIndex] time:delaytime];
            
            cat.isHited = NO;
            
            //        SKAction * aciton = [SKAction waitForDuration:3];
            SKAction * end = [SKAction runBlock:^{
                //            [self randomCatApearAction:catArray[i]];
                [catInRunActionArray removeObject:cat];
                cat.isHited = YES;
            }];
            
            CGPoint oraginalCatPosition = CGPointMake(cat.position.x, [catOriganalPositionY[catIndex] intValue]);
            cat.position = oraginalCatPosition;
            [cat runAction:[SKAction sequence:@[a, end]]];
            
            [catInRunActionArray addObject:cat];
        }
    }
    
}

-(SKAction*)createCatUpDownAction:(SKSpriteNode*)cat time:(float)time{
    SKAction * up = [SKAction moveByX:0 y:50 duration:upSpeed];
    SKAction * duration = [SKAction waitForDuration:time];
    SKAction * down = [SKAction moveByX:0 y:-50 duration:downSpeed];
//    [cat runAction:[SKAction sequence:@[up, duration, down]]];
    return [SKAction sequence:@[up, duration, down]];
}

-(void)start{
    if(!isCanPressStartBtn)
        return;
    else
        isCanPressStartBtn = false;
    
    if((currentMoney - currentMoneyLevel) < 0){
        //        gotoBuyMoneyCoinDialog();
        isCanPressStartBtn = true;
        return;
    }
    
    displayADCount++;
    isFocusStopFallWithCoinsRun = true;
    
    SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:1.5] count:1];
    SKAction * move = [SKAction moveToX:labaHole.position.x - coin10Btn.size.width duration:1.5];
    SKAction * end = [SKAction runBlock:^{
        
        [coin10Btn removeAllActions];
        [coin30Btn removeAllActions];
        [coin50Btn removeAllActions];
        coin10Btn.zRotation = 0;
        coin30Btn.zRotation = 0;
        coin50Btn.zRotation = 0;
        coin10Btn.position = coin10BtnOraginPosition;
        coin30Btn.position = coin30BtnOraginPosition;
        coin50Btn.position = coin50BtnOraginPosition;
        
        labaHole.alpha = 0;
        isGameStart = true;
        
    }];
    
    if (currentMoneyLevel==10) {
        [coin10Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }else if(currentMoneyLevel == 30){
        [coin30Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }else{
        [coin50Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }
    
    isCanPressStartBtn = false;
    isCanPressStopBtn = true;
    
}

-(void)runCatUpAction:(SKSpriteNode*)cat{
    SKAction * up = [SKAction moveByX:0 y:50 duration:1];
    [cat runAction:up];
}

-(void)runCatBeHitAction:(BeHitNode*)cat{
    SKAction * beHit = [SKAction runBlock:^{
//        cat.texture = currentCatTextures[3];
        cat.texture = cat.beHitedTextture;
    }];
    SKAction * up = [SKAction moveByX:0 y:10 duration:0.1];
    SKAction * down = [SKAction moveByX:0 y:-10 duration:0.1];
    SKAction * end = [SKAction runBlock:^{
//        [cat removeFromParent];
//        [catArray removeObject:cat];
        
        [catInRunActionArray removeObject:cat];
    }];
    
    [cat runAction:[SKAction sequence:@[beHit, down, up, end]]];
    
    if(cat.type==CAT){
        if(cat.beHitedTextturesArray == currentCatTextures){
            if(catCurrentHp>0){
                catCurrentHp--;
                [self changeCatHpBar];
                if(catCurrentHp<=0){
                    [self catDieAndChangeToNewCat];
                }
            }
            return;
        }
        int index = [catArray indexOfObject:cat];
        CGPoint oraginalCatPosition = CGPointMake(cat.position.x, [catOriganalPositionY[index] intValue]);
        int oraginalCatzPosition = cat.zPosition;
        
        end = [SKAction runBlock:^{
            [cat removeAllActions];
            
//            [sheepArrayLeft addObject:sheep];
            
//            [self changeGamePoint];
            
//            if(isSheepTouchable){
            
//                NSLog(@"currentTime:%lf, periousTime:%lf",currentTime,periousTime);
            
//                sheep.texture = [SKTexture textureWithImageNamed:@"sheep_angry01"];
                SKAction * sheepBumpToScreen = [SKAction scaleTo:8 duration:2];
                //                        sheep.anchorPoint = CGPointMake(0.5, 0.5);
                SKAction * bumpEnd = [SKAction runBlock:^{
                    isSheepTouchable = true;
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                    [cat removeFromParent];
                    
                    cat.xScale = 1.0f;
                    cat.yScale = 1.0f;
                    cat.position = oraginalCatPosition;
                    cat.zPosition = oraginalCatzPosition;
                    [catInRunActionArray removeObject:cat];
//                    [sheepArrayLeft removeObject:sheep];
                }];
                
                cat.anchorPoint = CGPointMake(0.5, 0.5);
                cat.zPosition = 2;
                
                int randomMoveX = arc4random_uniform(self.frame.size.width/4.0) + self.frame.size.width/3.0;
                
                SKAction * bumpMove = [SKAction moveTo:CGPointMake((self.position.x + randomMoveX), cat.position.y) duration:2];
                
                isSheepTouchable = false;
                
                [cat removeAllActions];
//                [sheepArrayLeft removeObject:sheep];
            
                [cat runAction:[SKAction sequence:@[[SKAction group:@[sheepBumpToScreen, bumpMove]], bumpEnd]]];
                
                return;
        }];
    
        [cat runAction:end];
        }
}

-(void)catDieAndChangeToNewCat{
    int rewardByCatDie = (catLevel+1)*1000;
    scoreInBreakGameMode+=rewardByCatDie;
    scoreByBreakGameModeLabel.text = [NSString stringWithFormat:@"%d",scoreInBreakGameMode];
    
    SKLabelNode* label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"+%d", rewardByCatDie]];
    label.position = CGPointMake(self.frame.size.width/2 - label.frame.size.width/2, self.frame.size.height/2);
    label.fontSize = 50;
    label.fontColor = [UIColor redColor];
    label.zPosition = 2;
    [self addChild:label];
    
    __block int count=0;
    [label runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
        count++;
        label.alpha = label.alpha/(float)count*3;
    }], [SKAction waitForDuration:0.6]]] count:5], [SKAction runBlock:^{
        [label removeFromParent];
    }]]]];
    
    SKAction* die = [SKAction moveToY:self.frame.size.height+bigCat.size.height/2 duration:2.0f];
    SKAction* end = [SKAction runBlock:^{
        [self randomCurrentCatTextures];
        bigCat.texture = currentCatTextures[0];
        bigCat.size = CGSizeMake(50, 50);
        bigCat.position = CGPointMake(self.size.width/2, 460);
        
        catCurrentHp = catMaxHp+1;
        catMaxHp = catCurrentHp;
        catLevel++;
        [self changeCatHpBar];
    }];
    [bigCat runAction:[SKAction sequence:@[die, end]]];
}

-(void)setBgByGameLevel{
    backgroundNode.texture = [TextureHelper bgTextures][gameLevel];
}

-(void)enemyBeHit:(BeHitNode*)enemy{
    if([currentCatTextures containsObject:enemy.texture]){
        NSLog(@"hit the same enemy texture");
    }
    
    
    
    if(self.mode == GAME_INFINITY){
        if(enemy.type == COIN){
            score+=enemy.money;
            scoreLabel.text = [NSString stringWithFormat:@"%d",score];
            [self saveScore];
            [self reportInfinityModeScore];
        }
    }else if(self.mode == GAME_BREAK){
        if(enemy.type == COIN){
//            score+=enemy.money;
//            scoreLabel.text = [NSString stringWithFormat:@"%d",score];
            scoreInBreakGameMode+=enemy.money;
            scoreByBreakGameModeLabel.text = [NSString stringWithFormat:@"%d",scoreInBreakGameMode];
        }
    }else if(self.mode == GAME_LIMIT){
//        score++;
//        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
        scoreInBreakGameMode+=enemy.money;
        scoreByBreakGameModeLabel.text = [NSString stringWithFormat:@"%d",scoreInBreakGameMode];
    }
    
//    [self bigCatSmaller];
}

-(void)setCloudClearNumNodeText{
//    cloudClearedNumNode.text = [NSString stringWithFormat:@"%d", answerCorrectNUm];
//    cloudClearedNumNode.position = CGPointMake(cloudClearedNode.position.x + cloudClearedNode.size.width + cloudClearedNumNode.frame.size.width/2, cloudClearedNumNode.position.y);
}

-(void)reset{
    answerCorrectNUm = 0;
    [self setCloudClearNumNodeText];
}

-(void)showLeaderBoard{
    [self.gameDelegate showRankView];
}

//-(void)gameOverInInfinityGameMode{
//    [self reportLimitTimeModeScore];
//    [self saveScore];
//}

-(void)gameOverInLimitGameMode{
    [self reportLimitTimeModeScore];
    [self.gameDelegate showWinView];
}

-(void)gameOverInBreakGameMode{
    [self reportBreakGameModeScore:scoreInBreakGameMode];
    [self.gameDelegate showLoseView];
}

-(void)reportInfinityModeScore{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:score forCategory:@"com.irons.CrazySplitMoney"];
}

-(void)reportBreakGameModeScore:(int)gameScore{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:gameScore forCategory:@"com.irons.CrazySplitTime"];
}

-(void)reportLimitTimeModeScore{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:scoreInBreakGameMode forCategory:@"com.irons.CrazySplitTime"];
}

-(void)changeToInfiniteMode{
    gameTimeNode.hidden = YES;
    self.mode = MyScene.GAME_INFINITY;
    [self.gameDelegate goToGameInfinity];
//    [self reset];
//    [self setCloudClearNumNodeText];
}

-(void)changeToBreakGameMode{
    gameTimeNode.hidden = NO;
    self.mode = MyScene.GAME_BREAK;
    [self.gameDelegate goToGameBreak];
//    [self reset];
//    [self initGameTimer];
}

-(void)changeToTimeLimitMode{
    gameTimeNode.hidden = NO;
    self.mode = GAME_LIMIT;
    [self.gameDelegate goToGameLimit];
//    [self reset];
//    [self initGameTimer];
}

-(void)initGameTimer{
    if(theGameTimer!=nil){
        [theGameTimer invalidate];
         gameTime = 0;
        if(self.mode == GAME_BREAK){
            [self setGameTimeNodeText: gameTime];
        }else if(self.mode == GAME_LIMIT){
            [self setGameTimeNodeText: maxTime - gameTime];
        }
    }
    theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(countGameTime)
                                                  userInfo:nil
                                                   repeats:YES];
    //    [timers addObject:theGameTimer];
}

-(void)countGameTime{
    if(!isGameRun){
        return;
    }
    
    gameTime++;
    
    if(self.mode == GAME_BREAK){
//        if(answerCorrectNUm==GAME_LEVEL2_START_LEVEL){
//            cloudMoveSpeed = CLOUD_LEVEL2_MOVE_SPEED;
//        }else if(answerCorrectNUm==GAME_LEVEL3_START_LEVEL){
//            cloudMoveSpeed = CLOUD_LEVEL3_MOVE_SPEED;
//        }else if(answerCorrectNUm==GAME_LEVEL4_START_LEVEL){
//            cloudMoveSpeed = CLOUD_LEVEL4_MOVE_SPEED;
//        }else if(answerCorrectNUm==GAME_LEVEL5_START_LEVEL){
//            cloudMoveSpeed = CLOUD_LEVEL5_MOVE_SPEED;
//        }
//        else if(answerCorrectNUm >= GAME_SUCCESS_LEVEL){
//            cloudMoveSpeed = 10;
//        }


    }else if(self.mode == GAME_LIMIT){
        [self setGameTimeNodeText: maxTime - gameTime];
        
        if(maxTime - gameTime==0){
            [theGameTimer invalidate];
            gameTime = 0;
            
            [self getReward];

            [self gameOverInLimitGameMode];
            
//            [];
            
//            [self.gameDelegate lose];
            
        }else if(gameTime > 80){
            upSpeed = 0.25f;
            downSpeed = 0.25f;
            delaytime = 0;
            createCatFrequenceRate = 1;
        }else if(gameTime > 70){
            upSpeed = 0.25f;
            downSpeed = 0.25f;
            delaytime = 0;
            createCatFrequenceRate = 1;
        }else if(gameTime > 60){
            upSpeed = 0.3f;
            downSpeed = 0.3f;
            delaytime = 0;
            createCatFrequenceRate = 1;
            randomMaxCatLimit = 5;
            randomMinCatLimit = 3;
        }else if(gameTime > 50){
            upSpeed = 0.3f;
            downSpeed = 0.3f;
            delaytime = 0;
            createCatFrequenceRate = 1;
        }else if(gameTime > 40){
            upSpeed = 0.5f;
            downSpeed = 0.5f;
            delaytime = 0;
            createCatFrequenceRate = 1;
        }else if(gameTime > 30){
            upSpeed = 0.5f;
            downSpeed = 0.5f;
            delaytime = 0;
            randomMaxCatLimit = 4;
            randomMinCatLimit = 2;
        }else if(gameTime > 25){
            upSpeed = 0.5f;
            downSpeed = 0.5f;
            delaytime = 0;
        }else if(gameTime > 15){
            upSpeed = 0.5f;
            downSpeed = 0.5f;
            delaytime = 0.5f;
        }else if(gameTime > 5){
            upSpeed = 0.5f;
            downSpeed = 0.5f;
            
            //            upSpeed = NSTimei
        }
    }
}

-(void)updateCreateFrequence{
    if(answerCorrectNUm > 4500){
        upSpeed = 0.25f;
        downSpeed = 0.25f;
        delaytime = 0;
        createCatFrequenceRate = 1;
    }else if(answerCorrectNUm > 4000){
        upSpeed = 0.25f;
        downSpeed = 0.25f;
        delaytime = 0;
        createCatFrequenceRate = 1;
    }else if(answerCorrectNUm > 3500){
        upSpeed = 0.3f;
        downSpeed = 0.3f;
        delaytime = 0;
        createCatFrequenceRate = 1;
        randomMaxCatLimit = 5;
        randomMinCatLimit = 3;
    }else if(answerCorrectNUm > 3000){
        upSpeed = 0.3f;
        downSpeed = 0.3f;
        delaytime = 0;
        createCatFrequenceRate = 1;
    }else if(answerCorrectNUm > 2500){
        upSpeed = 0.5f;
        downSpeed = 0.5f;
        delaytime = 0;
        createCatFrequenceRate = 1;
    }else if(scoreInBreakGameMode > 2000){
        upSpeed = 0.5f;
        downSpeed = 0.5f;
        delaytime = 0;
        randomMaxCatLimit = 4;
        randomMinCatLimit = 2;
    }else if(scoreInBreakGameMode > 1500){
        upSpeed = 0.5f;
        downSpeed = 0.5f;
        delaytime = 0;
    }else if(scoreInBreakGameMode > 200){
        upSpeed = 0.5f;
        downSpeed = 0.5f;
        delaytime = 0.5f;
    }else if(scoreInBreakGameMode > 50 ){
        upSpeed = 0.5f;
        downSpeed = 0.5f;
        
        //            upSpeed = NSTimei
    }
}

-(void)setGameTimeNodeText:(int)time{
    gameTimeNode.text = [CommonUtil timeFormatted:time];
    gameTimeNode.position = CGPointMake(self.frame.size.width-gameTimeNode.frame.size.width/2, self.frame.size.height-gameTimeNode.frame.size.height - 50);
}

-(void)getReward{
//    if(answerCorrectNUm > 10){
//        int coinScore = answerCorrectNUm * 10;
//        int coin10Num = coinScore / 10;
//        int coin30Num = coinScore / 30;
//        int coin50Num = coinScore / 50;
//    }
    
    coin10NumForReward = 0;
    coin30NumForReward = 0;
    coin50NumForReward = 0;
    if(scoreInBreakGameMode > 10){
        int coinScore = scoreInBreakGameMode;
        coin10NumForReward = coinScore / 10;
        coin30NumForReward = coinScore / 30;
        coin50NumForReward = coinScore / 50;
        
        coin10Num += coin10NumForReward;
        coin30Num += coin30NumForReward;
        coin50Num += coin50NumForReward;
        
        [self saveCoin];
        [self updateCoinNumNode];
    }
}

-(void)loadCoin{
    coin10Num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedcoin10Num"] intValue];
    coin30Num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedcoin30Num"] intValue];
    coin50Num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedcoin50Num"] intValue];
}

-(void)saveCoin{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:coin10Num] forKey:@"savedcoin10Num"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:coin30Num] forKey:@"savedcoin30Num"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:coin50Num] forKey:@"savedcoin50Num"];
}

-(void)saveScore{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:score] forKey:@"score"];
}

-(void)loadScore{
    score = [[[NSUserDefaults standardUserDefaults] objectForKey:@"score"] intValue];
}

-(void)updateLoadScore{
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

-(void)updateCoinNumNode{
    coin10NumNode.text = [NSString stringWithFormat:@"%d", coin10Num];
    coin30NumNode.text = [NSString stringWithFormat:@"%d", coin30Num];
    coin50NumNode.text = [NSString stringWithFormat:@"%d", coin50Num];
}

-(void)setAdClickable:(bool)clickable{
    if (myAdView!=nil) {
        [myAdView setAdClickable:clickable];
    }
}

-(void)setGameRun:(bool)isrun {
//    [self setViewRun:isrun];
//    [self setPauseBtnHidden:isrun];
    
    isGameRun = isrun;
    
    for (int i = 0; i < [self children].count; i++) {
        SKNode * n = [self children][i];
        n.paused = !isrun;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [myAdView touchesBegan:touches withEvent:event];
    
    for (int i = 0; i < catArray.count; i++) {
        if (CGRectContainsPoint([catArray[i] calculateAccumulatedFrame], location)) {
            BeHitNode * cat = ((BeHitNode*)catArray[i]);
            if (cat.isHited) {
                break;
            }
            
            [self runCatBeHitAction:catArray[i]];
            
//            hitEffectAction = [];
            
            cat.isHited = YES;
            
            hamer.position = CGPointMake(cat.position.x + hamer.size.width, cat.position.y+cat.size.height);
            hamer.anchorPoint = CGPointMake(1, 0);
            SKAction * hamerHitCat = [SKAction rotateToAngle: M_PI/ 3.0 duration:0.1];
            SKAction * hamerHitCatResume = [SKAction rotateToAngle: M_PI/ 7.0 duration:0.1];
//            [hamer runAction:hamerHitCat];
            [hamer runAction:[SKAction sequence:@[hamerHitCat, hamerHitCatResume]]];
            [self enemyBeHit:cat];
        }
    }
    

    
    if(CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)){
        //        rankBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        
        [self.gameDelegate showRankView];
        return;
    }else if(CGRectContainsPoint(modeBtn.calculateAccumulatedFrame, location)){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"InfinityMode", @""),NSLocalizedString(@"BreakthroughMode", @""), NSLocalizedString(@"TimeLimitMode", @""), nil];
        [actionSheet showInView:self.view];
        return;
    }else if(CGRectContainsPoint(musicBtn.calculateAccumulatedFrame, location)){
        if([MyUtils isBackgroundMusicPlayerPlaying]){
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isPlayMusic"];
        }else{
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPlayMusic"];
        }
        return;
    }
    
    if (self.mode==MyScene.GAME_BREAK){
        if(isGameStart){
            if(CGRectContainsPoint([coin10Btn calculateAccumulatedFrame], location)){
                //                currentMoneyLevel = 10;
                [self bigCatEatCoin:coin10Btn level:10];
            }else if(CGRectContainsPoint([coin30Btn calculateAccumulatedFrame], location)){
                //                currentMoneyLevel = 30;
                [self bigCatEatCoin:coin30Btn level:30];
            }else if(CGRectContainsPoint([coin50Btn calculateAccumulatedFrame], location)){
                //                currentMoneyLevel = 50;
                [self bigCatEatCoin:coin50Btn level:50];
            }
//            [self start];
            //            return;
        }else{
            if(CGRectContainsPoint([coin10Btn calculateAccumulatedFrame], location)){
                currentMoneyLevel = 10;
            }else if(CGRectContainsPoint([coin30Btn calculateAccumulatedFrame], location)){
                currentMoneyLevel = 30;
            }else if(CGRectContainsPoint([coin50Btn calculateAccumulatedFrame], location)){
                currentMoneyLevel = 50;
            }
            [self start];
        }
        
        
    }
    
    gameLevel++;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //        [self changeToInfiniteMode];
        willChangeGameMode = GAME_INFINITY;
    }else if(buttonIndex==1){
        //        [self changeToBreakGameMode];
        willChangeGameMode = GAME_BREAK;
//        [self.gameDelegate goToGameBreak];
    }else if(buttonIndex==2){
        //        [self changeToTimeLimitMode];
        willChangeGameMode = GAME_LIMIT;
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if(!isGameRun)
        return;
    
    /* Called before each frame is rendered */
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    if([self checkBigCatEnoughBig]){
        //game over
        isGameRun = false;
        [self gameOverInBreakGameMode];
//        [self.gameDelegate restartGame];
    }
    
    
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    self.lastSpawnEatedCoinTimeInterval += timeSinceLast;
    self.lastCreateCatTimeInterval += timeSinceLast;
    
//    [self processContactsForUpdate];
    
    if(isGameStart && self.mode==MyScene.GAME_BREAK && self.lastSpawnEatedCoinTimeInterval >= eatedCoinFrequence){
        self.lastSpawnEatedCoinTimeInterval = 0;
//        [self bigCatEatCoin];
        [self bigCatBigger];
        [self updateCreateFrequence];
    }
    
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;
        
        if (willChangeGameMode != NONE_MODE) {
            self.mode = willChangeGameMode;
            switch (self.mode) {
                case GAME_INFINITY:
                    [self changeToInfiniteMode];
                    break;
                case GAME_BREAK:
                    [self initWithLabaHoleAndCoin];
                    [self changeToBreakGameMode];
                    break;
                case GAME_LIMIT:
                    [self changeToTimeLimitMode];
                    break;
                default:
                    break;
            }
            willChangeGameMode = NONE_MODE;
            return;
        }
        
    }else if(self.lastCreateCatTimeInterval > 0.1){
        self.lastCreateCatTimeInterval = 0;
        
        if(isGameStart){
            
            ccount++;
            
            if(ccount>=createCatFrequenceRate)    {
                
                int continueAttackCounter = 0;
                
                int r = arc4random_uniform(40);
                
                
                if(catInRunActionArray.count==0){
//                    [self setCatSequenceDelay:0.5];
                    [self randomCatApearAction];
                }
                
                //            [self randomNewCoin];
                
                ccount = 0;
            }
            
        }
    }
    
    
}

+(int)GAME_BREAK{
    return GAME_BREAK;
}

+(int)GAME_LIMIT{
    return GAME_LIMIT;
}

+(int)GAME_INFINITY{
    return GAME_INFINITY;
}

-(int)getGameTime{
    return gameTime;
}

-(MODE)getMode{
    return self.mode;
}

-(int)getScore{
    return score;
}

-(int)getScoreInBreakGameMode{
    return scoreInBreakGameMode;
}

-(int)getCoin10ForReward{
    return coin10NumForReward;
}

-(int)getCoin30ForReward{
    return coin30NumForReward;
}

-(int)getCoin50ForReward{
    return coin50NumForReward;
}

-(void)changeCatHpBar {
    float hpBarWidth = self.frame.size.width/((float)catMaxHp/catCurrentHp);
    
    self.hpBar.size = CGSizeMake(hpBarWidth, 42);
    
    self.hpBar.anchorPoint = CGPointMake(0.5, 0.5);
    
    float hpBarOffsetX = self.frame.size.width/10 - hpBarWidth/10;
    
    self.hpBar.position = CGPointMake(CGRectGetMinX(self.frame) + hpBarWidth/2 + hpBarOffsetX,
                                      CGRectGetMaxY(self.frame) - self.hpBar.size.height/2);
}

@end
