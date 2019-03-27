//
//  TTGPuzzleVerifyView.h
//  Pods
//
//  Created by tutuge on 2016/12/10.
//
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"

/**
 * TTGPuzzleVerifyView pattern type
 */
typedef NS_ENUM(NSInteger, TTGPuzzleVerifyPattern) {
    TTGPuzzleVerifyClassicPattern = 0, // Default
    TTGPuzzleVerifySquarePattern,
    TTGPuzzleVerifyCirclePattern
};

@class TTGPuzzleVerifyView;

/**
 * Verification changed callback delegate
 */
@protocol TTGPuzzleVerifyViewDelegate <NSObject>
@optional
- (void)puzzleVerifyView:(TTGPuzzleVerifyView *)puzzleVerifyView didChangedVerification:(BOOL)isVerified;

- (void)puzzleVerifyView:(TTGPuzzleVerifyView *)puzzleVerifyView didChangedPuzzlePosition:(CGPoint)newPosition
             xPercentage:(CGFloat)xPercentage yPercentage:(CGFloat)yPercentage;
@end

/**
 * TTGPuzzleVerifyView
 */
@interface TTGPuzzleVerifyView : UIView
@property (nonatomic, strong) UIImage *image; // Image for verification
@property (nonatomic, strong) Puzzle *puzzle1; // Puzzle
@property (nonatomic, strong) Puzzle *puzzle2; // Puzzle
@property (nonatomic, strong) Puzzle *puzzle3; // Puzzle

// Puzzle pattern, default is TTGPuzzleVerifyClassicPattern
@property (nonatomic, assign) TTGPuzzleVerifyPattern puzzlePattern;

// Puzzle current X and Y position percentage, range: [0, 1]
@property (nonatomic, assign) CGFloat puzzleXPercentage;
@property (nonatomic, assign) CGFloat puzzleYPercentage;

// Verification
@property (nonatomic, assign, readonly) BOOL isVerified; // Verification boolean

// Enable
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL draging;

/**
 * Style
 */


// Callback
@property (nonatomic, weak) id <TTGPuzzleVerifyViewDelegate> delegate; // Callback delegate
@property (nonatomic, copy) void (^verificationChangeBlock)(TTGPuzzleVerifyView *puzzleVerifyView, BOOL isVerified); // verification changed callback block


/**
 Complete verification. Call this with set the puzzle to its original position and fill the blank.

 @param withAnimation if show animation
 */
- (void)completeVerificationWithAnimation:(BOOL)withAnimation;

@end
