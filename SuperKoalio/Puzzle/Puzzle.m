//
//  Puzzle.m
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 24/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "Puzzle.h"

@implementation Puzzle

-(id)initCirclePuzzleWithSize:(CGSize)size puzzlePosition:(CGPoint)puzzlePosition{
        self = [super init];
        if (self) {
            self.puzzleSize = size;
            self.verificationTolerance = 8;
            self.puzzleShadowOpacity = 0.5;
            self.puzzleBlankPosition = CGPointZero;
            self.puzzlePosition = puzzlePosition;
        }
        return self;
}


- (void)setPuzzlePosition:(CGPoint)puzzlePosition {
    
    
    // Limit range
    puzzlePosition.x = MAX(0, puzzlePosition.x);
//    puzzlePosition.x = MIN([self puzzleMaxX], puzzlePosition.x);
    puzzlePosition.y = MAX(0, puzzlePosition.y);
//    puzzlePosition.y = MIN([self puzzleMaxY], puzzlePosition.y);
    // Reset shadow
    self.puzzleImageContainerView.layer.shadowOpacity = self.puzzleShadowOpacity;
    
    // Set puzzle image container position
    [self puzzleContainerPosition:CGPointMake(puzzlePosition.x - _puzzleBlankPosition.x,
                                                 puzzlePosition.y - _puzzleBlankPosition.y)];
}

- (void)setPuzzleShadowOpacity:(CGFloat)puzzleShadowOpacity {
    _puzzleShadowOpacity = puzzleShadowOpacity;
    self.puzzleImageContainerView.layer.shadowOpacity = puzzleShadowOpacity;
}




- (void)setPuzzleBlankPosition {
    // Reset shadow
//    _puzzleImageContainerView.layer.shadowOpacity = _puzzleShadowOpacity;
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


-(void)createPuzzleImageContainerViewWithBounds:(CGRect)bounds{

// Puzzle piece container view
self.puzzleImageContainerView = [[UIView alloc] initWithFrame:CGRectMake(
                                                                                self.puzzleContainerPosition.x, self.puzzleContainerPosition.y,
                                                                                CGRectGetWidth(bounds), CGRectGetHeight(bounds))];
self.puzzleImageContainerView.backgroundColor = [UIColor clearColor];
self.puzzleImageContainerView.userInteractionEnabled = NO;
    
//self.puzzleImageContainerView.layer.shadowColor = _puzzleShadowColor.CGColor;
//self.puzzleImageContainerView.layer.shadowRadius = _puzzleShadowRadius;
//self.puzzleImageContainerView.layer.shadowOpacity = _puzzleShadowOpacity;
//self.puzzleImageContainerView.layer.shadowOffset = _puzzleShadowOffset;

}






@end
