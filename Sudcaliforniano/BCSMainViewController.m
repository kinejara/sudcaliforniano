//
//  ViewController.m
//  Sudcaliforniano
//
//  Created by Villa, Jorge (MONHC-C) on 9/18/14.
//  Copyright (c) 2014 Villa, Jorge (MONHC-C). All rights reserved.
//

#import "BCSMainViewController.h"
#import "RadioViewController.h"
#import "FeedViewController.h"
#import "GSSMapAnnotation.h"
#import "Weather.h"
#import "ModelView.h"


@interface BCSMainViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *GSSMapView;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic) NSInteger municipioID;
@property (nonatomic,strong) UIActionSheet *municipioActionSheet;
@property (nonatomic,strong)Weather *weather;
@property (nonatomic,strong)ModelView *modelView;


@end


@implementation BCSMainViewController

#pragma mark Initialization

-(id)init {
    if(self = [super initWithNibName:@"View" bundle:[NSBundle mainBundle]]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modelView = [[ModelView alloc] init];
    _GSSMapView.delegate = self;
    
    if([self isFirstRun]) {
    
        [self pickMunicipio];
    }
    
    [self customizeNavigationBar];
    [self performSelector:@selector(settingUpMap) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //from branch to merge in develop
}

- (void)settingUpMap {
    //set up cordinator
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    CLLocationCoordinate2D location;
    //25.869334, -112.667437
    location.latitude  = 25.869334;
    location.longitude = -112.667437;
    
    span.latitudeDelta  = 6.5;
    span.longitudeDelta = 6.8;
    // Region
    region.span=span;
    region.center=location;
    
    [_GSSMapView setRegion:region animated:YES];
    
    [self settingPins];
}

- (void)settingPins {
    
    NSArray *municipioList = @[@"Los Cabos", @"La Paz", @"Comundú", @"Loreto", @"Mulegé"];
    NSArray *latitudList = [[NSArray alloc] initWithObjects:@22.875958,@24.116468,@25.0481538,@27.2563,@26.00897,nil];
    //NSArray *long_arr = [[NSArray alloc] initWithObjects:@-109.894674,@-110.3032952,@-111.6622957,@-112.3395998,@-111.3499563,nil];
    NSArray *longitudList = @[@-109.894674,@-110.3032952,@-111.6622957,@-112.3395998,@-111.3499563];
    NSArray *subtList = @[@"sub1", @"sub2", @"sub3", @"sub4", @"sub5"];
    NSArray *thumbs_arr = [[NSArray alloc] initWithObjects:@"icon_cabos.png",@"icon_lapaz.png",@"icon_comondu",@"icon_cabos.png",@"icon_cabos.png", nil];
    
    [municipioList enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        
        GSSMapThumbnail *thumbnail = [[GSSMapThumbnail alloc] init];
        
        thumbnail.title = [NSString stringWithFormat:@"%@",str];
        thumbnail.subtitle = [NSString stringWithFormat:@"%@",[subtList objectAtIndex:idx]];
        thumbnail.disclosureBlock = ^{ NSLog(@"municipio"); };
        thumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[thumbs_arr objectAtIndex:idx]]];
        
        CLLocationCoordinate2D pinCoordinate;
        thumbnail.coordinate = pinCoordinate;
        pinCoordinate.latitude = [[latitudList objectAtIndex:idx] floatValue];
        pinCoordinate.longitude = [[longitudList objectAtIndex:idx] floatValue];
        [_GSSMapView addAnnotation:[GSSMapAnnotation annotationWithMapThumbnail:thumbnail]];
        //add this comment just to create a conflict
    }];
}


- (void)customizeNavigationBar {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(pickMunicipio)];
    
    self.navigationItem.rightBarButtonItem = closeButton;
    [self municipioNameForNavigationBar:self.municipioID];
    
}


- (void)municipioNameForNavigationBar:(NSInteger)municipioID {
    
    self.navigationItem.title = [self.modelView nameForMunicipioId:municipioID];
}

//TODO:blockskit
//when u need a reference to something that you want to use multime time
- (UIActionSheet *)municipioActionSheet {
    
    if(!_municipioActionSheet) {
        
        _municipioActionSheet = [[UIActionSheet alloc] initWithTitle:@"SELECCIONA TU MUNICIPIO :" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:
                                     @"Los Cabos",
                                     @"La Paz",
                                     @"Comundú",
                                     @"Loreto",
                                     @"Mulegé",nil];
    }
    return _municipioActionSheet;
}

- (Weather *)weather{
    
    if(!_weather) {
        _weather = [[Weather alloc] init];
    }
    
    return _weather;
}

- (NSInteger)municipioID {

    if(!_municipioID) {
        _municipioID = [[NSUserDefaults standardUserDefaults] integerForKey:@"municipioID"];
    }
    
    return _municipioID;
}


- (BOOL) isFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"isFirstRun"]) {
        return NO;
    }
    
    [defaults setObject:[NSDate date] forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}


- (void)pickMunicipio {

    [self.municipioActionSheet showInView:self.view];
}

- (IBAction)callRadioStation:(id)sender {
    
    RadioViewController *radioView = [[RadioViewController alloc] initWithMunicipioID:self.municipioID];
    [self.navigationController pushViewController:radioView animated:YES];
    
}

- (IBAction)callFeedNew:(id)sender {
    
    //FeedViewController *radioView = [[FeedViewController alloc] initWithMunicipioID:self.municipioID];
    //[self.navigationController pushViewController:radioView animated:YES];
    
}


#pragma mark Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self municipioIdChangeWithId:buttonIndex];
}


- (void)municipioIdChangeWithId:(NSInteger)municipioIndex {

    NSInteger municipioStoreId = [[NSUserDefaults standardUserDefaults] integerForKey:@"municipioID"];
    
    if(municipioIndex != municipioStoreId) {
        //
        [[NSUserDefaults standardUserDefaults] setInteger:municipioIndex forKey:@"municipioID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self textForWeaterLabelbyMunicipioId:municipioIndex];
        [self municipioNameForNavigationBar:municipioIndex];
    }

}

- (void)textForWeaterLabelbyMunicipioId:(NSInteger)municipioID {

    __weak typeof(self) weakSelf = self;
    
    [self.weather weatherForMunicipioID:municipioID andOnSuccess:^(NSString *weatherUnits) {
        
        weakSelf.temperatureLabel.text = weatherUnits;
        
    } andOnFailure:^(NSError *error) {
        //TODO:display error alert
    }];
}



#pragma mark MapView Delegates

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(GSSMapAnnotationViewProtocol)]) {
        [((NSObject<GSSMapAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(GSSMapAnnotationViewProtocol)]) {
        [((NSObject<GSSMapAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(GSSMapAnnotationProtocol)]) {
        return [((NSObject<GSSMapAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

@end
