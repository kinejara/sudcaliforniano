//
//  FeedWebViewController.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "FeedWebViewController.h"

@interface FeedWebViewController ()

@end

@implementation FeedWebViewController


/*
-(id)init {

    if(self = [super initWithNibName:@"FeedWebView" bundle:nil]) {
 
    }
    
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isHTMLStr) {
        [self.webView loadHTMLString:self.feedString baseURL:nil];
        
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.feedString]]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}



@end
