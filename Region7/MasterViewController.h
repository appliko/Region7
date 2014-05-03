//
//  MasterViewController.h
//  Region7
//
//  Created by bob on 7/17/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) NSMutableArray *iBeaconArray;

@end
