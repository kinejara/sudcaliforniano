//
//  ReservationSummaryCell.h
//  GSS
//
//  Created by Fetters, Jim  (MONHC-C) on 7/9/14.
//  Copyright (c) 2014 Hyatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationSummaryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *logoImg;

@property (nonatomic, strong) IBOutlet UIButton *fbButton;
@property (nonatomic, strong) IBOutlet UIButton *TwitterButton;
@property (nonatomic, strong) IBOutlet UIButton *WebButton;

@property (nonatomic, strong) IBOutlet UIButton *playButton;


@property (nonatomic, strong) IBOutlet UILabel *arrivalLabel;
@property (nonatomic, strong) IBOutlet UILabel *departureLabel;
@property (nonatomic, strong) IBOutlet UILabel *guestsLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLineOneLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLineTwoLabel;
@property (nonatomic, strong) IBOutlet UIButton *folioButton;



@end
