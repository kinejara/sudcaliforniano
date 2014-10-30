//
//  FeedViewController.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "FeedViewController.h"
#import "FeedWebViewController.h"
#import "FeedCell.h"

@interface FeedViewController ()

@end

@implementation FeedViewController {

    FeedNews *feedNew;
}


- (id)init {
    if (self = [super initWithNibName:@"FeedView" bundle:nil]) {
        // cellDetail = [NSDictionary alloc];
    }
    return self;
}

- (id)initWithMunicipioID:(NSNumber *)municipioID {
    feedNew = [[FeedNews alloc] init];
    [feedNew setDelegate:self];
    [feedNew getFeedNewsByID:municipioID];
    
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFinishLoadFeeds:(BOOL)loadVerified {
    
    if (!loadVerified) {
        return;
    }
    [self.tableView reloadData];
}

#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedNew numberOfFeedsToDisplay];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* customCellIdentifier = @"ReservationSummaryCell";
    FeedCell *cell = (FeedCell *) [tableView dequeueReusableCellWithIdentifier: customCellIdentifier];
    
    if (cell == nil) {
        UINib* customCellNib = [UINib nibWithNibName: @"FeedCell" bundle: nil];
        [tableView registerNib: customCellNib forCellReuseIdentifier: customCellIdentifier];
    }
    
    cell = (FeedCell *) [tableView dequeueReusableCellWithIdentifier: customCellIdentifier];
    [cell.labelTitle setText:[feedNew FeedTitleForRow:indexPath]];
    [cell.labelDate setText:[feedNew FeedDateForRow:indexPath]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedWebViewController *feedWebView = [[FeedWebViewController alloc] initWithNibName:@"FeedWebView" bundle:nil];
    feedWebView.feedString = [NSString stringWithFormat:@"%@",[feedNew FeedContentForRow:indexPath]];
    feedWebView.isHTMLStr = YES;
    [self.navigationController pushViewController:feedWebView animated:YES];
}

@end
