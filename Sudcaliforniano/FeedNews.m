//
//  FeedNews.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "FeedNews.h"

@implementation FeedNews {

    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *date;
    NSMutableString *contentData;
    
    NSString *element;

}


- (id)init {
    
    if ((self = [super init])) {
        
        feeds = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(NSArray*)getFeedNewsByID:(NSNumber*)municipioID {


    NSURL *url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/los-cabos/feed/"];
   
    switch (municipioID.intValue) {
        case 0:{
            //Los cabos
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/los-cabos/feed/"];
        }
            break;
        case 1:
            //@"La Paz";
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/lapaz/feed/"];
            break;
        case 2:
            //@"Comundú";
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/comondu/feed/"];
            break;
        case 3:
            //@"Loreto";
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/loreto/feed/"];
            break;
        case 4:
            //@"Mulegé";
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/mulege/feed/"];
            break;
        default:
            //@"";
            url = [NSURL URLWithString:@"http://www.bcsnoticias.mx/los-cabos/feed/"];
            break;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    [NSThread detachNewThreadSelector:@selector(startParsing:) toTarget:self withObject:url];
    
    return feeds;
}


-(void)startParsing:(NSURL*)url {

    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
        contentData = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }else if ([element isEqualToString:@"pubDate"]) {
        [date appendString:string];
    }else if ([element isEqualToString:@"content:encoded"]) {
        [contentData appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:date forKey:@"pubDate"];
        [item setObject:contentData forKey:@"content:encoded"];
        
        [feeds addObject:[item copy]];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_delegate didFinishLoadFeeds:TRUE];
    
}

- (NSInteger)numberOfFeedsToDisplay {
    
    return [feeds count];
    
}

- (NSString *)FeedTitleForRow:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row < [feeds count]) {
        
        if(feeds[indexPath.row][@"title"]) {
            
            return feeds[indexPath.row][@"title"];
        }
    }
    
    return @"";
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

            //return [NSString stringWithFormat:@"%@",feeds[indexPath.row][@"content:encoded"]];
            return htmlString;
            
        }
    }
    
    return @"";
}


@end
