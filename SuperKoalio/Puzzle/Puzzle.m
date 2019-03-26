//
//  Puzzle.m
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 24/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import "Puzzle.h"

@implementation Puzzle

-(id)initCirclePuzzleWithSize:(CGSize)size puzzleSlotPosition:(CGPoint)puzzleSlotPosition  puzzlePosition:(CGPoint)puzzlePosition tag:(int)tag{
        self = [super init];
        if (self) {
            self.puzzleSize = size;
            self.verificationTolerance = 8;
            self.puzzleBlankPosition = puzzleSlotPosition;
            self.puzzlePosition = puzzlePosition;
            self.tag = tag;
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
    self.puzzleImageContainerView.layer.shadowOpacity = 0.5f;
    
    // Set puzzle image container position
    [self puzzleContainerPosition:CGPointMake(puzzlePosition.x - _puzzleBlankPosition.x,
                                                 puzzlePosition.y - _puzzleBlankPosition.y)];
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
    
//self.puzzleImageContainerView.layer.shadowColor = _puzzleShadowColor.CGColor;
//self.puzzleImageContainerView.layer.shadowRadius = _puzzleShadowRadius;
//self.puzzleImageContainerView.layer.shadowOffset = _puzzleShadowOffset;

    
    [self preaparePuzzleImageView];
    

    
}







@end
