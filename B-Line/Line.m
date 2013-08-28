 //
//  Line.m
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize title, startingLocation, endingLocation, baseLength, score, finishTime, destination;
#pragma mark - Initialization
-(id)init{
    self = [super init];
    if (self){
        self.title = @"";
    }
    return self;
}

-(id)initWithDestinationString:(NSString*)dest{
    self = [super init];
    if (self){
        self.title = dest;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.startingLocation = [aDecoder decodeObjectForKey:@"startingLocation"];
        self.endingLocation = [aDecoder decodeObjectForKey:@"endingLocation"];
        self.baseLength = [aDecoder decodeDoubleForKey:@"baseLength"];
        self.destination = [aDecoder decodeObjectForKey:@"destination"];
    }
    return self;
}

-(id)initWithTitle:(NSString *)aTitle andStart:(CLLocation *)startLocation andEnd:(CLLocation *)endLocation{
    self = [super init];
    if (self){
        self.title = aTitle;
        self.startingLocation = startLocation;
        self.endingLocation = endLocation;
        baseLength = [startingLocation distanceFromLocation:endingLocation];
        backgroundLocationManager = [[CLLocationManager alloc]init];
        backgroundLocationManager.delegate = self;
        [[BLDataStore sharedStore] addLine:self];
    }
    return self;
}

#pragma mark - Calculations

-(double)minDistanceTo:(CLLocation *)point{
    CLLocationDistance a = [startingLocation distanceFromLocation: point];
    CLLocationDistance b = [endingLocation distanceFromLocation:point];
    double area = [self areaOf:a and:b and:baseLength];
    double distance = (2*area)/baseLength;
    //Return the value in kilometers
    return distance/1000.00;
}

-(double)areaOf:(CLLocationDistance)side1 and:(CLLocationDistance)side2 and:(CLLocationDistance)side3{
    //Stabilize heron's formula
    NSNumber * s1;
    NSNumber * s2;
    NSNumber * s3;
    s1 = [NSNumber numberWithDouble:side1];
    s2 = [NSNumber numberWithDouble:side2];
    s3 = [NSNumber numberWithDouble:side3];
    NSArray * sideLenghts = [[NSArray alloc]initWithObjects:s1, s2, s3, nil];
    NSArray * orderedSideLengths = [sideLenghts sortedArrayUsingComparator:^NSComparisonResult(NSNumber* a, NSNumber* b){
        if ([a doubleValue] < [b doubleValue]) {
            return NSOrderedAscending;
        }
        else if ([a doubleValue] > [b doubleValue]){
            return NSOrderedDescending;
        }
        else{
            return NSOrderedDescending;
        }
    }];
    double a, b, c;
    c = [orderedSideLengths[0] doubleValue];
    b = [orderedSideLengths[1] doubleValue];
    a = [orderedSideLengths[2] doubleValue];
    return (sqrt((a+(b+c))*(c-(a-b))*(c+(a-b))*(a+(b-c))))/4;
}

#pragma mark - Saving

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:startingLocation forKey:@"startingLocation"];
    [aCoder encodeObject:endingLocation forKey:@"endingLocation"];
    [aCoder encodeDouble:baseLength forKey:@"baseLength"];
    [aCoder encodeObject:destination forKey:@"destination"];
}

#pragma mark - Background Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation * locationInfo in locations) {
        double distanceFromLocation = [self minDistanceTo:locationInfo];
        if (distanceFromLocation > .50) {
            NSLog(@"LINE LOCATION MANAGER: too far from line!");
        }
    }
}

@end
