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
- (void)puzzleVerifyView:(TTGPuzzleVerifyView *)puzzleVerifyView didChangedVerification:(BOOL)isVerified puzzle:(Puzzle*)puzzle;
-(void)playYEAH;
@end

/**
 * TTGPuzzleVerifyView
 */
@interface TTGPuzzleVerifyView : UIView
@property (nonatomic, strong) UIImage *image; // Image for verification
@property (nonatomic, strong) Puzzle *puzzle1; // Puzzle
@property (nonatomic, strong) Puzzle *puzzle2; // Puzzle
@property (nonatomic, strong) Puzzle *puzzle3; // Puzzle
@property (nonatomic, strong) Puzzle *puzzleCurrentlyDraging; // Puzzle

@property (nonatomic, assign) BOOL draging;


// Callback
@property (nonatomic, weak) id <TTGPuzzleVerifyViewDelegate> delegate; // Callback delegate



@end
