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

    self.draging = NO;
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;

    
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


#pragma mark - Pan gesture
- (void)onPanGesture_Began:(CGPoint)panLocation{
    CGPoint position = CGPointZero;
    position.x = panLocation.x - self.puzzle1.puzzleSize.width / 2;
    position.y = panLocation.y - self.puzzle1.puzzleSize.height / 2;
    
    if ( [self.puzzle1 positionInsidePuzzle:panLocation] ) {
        self.draging = YES;
        self.puzzleCurrentlyDraging = self.puzzle1;
    }
    else if ( [self.puzzle2 positionInsidePuzzle:panLocation] ) {
        self.draging = YES;
        self.puzzleCurrentlyDraging = self.puzzle2;
    }
    else if ( [self.puzzle3 positionInsidePuzzle:panLocation] ) {
        self.draging = YES;
        self.puzzleCurrentlyDraging = self.puzzle3;
    }
    
    self.puzzleCurrentlyDraging.draging = YES;
    [self.puzzleCurrentlyDraging movePuzzleWithAnimation:position];
}

- (void)onPanGesture_Dragin:(CGPoint)panLocation{
    CGPoint position = CGPointZero;
    position.x = panLocation.x - self.puzzleCurrentlyDraging.puzzleSize.width / 2;
    position.y = panLocation.y - self.puzzleCurrentlyDraging.puzzleSize.height / 2;
    
    if( self.puzzleCurrentlyDraging.draging ){
        [self.puzzleCurrentlyDraging movePuzzleWithAnimation:position];
    }
}

- (void)onPanGesture_Done:(CGPoint)panLocation{
    self.draging = NO;
    self.puzzle1.draging = NO;
    self.puzzle2.draging = NO;
    self.puzzle3.draging = NO;
    
    self.puzzleCurrentlyDraging = nil;
}

- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint panLocation = [panGestureRecognizer locationInView:self];

//    // Update position
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self onPanGesture_Began:panLocation];
    }
    else if ( panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled || panGestureRecognizer.state == UIGestureRecognizerStateFailed  ){
        [self onPanGesture_Done:panLocation];
    }
    else{
        if( self.draging ){
            [self onPanGesture_Dragin:panLocation];
        }
    }
    
    // Callback
    [self performCallback];
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
    UIBezierPath *puzzlePath = [self.puzzle1 getNewScaledPuzzledPath];
    
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
    if ([_delegate respondsToSelector:@selector(puzzleVerifyView:didChangedPuzzlePosition:)]) {
        [_delegate puzzleVerifyView:self didChangedPuzzlePosition:[self.puzzleCurrentlyDraging puzzlePosition]];
    }
    
    // Callback if verification changed
    if (_lastVerification != [self.puzzleCurrentlyDraging isVerified]) {
        _lastVerification = [self.puzzleCurrentlyDraging isVerified];
        
        // Delegate
        if ([_delegate respondsToSelector:@selector(puzzleVerifyView:didChangedVerification:puzzle:)]) {
            [_delegate puzzleVerifyView:self didChangedVerification:[self.puzzleCurrentlyDraging isVerified] puzzle:self.puzzleCurrentlyDraging];
        }
        
        // Block
        if (_verificationChangeBlock) {
            _verificationChangeBlock(self, [self.puzzleCurrentlyDraging isVerified]);
        }
    }
}



// Puzzle blank position
- (void)setPuzzleBlankPosition:(CGPoint)puzzleBlankPosition {
    self.puzzle1.puzzleBlankPosition = puzzleBlankPosition;
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

@end
