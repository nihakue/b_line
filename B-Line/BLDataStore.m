//
//  BLDataStore.m
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "BLDataStore.h"

@implementation BLDataStore

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

+(BLDataStore *)sharedStore{
    static BLDataStore *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

-(id)init{
    self = [super init];
    if (self){
        
        NSString *linePath = [self lineArchivePath];
        NSString *lineRunPath = [self lineRunsArchivePath];
        lines = [NSKeyedUnarchiver unarchiveObjectWithFile:linePath];
        lineRuns = [NSKeyedUnarchiver unarchiveObjectWithFile:lineRunPath];
        if (!lines) {
            lines = [[NSMutableArray alloc] init];
        }
        if (!lineRuns) {
            lineRuns = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

-(NSArray *)lines{
    return lines;
}

-(NSArray *)lineRuns{
    return lineRuns;
}

-(NSString *)lineArchivePath{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"lines.archive"];
}

-(NSString *)lineRunsArchivePath{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"lineRuns.archive"];
}
-(void)addLine:(Line *)line{
    [lines addObject:line];
}
-(void)addLineRun:(LineRun *)lineRun{
    [lineRuns addObject:lineRun];
}

-(void)actUpon:(NSArray *)lineArray withBlock :(l_line)aBlock{
    for (Line __strong *line in lineArray) {
        line = aBlock(line);
    }
    
}

-(BOOL)saveLines{
    NSString *path = [self lineArchivePath];
    return [NSKeyedArchiver archiveRootObject:lines toFile:path];
}

-(BOOL)saveLineRuns{
    NSString *path = [self lineRunsArchivePath];
    return [NSKeyedArchiver archiveRootObject:lineRuns toFile:path];
}

#pragma mark - Table View Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *unused = @"UNUSED";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unused];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unused];
    }
    cell.textLabel.text = ((Line*)[lines objectAtIndex:indexPath.row]).title;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backView;
    return cell;

}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Your Lines:";
}




-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [lines removeObjectAtIndex:indexPath.row];
    }
    [tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return lines.count;
}
#pragma mark UITableViewDelegate methods


@end
