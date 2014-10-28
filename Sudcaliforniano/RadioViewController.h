//
//  RadioViewController.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/18/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAudioStream.h"

@interface RadioViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

- (id)initWithMunicipioID:(NSInteger)municipioID;


@end
