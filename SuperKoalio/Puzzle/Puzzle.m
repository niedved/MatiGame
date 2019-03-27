//
//  Puzzle.m
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 24/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "Puzzle.h"

@implementation Puzzle

static CGFloat kTTGPuzzleAnimationDuration = 0.3;


-(id)initCirclePuzzleWithSize:(CGSize)size puzzleSlotPosition:(CGPoint)puzzleSlotPosition  puzzlePosition:(CGPoint)puzzlePosition tag:(int)tag{
        self = [super init];
        if (self) {
            self.puzzleSize = size;
            self.verificationTolerance = 8;
            self.puzzleBlankPosition = puzzleSlotPosition;
            [self setPuzzlePositionValue: puzzlePosition];
            self.draging = NO;
            self.tag = tag;
        }
        return self;
}

-(void)showPosition{
    NSLog(@"puzzle position: %f,%f", self.puzzlePosition.x,self.puzzlePosition.y );
}
-(CGRect)getPuzzleRect{
    return CGRectMake(self.puzzlePosition.x, self.puzzlePosition.y, self.puzzleSize.width, self.puzzleSize.height);
//    NSLog(@"puzzle position: %f,%f", self.puzzlePosition.x,self.puzzlePosition.y );
}

-(void)movePuzzleWithAnimation: (CGPoint)position{
    [UIView animateWithDuration:kTTGPuzzleAnimationDuration animations:^{
        [self setPuzzlePositionValue:position];
    }];
}

- (void)setPuzzlePositionValue:(CGPoint)puzzlePosition {
    // Limit range
    puzzlePosition.x = MAX(0, puzzlePosition.x);
    puzzlePosition.y = MAX(0, puzzlePosition.y);
    self.puzzlePosition = puzzlePosition;
    // Reset shadow
    self.puzzleImageContainerView.layer.shadowOpacity = 0.5f;
    
    // Set puzzle image container position
    [self puzzleContainerPosition:CGPointMake(puzzlePosition.x - _puzzleBlankPosition.x,
                                                 puzzlePosition.y - _puzzleBlankPosition.y)];
    
}

-(BOOL)positionInsidePuzzle: (CGPoint)position{
    CGRect rect = [self getPuzzleRect];
    return CGRectContainsPoint(rect, position);
}




- (void)setPuzzleBlankPosition {
    // Set puzzle image container position
    [self puzzleContainerPosition:CGPointMake(0,0)];
}

// Puzzle container position

- (void)puzzleContainerPosition:(CGPoint)puzzleContainerPosition {
    self.puzzleContainerPosition = puzzleContainerPosition;
    CGRect frame = self.puzzleImageContainerView.frame;
    frame.origin = puzzleContainerPosition;
    self.puzzleImageContainerView.frame = frame;
}

-(void)preaparePuzzleImageView{
    // Puzzle piece imageView
    self.puzzleImageView = [[UIImageView alloc] initWithFrame:self.puzzleImageContainerView.bounds];
    
    
    self.puzzleImageView.userInteractionEnabled = NO;
    self.puzzleImageView.contentMode = UIViewContentModeScaleToFill;
    self.puzzleImageView.backgroundColor = [UIColor clearColor];
    [self.puzzleImageContainerView addSubview:self.puzzleImageView];
}

-(void)createPuzzleImageContainerViewWithBounds:(CGRect)bounds{

// Puzzle piece container view
self.puzzleImageContainerView = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                self.puzzleContainerPosition.x, self.puzzleContainerPosition.y,
                                                                                CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
self.puzzleImageContainerView.backgroundColor = [UIColor clearColor];
self.puzzleImageContainerView.userInteractionEnabled = NO;
    
    
    [self preaparePuzzleImageView];
    

    
}







@end
