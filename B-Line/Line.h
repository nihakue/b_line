//
//  Line.h
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BLDataStore.h"
@interface Line : NSObject <NSCoding, CLLocationManagerDelegate>{
    CLLocationManager *backgroundLocationManager;
    
}

-(id)initWithDestinationString:(NSString*)dest;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(id)initWithTitle:(NSString *)title andStart:(CLLocation *)startingLocation andEnd:(CLLocation*)endingLocation;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(double)minDistanceTo:(CLLocation*)point;

@property(strong, nonatomic) NSString * destination;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) CLLocation *endingLocation;
@property (strong, nonatomic) CLLocation *startingLocation;
@property (strong, nonatomic) NSDate *finishTime;
@property (nonatomic) double baseLength;
@property (nonatomic) double score;


@end
