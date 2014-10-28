//
//  Weather.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/26/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "Weather.h"


@interface Weather()

@property (nonatomic,strong)NSXMLParser *parser;

@end


@implementation Weather {
    
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *condition;
    NSMutableString *contentData;
    
    NSString *element;
    
}

- (id)init {
    
    if ((self = [super init])) {
        
        feeds = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(void)weatherForMunicipioID:(NSInteger)municipioId andOnSuccess:(void(^)(NSString *weatherUnits))successBlock andOnFailure:(void (^)(NSError * error))failureBlock {
    
    //constant
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:[self weatherUrlForMunicipioId:municipioId]];
        _parser.delegate = self;
        _parser.shouldResolveExternalEntities = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![_parser parse]) {
                
                failureBlock(_parser.parserError);
            
            } else {
            
                successBlock([self WeatherInCelsius]);
            }
        });
        
    });
}

-(NSURL*)weatherUrlForMunicipioId:(NSInteger)municipioID {
    
    NSDictionary *municipios = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"municipios" ofType:@"plist"]];
    
    NSArray *weatherUrls = [NSArray arrayWithArray:[municipios objectForKey:@"weather"]];
    
    NSString *weatherUrl = [NSString stringWithFormat:@"%@",weatherUrls[municipioID]];
    
    NSURL *xmlWeatherUrl = [NSURL URLWithString:weatherUrl];
    
    return xmlWeatherUrl;
}

/*
 
 -(void)radioStationsForMunicipioId:(NSNumber *)municipioId andOnSuccess:(void (^)(NSArray *radioStations))successBlock andOnFailure:(void (^)(NSError *error))failureBlock {
 
 NSArray *stations = radioStation_arr[municipioId.integerValue];
 successBlock( stations );
 
 
 }
 */

/*
-(void)startParsing:(NSURL*)url {
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
}

*/

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        //condition    = [attributeDict objectForKey:@"temp"];;
        
    }
    
    if ([element isEqualToString:@"yweather:condition"]) {
        
        condition = [attributeDict objectForKey:@"temp"];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }else if ([element isEqualToString:@"content:encoded"]) {
        [contentData appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:condition forKey:@"yweather:condition"];
       
        //[feeds addObject:[item copy]];
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

- (NSInteger)numberOfFeedsToDisplay {
    
    return [feeds count];
}

- (NSString *)WeatherInCelsius {
    
   // NSLog(@"description ---> %@",[feeds description]);
   return item[@"yweather:condition"];

}

- (NSString *)FeedDateForRow:(NSIndexPath *)indexPath {
    
    if(indexPath.row < [feeds count]) {
        
        if(feeds[indexPath.row][@"pubDate"]) {
            
            NSString *dateWithString = [[NSString stringWithFormat:@"%@",feeds[indexPath.row][@"pubDate"]]substringWithRange:NSMakeRange(5, 17)];
            return dateWithString;
        }
    }
    
    return @"";
}

- (NSString *)FeedContentForRow:(NSIndexPath *)indexPath {
    
    //NSLog(@"dess --->> %@",feeds[indexPath.row][@"content:encoded"]);
    
    if(indexPath.row < [feeds count]) {
        
        if(feeds[indexPath.row][@"content:encoded"]) {
            //width="660" height="441"
            
            NSString *htmlString = [feeds[indexPath.row][@"content:encoded"] stringByReplacingOccurrencesOfString:@"width=\"660\""
                                                                                                       withString:@"width=\"320\""];
            return htmlString;
            
        }
    }
    
    return @"";
}


@end
