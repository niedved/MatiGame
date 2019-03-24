//
//  TTGCustomPatternVC.m
//  TTGPuzzleVerify
//
//  Created by tutuge on 2016/12/11.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import "TTGCustomPatternVC.h"
#import "TTGPuzzleVerifyView.h"


@interface TTGCustomPatternVC () <TTGPuzzleVerifyViewDelegate>
@property (weak, nonatomic) IBOutlet TTGPuzzleVerifyView *puzzleVerifyView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@end

@implementation TTGCustomPatternVC


-(void)playYEAH{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Yeah" ofType:@"mp3"]];
    
    NSError *error;
    self.yeahMusicPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url error:&error];
    
    
    [self.yeahMusicPlayer prepareToPlay];
    [self.yeahMusicPlayer play];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray* aPics = [[NSMutableArray alloc] init];
    [aPics addObject:[UIImage imageNamed:@"pic1"]];
    [aPics addObject:[UIImage imageNamed:@"pic2"]];
    [aPics addObject:[UIImage imageNamed:@"pic3"]];
    [aPics addObject:[UIImage imageNamed:@"pic4"]];
    
    NSUInteger randomIndex = arc4random() % aPics.count;
    _picture = [aPics objectAtIndex:randomIndex];
    [_bgImageView setImage:_picture];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    // add the effect view to the image view
    [self.bgImageView addSubview:effectView];
    
    
    
    _puzzleVerifyView.delegate = self;
    
    [self preapreRandom];
    
}

-(void)preapreRandom{
    [_nextButton setTitle:@"" forState:UIControlStateNormal];
//    Int.random(in: 1...100);
    _puzzleVerifyView.image = _picture;
    _puzzleVerifyView.puzzleBlankPosition = CGPointMake(120, 50);
    _puzzleVerifyView.puzzlePosition = CGPointMake(10, 10);
    _puzzleVerifyView.puzzleXPercentage = 0.2;
    _puzzleVerifyView.puzzleBlankAlpha = 0.2;
    
    _puzzleVerifyView.puzzlePattern = TTGPuzzleVerifyCustomPattern;
    _puzzleVerifyView.customPuzzlePatternPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 120, 120) cornerRadius:40];
    
    _puzzleVerifyView.puzzleBlankInnerShadowColor = [UIColor blackColor];
    _puzzleVerifyView.puzzleBlankInnerShadowRadius = 12;
    _puzzleVerifyView.puzzleBlankInnerShadowOpacity = 0.8;
    _puzzleVerifyView.puzzleBlankInnerShadowOffset = CGSizeMake(2, 2);
    
    _puzzleVerifyView.puzzleShadowColor = [UIColor redColor];
    _puzzleVerifyView.puzzleShadowRadius = 6;
    _puzzleVerifyView.puzzleShadowOpacity = 0.6;
    _puzzleVerifyView.puzzleShadowOffset = CGSizeMake(2, 2);
    
}

-(IBAction)randomImage:(id)sender{
    [self preapreRandom];
}

-(void)reloadVC{
//    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
//    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
//    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:[[TTGCustomPatternVC alloc] init] animated:YES];
}


#pragma mark - TTGPuzzleVerifyViewDelegate

- (void)puzzleVerifyView:(TTGPuzzleVerifyView *)puzzleVerifyView didChangedVerification:(BOOL)isVerified {
    if ([_puzzleVerifyView isVerified]) {
        [_puzzleVerifyView completeVerificationWithAnimation:YES];
        _puzzleVerifyView.enable = NO;
        [self playYEAH];
        
        [self performSelector:@selector(reloadVC) withObject:nil afterDelay:2.0];
        
        
    }
}

@end
