//
//  PuzzleViewController.m
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 20/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "PuzzleViewController.h"
#import "TTGPuzzleVerifyView.h"

@interface PuzzleViewController ()<TTGPuzzleVerifyViewDelegate>

@property (weak, nonatomic) IBOutlet TTGPuzzleVerifyView *puzzleVerifyView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property UIImage *picture;

@end

@implementation PuzzleViewController


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
    
    [self preapreRandom];
    
}


-(void)preapreRandom{
    _puzzleVerifyView.delegate = self;
    _puzzleVerifyView.image = _picture;
}

-(void)reloadVC{
    //    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    //    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    //    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
    
//    [self.navigationController pushViewController:[[TTGCustomPatternVC alloc] init] animated:YES];
}


#pragma mark - TTGPuzzleVerifyViewDelegate

- (void)puzzleVerifyView:(TTGPuzzleVerifyView *)puzzleVerifyView didChangedVerification:(BOOL)isVerified puzzle:(Puzzle*)puzzle {
    if ([_puzzleVerifyView isVerified]) {
        [_puzzleVerifyView completeVerificationWithAnimation:YES puzzle:puzzle];
        _puzzleVerifyView.enable = NO;
        [self playYEAH];
        
        [self performSelector:@selector(reloadVC) withObject:nil afterDelay:2.0];
        
        
    }
}



@end
