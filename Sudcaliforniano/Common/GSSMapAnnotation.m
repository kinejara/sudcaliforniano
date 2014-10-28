//
//  GSSMapAnnotation.m
//  GSSMapAnnotationView
//
//

#import "GSSMapAnnotation.h"

@interface GSSMapAnnotation ()

@property (nonatomic, readwrite) GSSMapAnnotationView *view;
@property (nonatomic, readonly) GSSMapThumbnail *thumbnail;

@end

@implementation GSSMapAnnotation

+ (instancetype)annotationWithMapThumbnail:(GSSMapThumbnail *)thumbnail {
    return [[self alloc] initWithMapThumbnail:thumbnail];
}

- (id)initWithMapThumbnail:(GSSMapThumbnail *)thumbnail {
    self = [super init];
    if (self) {
        _coordinate = thumbnail.coordinate;
        _thumbnail = thumbnail;
    }
    return self;
}

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!self.view) {
        self.view = (GSSMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kGSSMapAnnotationViewReuseID];
        if (!self.view) self.view = [[GSSMapAnnotationView alloc] initWithAnnotation:self];
    } else {
        self.view.annotation = self;
    }
    [self updateMapThumbnail:self.thumbnail animated:NO];
    return self.view;
}

- (void)updateMapThumbnail:(GSSMapThumbnail *)thumbnail animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
            _coordinate = thumbnail.coordinate; // use ivar to avoid triggering setter
        }];
    } else {
        _coordinate = thumbnail.coordinate; // use ivar to avoid triggering setter
    }
    
    [self.view updateWithMapThumbnail:thumbnail];
}

@end
