//
//  RadioViewController.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/18/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "RadioViewController.h"
#import "FSAudioController.h"
#import "ReservationSummaryCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "FeedWebViewController.h"
#import "PulsingHaloLayer.h"
#import "FSCheckContentTypeRequest.h"
#import "FSAudioStream.h"
#import "RadioStation.h"


@interface RadioViewController ()

@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *radioStations;
@property (nonatomic)NSInteger municipioID;
@property (nonatomic,strong) RadioStation *radioStation;


@end

@class FSAudioController;

@implementation RadioViewController {
    
    FSAudioController *_audioController;
    FSAudioStream *_audioStream;
    PulsingHaloLayer *_halo;
    
}

- (id)initWithMunicipioID:(NSInteger)municipioID {
    
    _municipioID = municipioID;
    _radioStation = [[RadioStation alloc] init];
    _halo = [PulsingHaloLayer layer];
    _halo.position = CGPointMake(58, 12);
    _audioController = [[FSAudioController alloc] init];
    _audioStream = [[FSAudioStream alloc] init];
    
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 150.0f;
    [self fetchRadioStationsForPreferredMunicipio];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchRadioStationsForPreferredMunicipio {

    __weak typeof(self) weakSelf = self;
    [self.radioStation radioStationsForMunicipioId:self.municipioID andOnSuccess:^(NSArray *radioStations) {
        self.radioStations = radioStations;
        [weakSelf.tableView reloadData];
    } andOnFailure:^(NSError *error) {
    }];
}

/*
- (void)fetchRadioStationsForPreferredMunicipio {
    __block NSArray *a, *b;
    
    __weak typeof(self) weakSelf = self;
    void (^fetchedAllData)() = ^{
        if( a && b ) {
            weakSelf.radioStations = a;
            weakSelf.beerStations = b;
            [weakSelf.tableView reloadData];
        }
    };
    
    [radioStation radioStationsForMunicipioId:self.municipioID andOnSuccess:^(NSArray *radioStations) {
        a = radioStations;
        
        fetchedAllData();
    } andOnFailure:^(NSError *error) {
        
    }];
    
    [radioStation beerStationsForMunicipioId:@0 andOnSuccess:^(NSArray *beerStations) {
        
        b = beerStations;
        fetchedAllData();
        
    } andOnFailure:^(NSError *error) {
        
        
    }];
 
}

     */
    
//- (NSArray*)radioStations {
//    
//    if (!_radioStations) {
//        
//        _radioStations = [radioStation getRadioStationByID:self.municipioID];
//    }
//    
//    return _radioStations;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.radioStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* customCellIdentifier = @"ReservationSummaryCell";
    ReservationSummaryCell *cell = (ReservationSummaryCell *) [tableView dequeueReusableCellWithIdentifier: customCellIdentifier];
    
    if (cell == nil) {
        UINib* customCellNib = [UINib nibWithNibName: @"ReservationSummaryCell" bundle: nil];
        [tableView registerNib: customCellNib forCellReuseIdentifier: customCellIdentifier];
    }

    cell = (ReservationSummaryCell *) [tableView dequeueReusableCellWithIdentifier: customCellIdentifier];
    [cell.nameLabel setText:[self.radioStation radioNameForRow:indexPath]];
    
    [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:[self.radioStation radioImgForRow:indexPath]] placeholderImage:[UIImage imageNamed:@""]];
    
    if([[self.radioStation radioWebForRow:indexPath.row] isEqualToString:@""]) {
        [cell.WebButton  setEnabled:NO];
        
    } else {
        [cell.WebButton  setEnabled:YES];
    }
    
    if([[self.radioStation radioTwitterForRow:indexPath.row] isEqualToString:@""]) {
        
        [cell.TwitterButton  setEnabled:NO];
    } else {
        
        [cell.TwitterButton  setEnabled:YES];
    }
    
    if([[self.radioStation radioFbForRow:indexPath.row] isEqualToString:@""]) {
        
        [cell.fbButton  setEnabled:NO];
        
    } else {
        
        [cell.fbButton  setEnabled:YES];
    }
    
    [cell.WebButton  setTag:indexPath.row];
    [cell.fbButton  setTag:indexPath.row];
    [cell.TwitterButton  setTag:indexPath.row];

    [cell.fbButton addTarget:self action:@selector(fbButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.TwitterButton addTarget:self action:@selector(twitterButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.WebButton addTarget:self action:@selector(webButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)fbButtonTouchUpInside:(UIButton *)sender {
    FeedWebViewController *feedWebView = [[FeedWebViewController alloc] init];
    feedWebView.feedString = [NSString stringWithFormat:@"%@",[self.radioStation radioFbForRow:sender.tag]];
    feedWebView.isHTMLStr = NO;
    [self.navigationController pushViewController:feedWebView animated:YES];
}

-(void)twitterButtonTouchUpInside:(UIButton *)sender {
    FeedWebViewController *feedWebView = [[FeedWebViewController alloc] init];
    feedWebView.feedString = [NSString stringWithFormat:@"%@",[self.radioStation radioTwitterForRow:sender.tag]];
    feedWebView.isHTMLStr = NO;
    [self.navigationController pushViewController:feedWebView animated:YES];
    
}

-(void)webButtonTouchUpInside:(UIButton *)sender {
    
    FeedWebViewController *feedWebView = [[FeedWebViewController alloc] init];
    feedWebView.feedString = [NSString stringWithFormat:@"%@",[self.radioStation radioWebForRow:sender.tag]];
    feedWebView.isHTMLStr = NO;
    [self.navigationController pushViewController:feedWebView animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReservationSummaryCell *cell = (ReservationSummaryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.playButton setTitle:@"Stop" forState:UIControlStateNormal];
    [cell.playButton.layer addSublayer:_halo];
    
    NSURL *streamURL = [NSURL URLWithString:[self.radioStation radioStreamForRow:indexPath]];
    FSCheckContentTypeRequest *request = [[FSCheckContentTypeRequest alloc] init];
    request.url = streamURL;
    
    request.onCompletion = ^() {
        if (request.playlist) {
            // The URL is a playlist; now do something with it...
            _audioController.url = [NSURL URLWithString:[self.radioStation radioStreamForRow:indexPath]];
            [_audioController play];
        }
        else{
            _audioStream.strictContentTypeChecking = NO;
            [_audioStream playFromURL:streamURL];
        }
    };
    request.onFailure = ^() {
        //TODO:Handle stream error here
        UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"!" message:@"Esta estación no se encuentra disponible." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [tmp show];
    };
    
    [request start];
    NSLog(@"Selected ---> %@",[self.radioStation radioStreamForRow:indexPath]);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    ReservationSummaryCell *cell = (ReservationSummaryCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [cell.layer removeAllAnimations];
    
    [_audioController stop];
    [_audioStream stop];
    
}

@end
