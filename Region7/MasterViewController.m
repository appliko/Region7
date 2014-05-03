//
//  MasterViewController.m
//  Region7
//
//  Created by bob on 7/17/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "MasterViewController.h"

typedef enum
{
    Region7SectionGPS,
    Region7SectionBeacon,
    Region7SectionCurrentLocation
} Region7Section;

@interface MasterViewController ()
{
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"KST Region Demo";
    
    // Setup the locations array
    _locationsArray = [NSMutableArray array];
    _iBeaconArray = [NSMutableArray array];
    
    // Start the location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startMonitoringSignificantLocationChanges];
    
    // Check for iBeacon Capability
    if( [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] )
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusRestricted ||
            status == kCLAuthorizationStatusDenied )
        {
            UIAlertView *noLBSPermissionAlert = [[UIAlertView alloc] initWithTitle:Nil message:@"Please enable LBS for this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noLBSPermissionAlert show];
        }
    }
    
    // Setup Fixed GPS Locations
    NSLog(@"DIAG: Launch: Monitored Regions - %@", [_locationManager monitoredRegions]);
    
    // KST in Colorado Springs
    NSString *kstName = @"KST";
    NSString *kstIdentifier = @"com.kstechnologies.region7.gps.kst";
    NSNumber *kstLat = [NSNumber numberWithFloat:38.929148];
    NSNumber *kstLong = [NSNumber numberWithFloat:-104.862107];
    NSNumber *kstState = [NSNumber numberWithInt:CLRegionStateUnknown];
    CLLocationCoordinate2D kstCoordinates = CLLocationCoordinate2DMake(kstLat.floatValue, kstLong.floatValue);
    CLCircularRegion *kstRegion = [[CLCircularRegion alloc] initWithCenter:kstCoordinates radius:20 identifier:kstIdentifier];
    kstRegion.notifyOnEntry = YES;
    kstRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:kstRegion];
    [_locationManager requestStateForRegion:kstRegion];
    NSMutableDictionary *kstLocation = [@{@"lat":kstLat, @"long":kstLong, @"description":kstName, @"region":kstRegion, @"state":kstState, @"identifier":kstIdentifier} mutableCopy];
    [_locationsArray addObject:kstLocation];
    
    // REI, Colorado Springs Location
    NSString *reiName = @"REI";
    NSString *reiIdentifier = @"com.kstechnologies.region7.gps.rei";
    NSNumber *reiLat = [NSNumber numberWithFloat:38.933442];
    NSNumber *reiLong = [NSNumber numberWithFloat:-104.800147];
    NSNumber *reiState = [NSNumber numberWithInt:CLRegionStateUnknown];
    CLLocationCoordinate2D reiCoordinates = CLLocationCoordinate2DMake(reiLat.floatValue, reiLong.floatValue);
    CLCircularRegion *reiRegion = [[CLCircularRegion alloc] initWithCenter:reiCoordinates radius:20 identifier:reiIdentifier];
    reiRegion.notifyOnEntry = YES;
    reiRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:reiRegion];
    [_locationManager requestStateForRegion:reiRegion];
    NSMutableDictionary *reiLocation = [@{@"lat":reiLat, @"long":reiLong, @"description":reiName, @"region":reiRegion, @"state":reiState, @"identifier":reiIdentifier} mutableCopy];
    [_locationsArray addObject:reiLocation];
    
    // University of Colorado at Colorado Springs
    NSString *cuName = @"University of Colorado";
    NSString *cuIdentifier = @"com.kstechnologies.region7.gps.uccs";
    NSNumber *cuLat = [NSNumber numberWithFloat:38.893043];
    NSNumber *cuLong = [NSNumber numberWithFloat:-104.80089];
    NSNumber *cuState = [NSNumber numberWithInt:CLRegionStateUnknown];
    CLLocationCoordinate2D cuCoordinates = CLLocationCoordinate2DMake(cuLat.floatValue, cuLong.floatValue);
    CLCircularRegion *cuRegion = [[CLCircularRegion alloc] initWithCenter:cuCoordinates radius:20 identifier:cuIdentifier];
    cuRegion.notifyOnEntry = YES;
    cuRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:cuRegion];
    [_locationManager requestStateForRegion:cuRegion];
    NSMutableDictionary *cuLocation = [@{@"lat":cuLat, @"long":cuLong, @"description":cuName, @"region":cuRegion, @"state":cuState, @"identifier":cuIdentifier} mutableCopy];
    [_locationsArray addObject:cuLocation];
    
    // Setup Movable iBeacon Locations
    NSUUID *particleUUID = [[NSUUID alloc] initWithUUIDString:@"8AEFB031-6C32-486F-825B-E26FA193487D"];
    
    // My desk at KST
    NSString *deskName = @"Desk";
    NSString *deskIdentifier = @"com.kstechnologies.region7.ibeacon.desk";
    NSNumber *deskMajor = [NSNumber numberWithInteger:7];
    NSNumber *deskMinor = [NSNumber numberWithInteger:7005];
    NSNumber *deskState = [NSNumber numberWithInt:CLRegionStateUnknown];
    NSNumber *deskProximity = [NSNumber numberWithInt:CLProximityUnknown];
    CLBeaconRegion *deskRegion = [[CLBeaconRegion alloc] initWithProximityUUID:particleUUID major:deskMajor.intValue minor:deskMinor.intValue identifier:deskIdentifier];
    deskRegion.notifyEntryStateOnDisplay = YES;
    deskRegion.notifyOnEntry = YES;
    deskRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:deskRegion];
    [_locationManager requestStateForRegion:deskRegion];
    NSMutableDictionary *deskLocation = [@{@"major":deskMajor, @"minor":deskMinor, @"description":deskName, @"region":deskRegion, @"state":deskState, @"proximity":deskProximity, @"identifier":deskIdentifier} mutableCopy];
    [_iBeaconArray addObject:deskLocation];
    
    // Coffee Machine
    NSString *coffeeName = @"Coffee";
    NSString *coffeeIdentifier = @"com.kstechnologies.region7.ibeacon.coffee";
    NSNumber *coffeeMajor = [NSNumber numberWithInteger:7];
    NSNumber *coffeeMinor = [NSNumber numberWithInteger:72];
    NSNumber *coffeeState = [NSNumber numberWithInt:CLRegionStateUnknown];
    NSNumber *coffeeProximity = [NSNumber numberWithInt:CLProximityUnknown];
    CLBeaconRegion *coffeeRegion = [[CLBeaconRegion alloc] initWithProximityUUID:particleUUID major:coffeeMajor.intValue minor:coffeeMinor.intValue identifier:coffeeIdentifier];
    coffeeRegion.notifyEntryStateOnDisplay = YES;
    coffeeRegion.notifyOnEntry = YES;
    coffeeRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:coffeeRegion];
    [_locationManager requestStateForRegion:coffeeRegion];
    NSMutableDictionary *coffeeLocation = [@{@"major":coffeeMajor, @"minor":coffeeMinor, @"description":coffeeName, @"region":coffeeRegion, @"state":coffeeState, @"proximity":coffeeProximity, @"identifier":coffeeIdentifier} mutableCopy];
    [_iBeaconArray addObject:coffeeLocation];
    
    // My Keys
    NSString *keysName = @"Keys";
    NSString *keysIdentifier = @"com.kstechnologies.region7.ibeacon.keys";
    NSNumber *keysMajor = [NSNumber numberWithInteger:7];
    NSNumber *keysMinor = [NSNumber numberWithInteger:255];
    NSNumber *keysState = [NSNumber numberWithInt:CLRegionStateUnknown];
    NSNumber *keysProximity = [NSNumber numberWithInt:CLProximityUnknown];
    CLBeaconRegion *keysRegion = [[CLBeaconRegion alloc] initWithProximityUUID:particleUUID major:keysMajor.intValue minor:keysMinor.intValue identifier:keysIdentifier];
    keysRegion.notifyEntryStateOnDisplay = YES;
    keysRegion.notifyOnEntry = YES;
    keysRegion.notifyOnExit = YES;
    [_locationManager startMonitoringForRegion:keysRegion];
    [_locationManager requestStateForRegion:keysRegion];
    NSMutableDictionary *keysLocation = [@{@"major":keysMajor, @"minor":keysMinor, @"description":keysName, @"region":keysRegion, @"state":keysState, @"proximity":keysProximity, @"identifier":keysIdentifier} mutableCopy];
    [_iBeaconArray addObject:keysLocation];
    
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate new]];
    
    // Is this a GPS Location?
    for( NSMutableDictionary *aLocation in _locationsArray )
    {
        NSString *aLocationIdentifier = [aLocation objectForKey:@"identifier"];
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate new];
            localNotification.alertBody = [NSString stringWithFormat:@"GPS: Inside %@ [%@]", [aLocation objectForKey:@"description"], formattedDate];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            NSLog(@"Start Ranging: %@", [aLocation objectForKey:@"description"]);
            [manager startUpdatingLocation];
        }
    }
    
    // Is this a Particle?
    for( NSMutableDictionary *aBeacon in _iBeaconArray )
    {
        NSString *aLocationIdentifier = [aBeacon objectForKey:@"identifier"];
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate new];
            localNotification.alertBody = [NSString stringWithFormat:@"iBeacon: Inside %@ [%@]", [aBeacon objectForKey:@"description"], formattedDate];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            CLBeaconRegion *aBeaconRegion = [aBeacon objectForKey:@"region"];
            NSLog(@"Start Ranging: %@", [aBeacon objectForKey:@"description"]);
            [manager startRangingBeaconsInRegion:aBeaconRegion];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate new]];
    
    // Is this a GPS Location?
    for( NSMutableDictionary *aLocation in _locationsArray )
    {
        NSString *aLocationIdentifier = [aLocation objectForKey:@"identifier"];
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate new];
            localNotification.alertBody = [NSString stringWithFormat:@"GPS: Outside %@ [%@]", [aLocation objectForKey:@"description"], formattedDate];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            // This seems harsh since you cannot specify a specific region to stop monitoring.
            //[manager stopUpdatingHeading];
        }
    }
    
    // Is this a Particle?
    for( NSMutableDictionary *aBeacon in _iBeaconArray )
    {
        NSString *aLocationIdentifier = [aBeacon objectForKey:@"identifier"];
        NSLog(@"DIAG: comparing %@ to %@", aLocationIdentifier, region.identifier);
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate new];
            localNotification.alertBody = [NSString stringWithFormat:@"iBeacon: Outside %@ [%@]", [aBeacon objectForKey:@"description"], formattedDate];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            CLBeaconRegion *aBeaconRegion = [aBeacon objectForKey:@"region"];
            NSLog(@"Stop Ranging: %@", [aBeacon objectForKey:@"description"]);
            [manager stopRangingBeaconsInRegion:aBeaconRegion];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Start Monitoring Region: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{    
    for( CLBeacon *aBeacon in beacons )
    {
        NSLog(@"Ranged: %@: %@ // %@ (%2.1f meters)", aBeacon.proximityUUID.UUIDString, aBeacon.major, aBeacon.minor, aBeacon.accuracy);
        
        for( NSMutableDictionary *aBeaconObject in _iBeaconArray )
        {
            NSString *aLocationIdentifier = [aBeaconObject objectForKey:@"identifier"];
            if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
            {
                [aBeaconObject setObject:[NSNumber numberWithInt:aBeacon.proximity] forKey:@"proximity"];
                [aBeaconObject setObject:[NSNumber numberWithFloat:aBeacon.accuracy] forKey:@"accuracy"];
            }
        }
    }

    [self performSelectorOnMainThread:@selector(refreshTable) withObject:Nil waitUntilDone:YES];
    
}

-(void)refreshTable
{
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring Failed With Error: %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // this is generic by IDENTIFIER property, whether Beacon or GPS
    NSLog(@"State: %ld for %@", state, region.identifier);
    
    // Is this a Location?
    for( NSMutableDictionary *aLocation in _locationsArray )
    {
        NSString *aLocationIdentifier = [aLocation objectForKey:@"identifier"];
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            [aLocation setObject:[NSNumber numberWithInt:state] forKey:@"state"];
            if( state == CLRegionStateInside )
            {
                NSLog(@"Start Ranging: %@", [aLocation objectForKey:@"description"]);
                [_locationManager startUpdatingLocation];
            }
            // Again, seems harsh to do this.
            //else
            //    [_locationManager stopRangingBeaconsInRegion:aBeaconRegion];
        }
    }
    
    // Is this a Particle?
    for( NSMutableDictionary *aBeacon in _iBeaconArray )
    {
        NSString *aLocationIdentifier = [aBeacon objectForKey:@"identifier"];
        if( [aLocationIdentifier compare:region.identifier] == NSOrderedSame )
        {
            [aBeacon setObject:[NSNumber numberWithInt:state] forKey:@"state"];
            CLBeaconRegion *aBeaconRegion = [aBeacon objectForKey:@"region"];
            NSLog(@"Updated iBeacon %@", aBeacon);
            
            if( state == CLRegionStateInside )
            {
                NSLog(@"Start Ranging: %@", [aBeacon objectForKey:@"description"]);
                [_locationManager startRangingBeaconsInRegion:aBeaconRegion];
            }
            else
            {
                NSLog(@"Stop Ranging: %@", [aBeacon objectForKey:@"description"]);
                [_locationManager stopRangingBeaconsInRegion:aBeaconRegion];
            }
        }
    }
    
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:Nil waitUntilDone:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // This is a GPS Location Update for displaying Lat/Long/Accuracy updates only
    NSLog(@"GPS Location Update: %@", locations);
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:Nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == Region7SectionGPS)
    {
        return @"GPS Locations";
    }
    else if( section == Region7SectionBeacon)
    {
        return @"iBeacons";
    }
    else if( section == Region7SectionCurrentLocation)
    {
        return @"Current Location";
    }
    else
        return @"Unknown Section";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Region7SectionGPS)
    {
        return _locationsArray.count;
    }
    else if( section == Region7SectionBeacon )
    {
        return _iBeaconArray.count;
    }
    else if( section == Region7SectionCurrentLocation )
    {
        return 4;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    if( indexPath.section == Region7SectionGPS )
    {
        NSMutableDictionary *aLocation = [_locationsArray objectAtIndex:indexPath.row];
        NSString *description = [aLocation objectForKey:@"description"];
        cell.textLabel.text = description;
        
        NSNumber *state = [aLocation objectForKey:@"state"];
        switch (state.intValue)
        {
            case CLRegionStateUnknown:
                cell.detailTextLabel.text = @"Unknown Location";
                break;
                
            case CLRegionStateInside:
                cell.detailTextLabel.text = @"Inside Region";
                break;
                
            case CLRegionStateOutside:
                cell.detailTextLabel.text = @"Outside Region";
                break;
                
            default:
                break;
        }
    }
    else if( indexPath.section == Region7SectionBeacon )
    {
        NSMutableDictionary *aBeacon = [_iBeaconArray objectAtIndex:indexPath.row];
        NSString *description = [aBeacon objectForKey:@"description"];
        cell.textLabel.text = description;
        
        NSMutableString *beaconStateString = [NSMutableString string];
        
        NSNumber *state = [aBeacon objectForKey:@"state"];
        switch (state.intValue)
        {
            case CLRegionStateUnknown:
                [beaconStateString appendString:@"Unknown Location"];
                break;
                
            case CLRegionStateInside:
            {
                [beaconStateString appendString:[NSString stringWithFormat:@"Inside Region (%2.1f m)", [[aBeacon objectForKey:@"accuracy"] floatValue]]];
            }   break;
                
            case CLRegionStateOutside:
                [beaconStateString appendString:@"Outside Region"];
                break;
                
            default:
                break;
        }
        
        NSNumber *proximity = [aBeacon objectForKey:@"proximity"];
        switch (proximity.intValue)
        {
            case CLProximityUnknown:
                [beaconStateString appendString:@": Unknown"];
                break;
                
            case CLProximityNear:
                [beaconStateString appendString:@": Near"];
                break;
                
            case CLProximityImmediate:
                [beaconStateString appendString:@": Immediate"];
                break;
                
            case CLProximityFar:
                [beaconStateString appendString:@": Far"];
                break;
                
            default:
                break;
        }
        
        cell.detailTextLabel.text = beaconStateString;
        
    }
    else if( indexPath.section == Region7SectionCurrentLocation )
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%3.8fº", _locationManager.location.coordinate.latitude];
                cell.detailTextLabel.text = @"Latitude";
                break;
                
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%3.8fº", _locationManager.location.coordinate.longitude];
                cell.detailTextLabel.text = @"Longitude";
                break;
                
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%3.2f m", _locationManager.location.horizontalAccuracy];
                cell.detailTextLabel.text = @"Horizontal Accuracy";
                break;
                
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%3.2f m", _locationManager.location.verticalAccuracy];
                cell.detailTextLabel.text = @"Vertical Accuracy";
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

@end