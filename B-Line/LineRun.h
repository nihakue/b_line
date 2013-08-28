//
//  LineRun.h
//  B-Line
//
//  Created by Gabriel West on 4/24/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"
#import "BLDataStore.h"

typedef enum {
    LRStatusAbandoned = 0,
    LRStatusVictory = 1,
    LRStatusLoss = 2,
    LRStatusRunning = 3
    }LRFinishStatus;

@class Line;

@interface LineRun : NSObject <NSCoding>{
    BOOL finished;
    BOOL failed;
}

-(id)initWithLine:(Line*)aLine;
-(void)stopRunningWithStatus:(LRFinishStatus)status;
-(double)getRunTimeInSeconds;

@property(strong, nonatomic) NSString * runnerName;
@property(strong, nonatomic) NSDate * startTime;
@property(strong, nonatomic) NSDate * endTime;
@property(strong, nonatomic) Line * line;
@property(nonatomic) double score;
@property(nonatomic) LRFinishStatus status;

@end
