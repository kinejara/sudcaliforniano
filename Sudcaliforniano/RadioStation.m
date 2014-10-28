//
//  RadioStation.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "RadioStation.h"

@implementation RadioStation {

    NSArray *radioStations;
}


/*
 @property (nonatomic,strong) NSString *radioName_str;
 @property (nonatomic,strong) NSURL *radioStream_url;
 @property (nonatomic,strong) NSURL *radioWeb_url;
 @property (nonatomic,strong) NSString *radioFB_url;
 @property (nonatomic,strong) NSString *radioTwitter_url;
 */

#pragma mark Initialization

- (id)init {
    if ((self = [super init])) {
        radioStations = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSArray*)getRadioStationByID:(NSInteger)municipioID
{
    
    NSDictionary *municipios = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"municipios" ofType:@"plist"]];
    
    radioStations = [NSArray arrayWithArray:municipios[@"radios"][municipioID]];

    
    return radioStations;
    
}

-(void)radioStationsForMunicipioId:(NSInteger)municipioId andOnSuccess:(void (^)(NSArray *radioStations))successBlock andOnFailure:(void (^)(NSError *error))failureBlock {
    
    NSArray *stations = [self getRadioStationByID:municipioId];
    successBlock( stations );
    //TODO: call fail block
    
}

- (NSString *)radioNameForRow:(NSIndexPath *)indexPath {

    if(indexPath.row < [radioStations count]) {
        
        if(radioStations[indexPath.row][@"name"]) {
            
            return radioStations[indexPath.row][@"name"];
        }
    }
    
    return @"";
}


- (NSString *)radioStreamForRow:(NSIndexPath *)indexPath {
    
    if(indexPath.row < [radioStations count]) {
        
        if(radioStations[indexPath.row][@"streamURL"]) {
            
            return radioStations[indexPath.row][@"streamURL"];
        }
    }
    return @"";
}


- (NSString *)radioImgForRow:(NSIndexPath *)indexPath {
    
    if(indexPath.row < [radioStations count]) {
        
        if(radioStations[indexPath.row][@"logoURL"]) {
            
            return radioStations[indexPath.row][@"logoURL"];
        }
    }

    return @"";
}

- (NSString *)radioFbForRow:(NSInteger)tag {
    
    if(tag < [radioStations count]) {
        
        if(radioStations[tag][@"radioFBURL"]) {
            
            return radioStations[tag][@"radioFBURL"];
        }
    }
    
    return @"";
}

- (NSString *)radioTwitterForRow:(NSInteger)tag {
    
    if(tag < [radioStations count]) {
        
        if(radioStations[tag][@"radioTwitter"]) {
            
            return radioStations[tag][@"radioTwitter"];
        }
    }
    
    return @"";
}


- (NSString *)radioWebForRow:(NSInteger)tag {
    
    if(tag < [radioStations count]) {
        
        if(radioStations[tag][@"radioWebURL"]) {
            
            return radioStations[tag][@"radioWebURL"];
        }
    }
    
    return @"";
}

- (NSInteger)numberOfRadiosToDisplay {

    return [radioStations count];
    
}





@end
