//
//  ModelView.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 10/2/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "ModelView.h"

//ViewModel
@implementation ModelView

//TODO: initializer  to improve memory

-(NSString*)nameForMunicipioId:(NSInteger)municipioID {
    
    NSDictionary *municipios = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"municipios" ofType:@"plist"]];
    
    NSArray *munucipioNames = [NSArray arrayWithArray:[municipios objectForKey:@"names"]];
    
    NSString *municipioName = [NSString stringWithFormat:@"%@",munucipioNames[municipioID]];
    
    return municipioName;
}



@end
