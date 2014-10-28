//
//  FeedWebViewController.h
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/23/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedWebViewController : UIViewController

@property (nonatomic,weak)IBOutlet UIWebView *webView;
@property (nonatomic,strong)NSString *feedString;
@property (nonatomic)BOOL isHTMLStr;


@end


