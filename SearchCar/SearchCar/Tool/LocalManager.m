//
//  LocalManager.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "LocalManager.h"
#import <CoreLocation/CoreLocation.h>


@interface LocalManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *cLLocationManager;

@property (nonatomic, strong) CLGeocoder *cLGeocoder;

@property (nonatomic, copy) LocalSuccess localSucces;

@property (nonatomic, copy) LocalFaild faild;

@end

@implementation LocalManager

+ (instancetype )shareInstace{
    
    static dispatch_once_t onceToken;
    
    static LocalManager * localManager = nil;
    
    dispatch_once(&onceToken, ^{
        
        localManager = [[self alloc] init];
        
    });
    
    return localManager;
}

- (void)startLocalWithResult:(LocalSuccess)success faild:(LocalFaild)faild{
    
    _localSucces = success;
    _faild = faild;
    [self.cLLocationManager requestWhenInUseAuthorization];
    [self.cLLocationManager startUpdatingLocation];
}


- (CLLocationManager *)cLLocationManager{
    
    if (!_cLLocationManager) {
        
        _cLLocationManager = [[CLLocationManager alloc] init];
        _cLLocationManager.delegate = self;
        _cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return _cLLocationManager;
}


- (CLGeocoder *)cLGeocoder{
    
    if (!_cLGeocoder) {
        
        _cLGeocoder = [[CLGeocoder alloc] init];
        
    }
    
    return _cLGeocoder;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9)){
    [self.cLLocationManager stopUpdatingLocation];
    
    CLLocation *loc = locations.lastObject;
    
    [self.cLGeocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *comPlacemark = placemarks.firstObject;
        
        NSMutableString *address = [@"" mutableCopy];
        
        if(comPlacemark.locality.length)
            [address appendString:comPlacemark.locality];
        if(comPlacemark.subLocality.length)
            [address appendString:comPlacemark.subLocality];
        if(comPlacemark.name.length)
            [address appendString:comPlacemark.name];
        
        if(self.localSucces) self.localSucces(address);
        
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    
    if(error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法检索位置");
        
    }else if(error.code == kCLErrorNetwork) {
        NSLog(@"网络问题");
    }
    else if(error.code == kCLErrorDenied) {
        NSLog(@"定位权限的问题");
        [self.cLLocationManager stopUpdatingLocation];
       
    }
    
    if (self.faild) self.faild(error.code, @"定位失败");
}

@end
