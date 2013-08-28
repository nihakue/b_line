//
//  LineRun.m
//  B-Line
//
//  Created by Gabriel West on 4/24/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//


#import "LineRun.h"

@implementation LineRun
@synthesize runnerName, startTime, endTime, line, score, status;

-(id)initWithLine:(Line *)aLine{
    self = [super init];
    if (self) {
        self.line = aLine;
        startTime = [NSDate date];
        runnerName = @"Jerry The Durable";
        [[BLDataStore sharedStore] addLineRun:self];
    }
    return self;
}

-(void)stopRunningWithStatus:(LRFinishStatus)stopStatus{
    switch (stopStatus) {
        case LRStatusAbandoned:
            NSLog(@"Abandoned Line");
            finished = NO;
            failed = NO;
            break;
        case LRStatusLoss:
            NSLog(@"Lost Line");
            finished = NO;
            failed = YES;
            break;
        case LRStatusVictory:
            self.endTime = [NSDate date];
            self.score = score/[self getRunTimeInSeconds];
            finished = YES;
            failed = NO;
            break;
        default:
            break;
    }
    status = stopStatus;
}

-(double)getRunTimeInSeconds{
    if (finished) {
        return [endTime timeIntervalSinceDate:startTime];
    }
    return -1;
}

#pragma Saving and Loading

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:startTime forKey:@"startTime"];
    [aCoder encodeObject:endTime forKey:@"endTime"];
    [aCoder encodeObject:line forKey:@"line"];
    [aCoder encodeObject:runnerName forKey:@"runnerName"];
    [aCoder encodeBool:finished forKey:@"finished"];
    [aCoder encodeBool:failed forKey:@"failed"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        startTime = [aDecoder decodeObjectForKey:@"startTime"];
        endTime = [aDecoder decodeObjectForKey:@"endTime"];
        line = [aDecoder decodeObjectForKey:@"line"];
        runnerName = [aDecoder decodeObjectForKey:@"runnerName"];
        failed = [aDecoder decodeBoolForKey:@"failed"];
        finished = [aDecoder decodeBoolForKey:@"finished"];
    }
    return self;
}
@end
