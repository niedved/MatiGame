//
//  Puzzle.m
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 24/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "Puzzle.h"

#import "TTGPuzzleVerifyView.h"
#import "TTGPuzzleVerifyView+PatternPathProvider.h"

@implementation Puzzle

static CGFloat kTTGPuzzleAnimationDuration = 0.3;


-(id)initCirclePuzzleWithSize:(CGSize)size puzzleSlotPosition:(CGPoint)puzzleSlotPosition  puzzlePosition:(CGPoint)puzzlePosition tag:(int)tag color:(UIColor*)color{
        self = [super init];
        if (self) {
            self.puzzleSize = size;
            self.color = color;
            self.verificationTolerance = 8;
            self.puzzleBlankPosition = puzzleSlotPosition;
            [self setPuzzlePositionValue: puzzlePosition];
            self.draging = NO;
            self.tag = tag;
            self.enable = YES;
            [self preaparePuzzleSlotImage];
            
            [self preaparePuzzleImageView];
            
        }
        return self;
}

-(void)preaparePuzzleSlotImage{
    self.puzzleSlotImageView = [[UIView alloc] initWithFrame:CGRectMake(self.puzzleBlankPosition.x, self.puzzleBlankPosition.y, self.puzzleSize.width, self.puzzleSize.height)];
    self.puzzleSlotImageView.layer.borderColor = self.color.CGColor;
    self.puzzleSlotImageView.layer.borderWidth = 2.0f;
    [self.puzzleSlotImageView setBackgroundColor:[self.color colorWithAlphaComponent:0.15f]];
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
    self.puzzleImageView.layer.shadowOpacity = 0.5f;
    CGRect frame = self.puzzleImageView.frame;
    frame.origin = puzzlePosition;
    self.puzzleImageView.frame = frame;
}

-(BOOL)positionInsidePuzzle: (CGPoint)position{
    [self showPosition];
    CGRect rect = [self getPuzzleRect];
    BOOL inside = CGRectContainsPoint(rect, position);
    NSLog(@"%s: %d", __FUNCTION__, inside );
    return inside;
}




- (void)setPuzzleBlankPosition {
    // Set puzzle image container position
}

- (UIBezierPath *)getNewScaledPuzzledPath {
    UIBezierPath *path = nil;
    
    path = [UIBezierPath bezierPathWithCGPath:[TTGPuzzleVerifyView verifyPathForPattern:TTGPuzzleVerifyCirclePattern].CGPath];
    // Apply scale transform
    [path applyTransform:CGAffineTransformMakeScale(
                                                    self.puzzleSize.width / path.bounds.size.width,
                                                    self.puzzleSize.height / path.bounds.size.height)];
    
    // Apply position transform
    [path applyTransform:CGAffineTransformMakeTranslation(
                                                          self.puzzleBlankPosition.x - path.bounds.origin.x,
                                                          self.puzzleBlankPosition.y - path.bounds.origin.y)];
    
    return path;
}




-(void)preaparePuzzleImageView{
    // Puzzle piece imageView
    self.puzzleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.puzzlePosition.x, self.puzzlePosition.y, self.puzzleSize.width, self.puzzleSize.width)];
    self.puzzleImageView.layer.borderColor = self.color.CGColor;
    self.puzzleImageView.layer.borderWidth = 1.0f;
    self.puzzleImageView.backgroundColor = [self.color colorWithAlphaComponent:0.7f];
    
    self.puzzleImageView.userInteractionEnabled = NO;
    self.puzzleImageView.contentMode = UIViewContentModeScaleToFill;
}


-(void)checkPuzzleInSlot{
    if( [self isVerified] ){
        NSLog(@"VERIFIED!!!");
    }
}

/*
Complete verification. Call this with set the puzzle to its original position and fill the blank.

@param withAnimation if show animation
*/
- (void)completeVerificationWithAnimation:(BOOL)withAnimation{
    if (withAnimation) {
        [UIView animateWithDuration:kTTGPuzzleAnimationDuration animations:^{
            if (_enable) {
                [self setPuzzlePositionValue:self.puzzleBlankPosition];
            }
            self.puzzleImageView.layer.shadowOpacity = 0;
        }];
    } else {
        if (_enable) {
            [self setPuzzlePositionValue:self.puzzleBlankPosition];
        }
        self.puzzleImageView.layer.shadowOpacity = 0;
    }
}


- (BOOL)isVerified {
    return fabsf(self.puzzlePosition.x - self.puzzleBlankPosition.x) <= self.verificationTolerance &&
    fabsf(self.puzzlePosition.y - self.puzzleBlankPosition.y) <= self.verificationTolerance;
}






@end
