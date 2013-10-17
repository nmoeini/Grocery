//
//  LocationsViewController.h
//  grocery
//
//  Created by Navid on 10/17/13.
//  Copyright (c) 2013 nmoeini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationsViewController : UIViewController <MKMapViewDelegate> {
    
    MKMapView *mapView;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet MKMapCamera *camera;


@end
