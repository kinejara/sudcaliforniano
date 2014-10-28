//
//  FeedViewController.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedNews.h"

@interface FeedViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,feedNewsDelegates>

@property(nonatomic,strong)IBOutlet UITableView *tableView;

- (id)initWithMunicipioID:(NSNumber*)municipioID;

@end
