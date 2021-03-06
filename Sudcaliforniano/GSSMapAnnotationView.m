//
//  GSSMapAnnotationView.m
//  GSSMapAnnotationView
//
//

@import QuartzCore;
#import "GSSMapAnnotationView.h"
#import "GSSMapThumbnail.h"

NSString * const kGSSMapAnnotationViewReuseID = @"GSSMapAnnotationView";

static CGFloat const kGSSMapAnnotationViewStandardWidth     = 45.0f;
static CGFloat const kGSSMapAnnotationViewStandardHeight    = 70.0f;
static CGFloat const kGSSMapAnnotationViewExpandOffset      = 200.0f;
static CGFloat const kGSSMapAnnotationViewVerticalOffset    = 34.0f;
static CGFloat const kGSSMapAnnotationViewAnimationDuration = 0.25f;

@interface GSSMapAnnotationView ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) ActionBlock disclosureBlock;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *disclosureButton;
@property (nonatomic, assign) GSSMapAnnotationViewState state;

@end

@implementation GSSMapAnnotationView

#pragma mark - Setup

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:kGSSMapAnnotationViewReuseID];
    
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, kGSSMapAnnotationViewStandardWidth, kGSSMapAnnotationViewStandardHeight);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kGSSMapAnnotationViewVerticalOffset);
        
        _state = GSSMapAnnotationViewStateCollapsed;
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    [self setupImageView];
    [self setupTitleLabel];
    [self setupSubtitleLabel];
    [self setupDisclosureButton];
    [self setLayerProperties];
    [self setDetailGroupAlpha:0.0f];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5f, 12.5f, 22.0f, 28.0f)];
    _imageView.layer.cornerRadius = 4.0f;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.borderWidth = 0.5f;
    [self addSubview:_imageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-52.0f, 12.0f, 168.0f, 20.0f)];
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.minimumScaleFactor = 0.8f;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
}

- (void)setupSubtitleLabel {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-52.0f, 28.0f, 168.0f, 20.0f)];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_subtitleLabel];
}

- (void)setupDisclosureButton {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f;
    UIButtonType buttonType = iOS7 ? UIButtonTypeSystem : UIButtonTypeCustom;
    _disclosureButton = [UIButton buttonWithType:buttonType];
    _disclosureButton.tintColor = [UIColor grayColor];
    UIImage *disclosureIndicatorImage = [GSSMapAnnotationView disclosureButtonImage];
    [_disclosureButton setImage:disclosureIndicatorImage forState:UIControlStateNormal];
    _disclosureButton.frame = CGRectMake(kGSSMapAnnotationViewExpandOffset/2.0f + self.frame.size.width/2.0f + 1.0f,
                                         18.5f,
                                         disclosureIndicatorImage.size.width,
                                         disclosureIndicatorImage.size.height);
    
    [_disclosureButton addTarget:self action:@selector(didTapDisclosureButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_disclosureButton];
}

- (void)setLayerProperties {
    _bgLayer = [CAShapeLayer layer];
    CGPathRef path = [self newBubbleWithRect:self.bounds];
    _bgLayer.path = path;
    CFRelease(path);
    _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    _bgLayer.shadowColor = [UIColor blackColor].CGColor;
    _bgLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    _bgLayer.shadowRadius = 2.0f;
    _bgLayer.shadowOpacity = 0.5f;
    
    _bgLayer.masksToBounds = NO;
    
    [self.layer insertSublayer:_bgLayer atIndex:0];
}

#pragma mark - Updating

- (void)updateWithMapThumbnail:(GSSMapThumbnail *)thumbnail {
    self.coordinate = thumbnail.coordinate;
    self.titleLabel.text = thumbnail.title;
    self.subtitleLabel.text = thumbnail.subtitle;
    self.imageView.image = thumbnail.image;
    self.disclosureBlock = thumbnail.disclosureBlock;
}

#pragma mark - GSSMapAnnotationViewProtocol

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
    // Center map at annotation point
    [mapView setCenterCoordinate:self.coordinate animated:YES];
    [self expand];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
    [self shrink];
}

#pragma mark - Geometry

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0f;
	CGFloat radius = 7.0f;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2.0f;
	
	// Determine Size
	rect.size.width -= stroke + 14.0f;
	rect.size.height -= stroke + 29.0f;
	rect.origin.x += stroke / 2.0f + 7.0f;
	rect.origin.y += stroke / 2.0f + 7.0f;
    
	// Create Callout Bubble Path
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14.0f);
	CGPathAddLineToPoint(path, NULL, parentX + 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
	CGPathCloseSubpath(path);
    return path;
}

#pragma mark - Animations

- (void)setDetailGroupAlpha:(CGFloat)alpha {
    self.disclosureButton.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.subtitleLabel.alpha = alpha;
}

- (void)expand {
    if (self.state != GSSMapAnnotationViewStateCollapsed) return;
    
    self.state = GSSMapAnnotationViewStateAnimating;
    
    [self animateBubbleWithDirection:GSSMapAnnotationViewAnimationDirectionGrow];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+kGSSMapAnnotationViewExpandOffset, self.frame.size.height);
    self.centerOffset = CGPointMake(kGSSMapAnnotationViewExpandOffset/2.0f, -kGSSMapAnnotationViewVerticalOffset);
    [UIView animateWithDuration:kGSSMapAnnotationViewAnimationDuration/2.0f delay:kGSSMapAnnotationViewAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setDetailGroupAlpha:1.0f];
    } completion:^(BOOL finished) {
        self.state = GSSMapAnnotationViewStateExpanded;
    }];
}

- (void)shrink {
    if (self.state != GSSMapAnnotationViewStateExpanded) return;
    
    self.state = GSSMapAnnotationViewStateAnimating;

    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width - kGSSMapAnnotationViewExpandOffset,
                            self.frame.size.height);
    
    [UIView animateWithDuration:kGSSMapAnnotationViewAnimationDuration/2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setDetailGroupAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self animateBubbleWithDirection:GSSMapAnnotationViewAnimationDirectionShrink];
                         self.centerOffset = CGPointMake(0.0f, -kGSSMapAnnotationViewVerticalOffset);
                     }];
}

- (void)animateBubbleWithDirection:(GSSMapAnnotationViewAnimationDirection)animationDirection {
    BOOL growing = (animationDirection == GSSMapAnnotationViewAnimationDirectionGrow);
    // Image
    [UIView animateWithDuration:kGSSMapAnnotationViewAnimationDuration animations:^{
        CGFloat xOffset = (growing ? -1 : 1) * kGSSMapAnnotationViewExpandOffset/2.0f;
        self.imageView.frame = CGRectOffset(self.imageView.frame, xOffset, 0.0f);
    } completion:^(BOOL finished) {
        if (animationDirection == GSSMapAnnotationViewAnimationDirectionShrink) {
            self.state = GSSMapAnnotationViewStateCollapsed;
        }
    }];
    
    // Bubble
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kGSSMapAnnotationViewAnimationDuration;
    
    // Stroke & Shadow From/To Values
    CGRect largeRect = CGRectInset(self.bounds, -kGSSMapAnnotationViewExpandOffset/2.0f, 0.0f);
    
    CGPathRef fromPath = [self newBubbleWithRect:growing ? self.bounds : largeRect];
    animation.fromValue = (__bridge id)fromPath;
    CGPathRelease(fromPath);
    
    CGPathRef toPath = [self newBubbleWithRect:growing ? largeRect : self.bounds];
    animation.toValue = (__bridge id)toPath;
    CGPathRelease(toPath);
    
    [self.bgLayer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark - Disclosure Button

- (void)didTapDisclosureButton {
    if (self.disclosureBlock) self.disclosureBlock();
}

+ (UIImage *)disclosureButtonImage {
    CGSize size = CGSizeMake(21.0f, 36.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2.0f, 2.0f)];
    [bezierPath addLineToPoint:CGPointMake(10.0f, 10.0f)];
    [bezierPath addLineToPoint:CGPointMake(2.0f, 18.0f)];
    [[UIColor lightGrayColor] setStroke];
    bezierPath.lineWidth = 3.0f;
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
