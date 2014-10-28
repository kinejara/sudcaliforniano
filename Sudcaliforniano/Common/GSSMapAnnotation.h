//
//  GSSMapAnnotation.h
//  GSSMapAnnotationView
//
//

@import Foundation;
@import MapKit;
#import "GSSMapThumbnail.h"
#import "GSSMapAnnotationView.h"

@protocol GSSMapAnnotationProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface GSSMapAnnotation : NSObject <MKAnnotation, GSSMapAnnotationProtocol>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (instancetype) annotationWithMapThumbnail:(GSSMapThumbnail *)thumbnail;
- (id) initWithMapThumbnail:(GSSMapThumbnail *)thumbnail;
- (void) updateMapThumbnail:(GSSMapThumbnail *)thumbnail animated:(BOOL)animated;

@end