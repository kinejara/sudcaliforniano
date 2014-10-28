//
//  Weather.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/26/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Weather : NSObject  <NSXMLParserDelegate>

-(void)weatherForMunicipioID:(NSInteger)municipioId andOnSuccess:(void(^)(NSString *weatherUnits))successBlock andOnFailure:(void (^)(NSError * error))failureBlock;


- (NSString *)WeatherInCelsius;


@end
