//
//  LocationsViewController.m
//  grocery
//
//  Created by Navid on 10/17/13.
//  Copyright (c) 2013 nmoeini. All rights reserved.
//

#import "LocationsViewController.h"

@interface LocationsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *directionButton;

@end

@implementation LocationsViewController

@synthesize mapView = _mapView;
@synthesize camera = _camera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMap];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];

}

- (NSArray *)deviceLocation {
    
    NSMutableArray *deviceLocation = [[NSMutableArray alloc] init];
    
    [deviceLocation addObject:[NSString stringWithFormat:@"%f" , locationManager.location.coordinate.latitude]];
    [deviceLocation addObject:[NSString stringWithFormat:@"%f" , locationManager.location.coordinate.longitude]];
    
    NSLog(@"user location latitude: @%@ , longitude: @%@", deviceLocation[0], deviceLocation[1]);
    
    return deviceLocation;
}

-(void)loadMap
{
    CLLocationCoordinate2D store;
    
    store.latitude = 34.169981;
    store.longitude = -118.603912;
    
    CLLocationCoordinate2D user;
    user.latitude = locationManager.location.coordinate.latitude;
    user.longitude = locationManager.location.coordinate.longitude;
    
//    NSLog(@"user latitude: @%f", user.latitude);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((store.latitude + user.latitude) / 2.0, (store.longitude + user.longitude) / 2.0);

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.017778;
    span.longitudeDelta = 0.014932;
    
    
 /*   if (store.latitude >= user.latitude) span.latitudeDelta = store.latitude - user.latitude + 0.01;
        else span.latitudeDelta = user.latitude - store.latitude;
    if (store.longitude >= user.longitude) span.longitudeDelta = store.longitude - user.longitude +0.01;
    else span.longitudeDelta = user.longitude - store.longitude;
  */
    region.span = span;
    region.center = store;
 
    MKPointAnnotation *groceryAnnotation = [[MKPointAnnotation alloc] init];
    [groceryAnnotation setCoordinate:store];
    
    [groceryAnnotation setTitle:@"Online Market"];
    [groceryAnnotation setSubtitle:@""];
    [self.mapView addAnnotation:groceryAnnotation];
    
    MKPointAnnotation *userAnnotation = [[MKPointAnnotation alloc] init];
    [userAnnotation setCoordinate:user];
    [userAnnotation setTitle:@"You"];
    [self.mapView addAnnotation:userAnnotation];
    /*
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
  */
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    self.mapView.mapType = MKMapTypeHybrid;
    
}

- (void)plotRouteOnMap
{
    CLLocationCoordinate2D grocery;
    store.latitude = 34.169981;
    store.longitude = -118.603912;
    
    CLLocationCoordinate2D user;
    user.latitude = locationManager.location.coordinate.latitude;
    user.longitude = locationManager.location.coordinate.longitude;
    
    //Plot Location route on Map
    CLLocationCoordinate2D *plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
    plotLocation[0] = user;
    plotLocation[1] = grocery;
    MKPolyline *line = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    [mapView setDelegate:self];
    [mapView addOverlay:line];
    [mapView setCenterCoordinate:plotLocation[1]];
    
}
- (IBAction)getDirection:(id)sender {
    
    CLLocationCoordinate2D store;
    
    store.latitude = 34.169981;
    store.longitude = -118.603912;
    
    
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: store addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = @"Online Market";
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MKOverlayView Delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"Delegate Call");
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}



@end
