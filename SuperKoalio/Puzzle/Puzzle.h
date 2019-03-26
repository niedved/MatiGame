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

// Puzzle rect size，not for TTGPuzzleVerifyCustomPattern pattern
@property (nonatomic, assign) CGSize puzzleSize;

// Puzzle blank position
@property (nonatomic, assign) CGPoint puzzleBlankPosition;

// Puzzle current position
@property (nonatomic, assign) CGPoint puzzlePosition;

@property (nonatomic, assign) CGFloat verificationTolerance; // Verification tolerance, default is 8

@property (nonatomic, assign) CGPoint puzzleContainerPosition;
@property (nonatomic, strong) UIView *puzzleImageContainerView;
@property (nonatomic, strong) UIImageView *puzzleImageView;


- (void)setPuzzlePosition:(CGPoint)puzzlePosition;
- (void)setPuzzleBlankPosition;

//-(id)initAsCircle
-(void)createPuzzleImageContainerViewWithBounds:(CGRect)bounds;
-(id)initCirclePuzzleWithSize:(CGSize)size puzzleSlotPosition:(CGPoint)puzzleSlotPosition  puzzlePosition:(CGPoint)puzzlePosition  tag:(int)tag;
@end

NS_ASSUME_NONNULL_END
