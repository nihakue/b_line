//
//  GameViewController.m
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import "GameViewController.h"
@interface GameViewController ()

@end
@implementation GameViewController
@synthesize isRunning, gameTimer;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id)initWithDestination:(NSString *)destination{
    self = [super init];
    if (self) {
        hasTouchedRecently = YES;
        hasLine = NO;
        CLGeocoder * coder = [[CLGeocoder alloc]init];
        [coder geocodeAddressString:destination completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"Error Geocoding:");
                NSLog(@"%@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Getting Location!" message:@"There was an error finding that location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                place = [[NSArray alloc]initWithArray:placemarks];
                activeDestination = destination;
                [self startGameLoop];
                
            }
        }];
    }
    return self;
}

-(id)initWithLine:(Line *)lineToLoad{
    self = [super init];
    if (self) {
        hasTouchedRecently = YES;
        hasLine = NO;
        activeLine = lineToLoad;
        activeDestination = lineToLoad.destination;
        [self startGameLoop];
        }
    return self;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self returnToMainMenu];
}

-(void)returnToMainMenu{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view.window setRootViewController:app.tabBarController];
}
    
#pragma mark - Initialization Helpers

-(BOOL)setupMap{
    
    __block GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.73547
                                                                    longitude:-111.82642
                                                                         zoom:1];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    self.view = mapView_;
    [self waitForLocationInfo];
    
    return YES;
    
    
}

-(void)addLineToMap:(Line*)lineToAdd{

    CLGeocoder * deCoder = [[CLGeocoder alloc] init];
    [deCoder reverseGeocodeLocation:lineToAdd.startingLocation completionHandler:^(NSArray* placemarks, NSError *error){
        CLPlacemark * startPlace = [placemarks objectAtIndex:0];
        activeLine.title = [NSString stringWithFormat:@"%@ -> %@", startPlace.locality, activeDestination];
    }];
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithTarget:lineToAdd.startingLocation.coordinate zoom:15];
    mapView_.camera = camera;
    
    GMSMarker *start = [GMSMarker markerWithPosition:lineToAdd.startingLocation.coordinate];
    start.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    start.position = lineToAdd.startingLocation.coordinate;
    start.title = @"START";
    start.snippet = @"Get from here...";
    start.map = mapView_;
    
    GMSMarker *goal = [GMSMarker markerWithPosition:lineToAdd.endingLocation.coordinate];
    goal.title = @"GOAL";
    goal.snippet = @"...to here!";
    goal.map = mapView_;
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:lineToAdd.startingLocation.coordinate];
    [path addCoordinate:lineToAdd.endingLocation.coordinate];
    GMSPolyline *line = [GMSPolyline polylineWithPath:path];
    line.strokeColor = [UIColor blueColor];
    line.strokeWidth = 4;
    line.map = mapView_;
    
    [mapView_ setNeedsDisplay];
    [mapView_ animateToLocation:lineToAdd.startingLocation.coordinate];
    
    //Animate the readysteady go stuff
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        mapView_.selectedMarker = start;
        [self mapView:mapView_ didTapMarker:start];
    });
    hasLine = YES;
    [self startLineRun];
}


-(void)startLineRun{
    activeLineRun = [[LineRun alloc]initWithLine:activeLine];
    activeLineRun.status = LRStatusRunning;
}


#pragma mark - GameLoop

-(void)startGameLoop{
    if (!mapView_) {
        [self setupMap];
    }
    isRunning = YES;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

-(void)calculateChanges{
    distanceFromLine = [activeLine minDistanceTo:mapView_.myLocation];
    activeLineRun.score += 10/(distanceFromLine+1);
    touchTimeCounter++;
    if (touchTimeCounter > 10) {
        hasTouchedRecently = false;
    }
}

-(void)renderMap{
    if (!hasTouchedRecently) {
        GMSCameraPosition * followCam = [GMSCameraPosition cameraWithTarget:mapView_.myLocation.coordinate zoom:15];
        [mapView_ animateToCameraPosition:followCam];
    }
    
    //Custom player marker. Don't really think this is neccesary
//    if (!playerMarker_) {
//        playerMarker_ = [GMSMarker markerWithPosition:mapView_.myLocation.coordinate];
//        playerMarker_.icon = [UIImage imageNamed:@"playerMarker"];
//        playerMarker_.map = mapView_;
//    }
//    else{
//        playerMarker_.position = mapView_.myLocation.coordinate;
//    }
    
    if(!debugView){
        debugView = [[BDView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width-100, 20)];
        [self.view addSubview:debugView];
    }
    [debugView drawWithBlock:^(CGContextRef context, CGRect rect){
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextFillRect(context, rect);
        
        NSString * debugInfo = [NSString stringWithFormat:@"distance: %.2f Score: %.2f", distanceFromLine, activeLineRun.score];
        CGContextSetRGBFillColor(context, .3, .5, .4, 1);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextSelectFont(context, "System", 14, kCGEncodingMacRoman);
        CGContextSetTextPosition(context, debugView.frame.origin.x, debugView.frame.origin.y);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        [debugInfo drawInRect:rect withFont:[UIFont systemFontOfSize:14]];
        
    }];
    
    
}
-(void)gameLoop{
    if (isRunning){
        if (!mapView_.myLocation) {
            [self waitForLocationInfo];
        }
        else{
            [self calculateChanges];
            [self alertPlayerOfPosition];

            if ([self winConditionsMet]) {
                [self win];
            }
            [self renderMap];
        }
    }
}

-(void)stopGameLoop{
    isRunning = NO;
    [gameTimer invalidate];
}


#pragma mark - Winning

-(BOOL)winConditionsMet{
    double distanceFromGoal = [mapView_.myLocation distanceFromLocation:activeLine.endingLocation];
    
    if (distanceFromGoal < 70 /*Meters*/) {
        return YES;
    }
    return NO;
}

-(void)win{
    NSLog(@"winner");
    [activeLineRun stopRunningWithStatus:LRStatusVictory];
    [self playSound:BLAudioWin];
    [self stopGameLoop];
    NSString * winStatsString = [NSString stringWithFormat:@"You won! Time %.2f Score: %.2f", [activeLineRun getRunTimeInSeconds], activeLineRun.score];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:winStatsString delegate:self cancelButtonTitle:@"Yay!" otherButtonTitles: nil];
    [[BLDataStore sharedStore] saveLineRuns];
    [[BLDataStore sharedStore ] saveLines];
    [alert show];
    mapView_ = nil;
}

#pragma mark - LocationFunctions

-(void)waitForLocationInfo{
    if (!gpsWaiter) {
        gpsWaiter = [[BLineLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [self.view addSubview:gpsWaiter];
    gpsCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(isLocationAvailable) userInfo:nil repeats:YES];
}

-(void)isLocationAvailable{
    if (mapView_.myLocation) {
        [gpsCheckTimer invalidate];
        [gpsWaiter removeFromSuperview];
        
        if (!activeLine) {
            CLPlacemark * placemark = place[0];
            activeLine = [[Line alloc]initWithTitle:activeDestination andStart:mapView_.myLocation andEnd:placemark.location];
            activeLine.destination = activeDestination;
            [self addLineToMap:activeLine];
        }
        else if (!hasLine){
            [self addLineToMap:activeLine];
        }
    }
}

#pragma mark - Sound Stuff

-(void)alertPlayerOfPosition{
    static int soundTicker = 0;
    if (soundTicker >= 5) {
        if (distanceFromLine < .5) {
        [self playSound:BLAudioNear];
        }
        else if (distanceFromLine < 1){
            [self playSound:BLAudioNotNear];
        }
        else if (distanceFromLine < 5){
            [self playSound:BLAudioFar];
        }
        else{
            [self playSound:BLAudioRealFar];
        }
        soundTicker = 0;
    }
    else{
        soundTicker++;
    }
}

-(void)playSound:(BLAudioAlert)sound{
    NSString * soundFilename;
    NSURL * soundURL;
    switch (sound) {
        case BLAudioNear:
            soundFilename = [[NSBundle mainBundle]pathForResource:@"near" ofType:@"wav"];
            soundURL = [NSURL fileURLWithPath:soundFilename];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];
            break;
        case BLAudioFar:
            soundFilename = [[NSBundle mainBundle]pathForResource:@"far" ofType:@"wav"];
            soundURL = [NSURL fileURLWithPath:soundFilename];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];
            break;
        case BLAudioNotNear:
            soundFilename = [[NSBundle mainBundle]pathForResource:@"notNear" ofType:@"wav"];
            soundURL = [NSURL fileURLWithPath:soundFilename];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];

            break;
        case BLAudioRealFar:
            soundFilename = [[NSBundle mainBundle]pathForResource:@"realFar" ofType:@"wav"];
            soundURL = [NSURL fileURLWithPath:soundFilename];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];

            break;
        case BLAudioWin:
            soundFilename = [[NSBundle mainBundle]pathForResource:@"win" ofType:@"wav"];
            soundURL = [NSURL fileURLWithPath:soundFilename];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];

            break;
        default:
            break;
    }
    audioPlayer.currentTime = 0;
    audioPlayer.volume = 1.0f;
    [audioPlayer play];
}


#pragma mark - Google Touch Implementations
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    hasTouchedRecently = YES;
    touchTimeCounter = 0;
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    if ([marker.title isEqual: @"START"]) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:1.0f] forKey:kCATransactionAnimationDuration];
            GMSCameraPosition * showFinish = [GMSCameraPosition cameraWithTarget:activeLine.endingLocation.coordinate zoom:15];
            [mapView_ animateToCameraPosition:showFinish];
            [CATransaction commit];
            mapView_.selectedMarker = [mapView_.markers lastObject];
            double delayInSeconds = 4.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [mapView_ animateToLocation:activeLine.startingLocation.coordinate];
                mapView.selectedMarker = nil;
            });
        });
    }
    NSLog(@"tapped marker");
    return NO;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    NSLog(@"tapped");
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self stopGameLoop];
    // Dispose of any resources that can be recreated.
}

@end
