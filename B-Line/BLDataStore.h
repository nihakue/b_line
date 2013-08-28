//
//  BLDataStore.h
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"
#import "LineRun.h"
#import "BLRunView.h"

@class Line;
@class LineRun;

typedef Line*(^l_line)(Line*);

@interface BLDataStore : NSObject <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * lines;
    NSMutableArray * lineRuns;
}

+(BLDataStore *)sharedStore;

-(NSArray *)lines;
-(NSArray *)lineRuns;
-(NSString*)lineArchivePath;
-(NSString*)lineRunArchivePath;
-(BOOL)saveLines;
-(BOOL)saveLineRuns;
-(void)addLine:(Line *)line;
-(void)addLineRun:(LineRun *)lineRun;
-(void)actUpon:(NSArray*)lineArray withBlock:(l_line)aBlock;

@end
