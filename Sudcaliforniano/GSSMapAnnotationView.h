//
//  GSSMapAnnotationView.h
//  GSSMapAnnotationView
//
//

@import MapKit;

@class GSSMapThumbnail;

extern NSString * const kGSSMapAnnotationViewReuseID;

typedef NS_ENUM(NSInteger, GSSMapAnnotationViewAnimationDirection) {
    GSSMapAnnotationViewAnimationDirectionGrow,
    GSSMapAnnotationViewAnimationDirectionShrink,
};

typedef NS_ENUM(NSInteger, GSSMapAnnotationViewState) {
    GSSMapAnnotationViewStateCollapsed,
    GSSMapAnnotationViewStateExpanded,
    GSSMapAnnotationViewStateAnimating,
};

@protocol GSSMapAnnotationViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;

@end

@interface GSSMapAnnotationView : MKAnnotationView <GSSMapAnnotationViewProtocol>

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;

- (void)updateWithMapThumbnail:(GSSMapThumbnail *)thumbnail;

@end
