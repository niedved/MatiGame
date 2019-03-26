//
//  TTGPuzzleVerifyView.m
//  Pods
//
//  Created by tutuge on 2016/12/10.
//
//

#import "TTGPuzzleVerifyView.h"
#import "TTGPuzzleVerifyView+PatternPathProvider.h"

static CGFloat kTTGPuzzleAnimationDuration = 0.3;

@interface TTGPuzzleVerifyView ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) CAShapeLayer *backInnerShadowLayer;

@property (nonatomic, strong) UIImageView *frontImageView;


@property (nonatomic, assign) BOOL lastVerification;
@end

@implementation TTGPuzzleVerifyView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

// Back puzzle blank image view
-(void)preapreBackImageView{
    self.backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backImageView.userInteractionEnabled = NO;
    self.backImageView.contentMode = UIViewContentModeScaleToFill;
    self.backImageView.alpha = 0.5f;
    [self addSubview:self.backImageView];
    
    [self preapreBackImageView_shadowForPuzzleBlankSpace];
    
}

-(void)preapreBackImageView_shadowForPuzzleBlankSpace{
    // Inner shadow layer
    self.backInnerShadowLayer = [CAShapeLayer layer];
    self.backInnerShadowLayer.frame = self.bounds;
    self.backInnerShadowLayer.fillRule = kCAFillRuleEvenOdd;
    self.backInnerShadowLayer.shadowColor =  [UIColor orangeColor].CGColor;
    self.backInnerShadowLayer.shadowRadius = 15;
    self.backInnerShadowLayer.shadowOpacity = 0.9;
    self.backInnerShadowLayer.shadowOffset = CGSizeMake(0, 0);
}
    
-(void)preapreFrontImageView{
    self.frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.frontImageView.userInteractionEnabled = NO;
    self.frontImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.frontImageView];
}

-(void)preparePuzzles{
    self.puzzle1 = [[Puzzle alloc] initCirclePuzzleWithSize:CGSizeMake(100, 100) puzzleSlotPosition:CGPointMake(40, 10) puzzlePosition:CGPointMake(40,100) tag:1]; //o,o srodek
    [self.puzzle1 createPuzzleImageContainerViewWithBounds: self.bounds];
    [self addSubview:self.puzzle1.puzzleImageContainerView];
    
    
    self.puzzle2 = [[Puzzle alloc] initCirclePuzzleWithSize:CGSizeMake(100, 100) puzzleSlotPosition:CGPointMake(240, 10) puzzlePosition:CGPointMake(240,100) tag:2]; //o,o srodek
    [self.puzzle2 createPuzzleImageContainerViewWithBounds: self.bounds];
    [self addSubview:self.puzzle2.puzzleImageContainerView];
    
    
    self.puzzle3 = [[Puzzle alloc] initCirclePuzzleWithSize:CGSizeMake(100, 100) puzzleSlotPosition:CGPointMake(440, 10) puzzlePosition:CGPointMake(440,100) tag:3]; //o,o srodek
    [self.puzzle3 createPuzzleImageContainerViewWithBounds: self.bounds];
    [self addSubview:self.puzzle3.puzzleImageContainerView];
    
    
    
}


- (void)commonInit {
    if (_backImageView) {
        return;
    }

    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;

    // Init value
    self.enable = YES;
    self.puzzlePattern = TTGPuzzleVerifyCirclePattern;
    
    // Back puzzle blank image view
    [self preapreBackImageView];
    // Front puzzle hole image view
    [self preapreFrontImageView];
    // Create puzzle
    [self preparePuzzles];
    
    // Pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer new];
    [panGestureRecognizer addTarget:self action:@selector(onPanGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Public methods

- (void)completeVerificationWithAnimation:(BOOL)withAnimation {
    if (withAnimation) {
        [UIView animateWithDuration:kTTGPuzzleAnimationDuration animations:^{
            if (_enable) {
                    [self.puzzle1 setPuzzlePosition:self.puzzle1.puzzleBlankPosition];
            }
            self.puzzle1.puzzleImageContainerView.layer.shadowOpacity = 0;
        }];
    } else {
        if (_enable) {
            [self.puzzle1 setPuzzlePosition:self.puzzle1.puzzleBlankPosition];
        }
        self.puzzle1.puzzleImageContainerView.layer.shadowOpacity = 0;
    }
}

#pragma mark - Pan gesture

- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint panLocation = [panGestureRecognizer locationInView:self];

    // New position
    CGPoint position = CGPointZero;
    position.x = panLocation.x - self.puzzle1.puzzleSize.width / 2;
    position.y = panLocation.y - self.puzzle1.puzzleSize.height / 2;

    // Update position
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"p1: %f , %f", self.puzzle1.puzzleImageView.frame.size.width, self.puzzle1.puzzleImageView.frame.size.height );
        if ( [self.puzzle1.puzzleImageView pointInside:panLocation withEvent:nil] ) {
            // Point lies inside the bounds
            NSLog(@"inside: ");
            // Animate move
            [UIView animateWithDuration:kTTGPuzzleAnimationDuration animations:^{
                [self.puzzle1 setPuzzlePosition:position];
            }];
        }
        else{
            NSLog(@"outside");
        }
        
        
        
    } else {
//        [self.puzzle1 setPuzzlePosition:position];
    }
    
    // Callback
//    [self performCallback];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];

    _backImageView.frame = self.bounds;
    _frontImageView.frame = self.bounds;
    self.puzzle1.puzzleImageContainerView.frame = CGRectMake(
            self.puzzle1.puzzleContainerPosition.x, self.puzzle1.puzzleContainerPosition.y,
            CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.puzzle1.puzzleImageView.frame = self.puzzle1.puzzleImageContainerView.bounds;
    
    [self updatePuzzleMask];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self updatePuzzleMask];
    }
}

#pragma mark - Update Mask layer

- (void)updatePuzzleMask {
    if (!self.superview) {
        return;
    }

    // Paths
    UIBezierPath *puzzlePath = [self getNewScaledPuzzledPath];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [maskPath appendPath:[UIBezierPath bezierPathWithCGPath:puzzlePath.CGPath]];
    maskPath.usesEvenOddFillRule = YES;

    // Layers
    CAShapeLayer *backMaskLayer = [CAShapeLayer new];
    backMaskLayer.frame = self.bounds;
    backMaskLayer.path = puzzlePath.CGPath;
    backMaskLayer.fillRule = kCAFillRuleEvenOdd;
    
    CAShapeLayer *frontMaskLayer = [CAShapeLayer new];
    frontMaskLayer.frame = self.bounds;
    frontMaskLayer.path = maskPath.CGPath;
    frontMaskLayer.fillRule = kCAFillRuleEvenOdd;

    CAShapeLayer *puzzleMaskLayer = [CAShapeLayer new];
    puzzleMaskLayer.frame = self.bounds;
    puzzleMaskLayer.path = puzzlePath.CGPath;

    _backImageView.layer.mask = backMaskLayer;
    _frontImageView.layer.mask = frontMaskLayer;
    self.puzzle1.puzzleImageView.layer.mask = puzzleMaskLayer;

    // Puzzle blank inner shadow
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -20, -20)]; // Outer rect
    [shadowPath appendPath:puzzlePath]; // Inner shape

    _backInnerShadowLayer.frame = self.bounds;
    _backInnerShadowLayer.path = shadowPath.CGPath;
    
    [[_backImageView.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_backImageView.layer addSublayer:_backInnerShadowLayer];
}

#pragma mark - Callback

- (void)performCallback {
    // Callback for position change
    if ([_delegate respondsToSelector:@selector(puzzleVerifyView:didChangedPuzzlePosition:xPercentage:yPercentage:)]) {
        [_delegate puzzleVerifyView:self didChangedPuzzlePosition:[self puzzlePosition]
                        xPercentage:[self puzzleXPercentage] yPercentage:[self puzzleYPercentage]];
    }
    
    // Callback if verification changed
    if (_lastVerification != [self isVerified]) {
        _lastVerification = [self isVerified];
        
        // Delegate
        if ([_delegate respondsToSelector:@selector(puzzleVerifyView:didChangedVerification:)]) {
            [_delegate puzzleVerifyView:self didChangedVerification:[self isVerified]];
        }
        
        // Block
        if (_verificationChangeBlock) {
            _verificationChangeBlock(self, [self isVerified]);
        }
    }
}

#pragma mark - Setter and getter

- (UIBezierPath *)getNewScaledPuzzledPath {
    UIBezierPath *path = nil;
    
    // Pattern path
//    if (_puzzlePattern == TTGPuzzleVerifyCustomPattern) {
//        path = [UIBezierPath bezierPathWithCGPath:_customPuzzlePatternPath.CGPath];
//        self.puzzle.puzzleSize = path.bounds.size;
//    } else {
        path = [UIBezierPath bezierPathWithCGPath:[TTGPuzzleVerifyView verifyPathForPattern:_puzzlePattern].CGPath];
        // Apply scale transform
        [path applyTransform:CGAffineTransformMakeScale(
                                                        self.puzzle1.puzzleSize.width / path.bounds.size.width,
                                                        self.puzzle1.puzzleSize.height / path.bounds.size.height)];
//    }
    
    // Apply position transform
    [path applyTransform:CGAffineTransformMakeTranslation(
            self.puzzle1.puzzleBlankPosition.x - path.bounds.origin.x,
            self.puzzle1.puzzleBlankPosition.y - path.bounds.origin.y)];
    
    return path;
}

// Puzzle position



- (CGPoint)puzzlePosition {
    return CGPointMake(self.puzzle1.puzzleContainerPosition.x + self.puzzle1.puzzleBlankPosition.x,
                       self.puzzle1.puzzleContainerPosition.y + self.puzzle1.puzzleBlankPosition.y);
}

// Puzzle blank position

- (void)setPuzzleBlankPosition:(CGPoint)puzzleBlankPosition {
    self.puzzle1.puzzleBlankPosition = puzzleBlankPosition;
    [self updatePuzzleMask];
}

// Puzzle pattern

- (void)setPuzzlePattern:(TTGPuzzleVerifyPattern)puzzlePattern {
    _puzzlePattern = puzzlePattern;
    [self updatePuzzleMask];
}

// Image

- (void)setImage:(UIImage *)image {
    _image = image;
    _backImageView.image = _image;
    _frontImageView.image = _image;
    self.puzzle1.puzzleImageView.image = _image;
    [self updatePuzzleMask];
}

// Puzzle size

- (void)setPuzzleSize:(CGSize)puzzleSize {
    self.puzzle1.puzzleSize = puzzleSize;
    [self updatePuzzleMask];
}

// Puzzle custom pattern path
//
//- (void)setCustomPuzzlePatternPath:(UIBezierPath *)customPuzzlePatternPath {
//    _customPuzzlePatternPath = customPuzzlePatternPath;
//    [self updatePuzzleMask];
//}



// Puzzle X position percentage

- (CGFloat)puzzleXPercentage {
    return ([self puzzlePosition].x - [self puzzleMinX]) / ([self puzzleMaxX] - [self puzzleMinX]);
}


// Puzzle position range

- (CGFloat)puzzleMinX {
    return 0;
}

- (CGFloat)puzzleMaxX {
    return CGRectGetWidth(self.bounds) - self.puzzle1.puzzleSize.width;
}

- (CGFloat)puzzleMinY {
    return 0;
}

- (CGFloat)puzzleMaxY {
    return CGRectGetHeight(self.bounds) - self.puzzle1.puzzleSize.height;
}

- (void)setPuzzleXPercentage:(CGFloat)puzzleXPercentage {
    if (!_enable) {
        return;
    }
    
    // Limit range
    puzzleXPercentage = MAX(0, puzzleXPercentage);
    puzzleXPercentage = MIN(1, puzzleXPercentage);

    // Change position
    CGPoint position = [self puzzlePosition];
    position.x = puzzleXPercentage * ([self puzzleMaxX] - [self puzzleMinX]) + [self puzzleMinX];
    [self.puzzle1 setPuzzlePosition:position];
    
    // Callback
    [self performCallback];
}

// Puzzle Y position percentage

- (CGFloat)puzzleYPercentage {
    return ([self puzzlePosition].y - [self puzzleMinY]) / ([self puzzleMaxY] - [self puzzleMinY]);
}

- (void)setPuzzleYPercentage:(CGFloat)puzzleYPercentage {
    if (!_enable) {
        return;
    }
    
    // Limit range
    puzzleYPercentage = MAX(0, puzzleYPercentage);
    puzzleYPercentage = MIN(1, puzzleYPercentage);

    // Change position
    CGPoint position = [self puzzlePosition];
    position.y = puzzleYPercentage * ([self puzzleMaxY] - [self puzzleMinY]) + [self puzzleMinY];
    [self.puzzle1 setPuzzlePosition:position];
    
    // Callback
    [self performCallback];
}

// isVerified

- (BOOL)isVerified {
    return fabsf([self puzzlePosition].x - self.puzzle1.puzzleBlankPosition.x) <= self.puzzle1.verificationTolerance &&
           fabsf([self puzzlePosition].y - self.puzzle1.puzzleBlankPosition.y) <= self.puzzle1.verificationTolerance;
}



@end
