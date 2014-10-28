//
//  GSSMapThumbnail.h
//  GSSMapAnnotation
//
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef void (^ActionBlock)();

@interface GSSMapThumbnail : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) ActionBlock disclosureBlock;

@end
