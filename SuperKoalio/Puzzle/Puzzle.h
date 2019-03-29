//
//  Puzzle.h
//  SuperKoalio
//
//  Created by Marcin Niedzwiecki on 24/03/2019.
//  Copyright © 2019 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Puzzle : NSObject
@property int tag;


@property (nonatomic, assign) BOOL enable;


// Puzzle rect size，not for TTGPuzzleVerifyCustomPattern pattern
@property (nonatomic, assign) CGSize puzzleSize;

// Puzzle blank position
@property (nonatomic, assign) CGPoint puzzleBlankPosition;

// Puzzle current position
@property (nonatomic, assign) CGPoint puzzlePosition;

@property (nonatomic, assign) CGFloat verificationTolerance; // Verification tolerance, default is 8

@property (nonatomic, assign) CGPoint puzzleContainerPosition;


@property (nonatomic, strong) UIImageView *puzzleImageView;
@property (nonatomic, strong) UIView *puzzleSlotImageView;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) BOOL draging;

-(void)movePuzzleWithAnimation: (CGPoint)position;
- (void)setPuzzlePositionValue:(CGPoint)puzzlePosition;
- (void)setPuzzleBlankPosition;

- (UIBezierPath *)getNewScaledPuzzledPath;

-(BOOL)positionInsidePuzzle: (CGPoint)position;
// Puzzle position
- (CGPoint)puzzlePosition;
-(void)showPosition;
-(CGRect)getPuzzleRect;

- (BOOL)isVerified;
-(void)checkPuzzleInSlot;
/*
Complete verification. Call this with set the puzzle to its original position and fill the blank.

@param withAnimation if show animation
*/
- (void)completeVerificationWithAnimation:(BOOL)withAnimation;
-(id)initCirclePuzzleWithSize:(CGSize)size puzzleSlotPosition:(CGPoint)puzzleSlotPosition  puzzlePosition:(CGPoint)puzzlePosition  tag:(int)tag color:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
