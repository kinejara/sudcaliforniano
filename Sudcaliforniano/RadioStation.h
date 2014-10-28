//
//  RadioStation.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RadioStation : NSObject

-(NSArray*)getRadioStationByID:(NSInteger)municipioID;
- (NSInteger)numberOfRadiosToDisplay;
- (NSString *)radioNameForRow:(NSIndexPath *)indexPath;
- (NSString *)radioStreamForRow:(NSIndexPath *)indexPath;
- (NSString *)radioImgForRow:(NSIndexPath *)indexPath;
- (NSString *)radioFbForRow:(NSInteger)tag;
- (NSString *)radioWebForRow:(NSInteger)tag;
- (NSString *)radioTwitterForRow:(NSInteger)tag;

-(void)radioStationsForMunicipioId:(NSInteger)municipioId andOnSuccess:(void (^)(NSArray *radioStations))successBlock andOnFailure:(void (^)(NSError *error))failureBlock;


@end
