//
//  GameViewController.h
//  B-Line
//
//  Created by Gabriel West on 4/18/13.
//  Copyright (c) 2013 Gabriel West. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "BLineLoadingView.h"
#import "BDView.h"
#import "LineRun.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

typedef enum {
    BLAudioNear = 0,
    BLAudioNotNear = 1,
    BLAudioFar = 2,
    BLAudioRealFar = 3,
    BLAudioWin = 4,
    } BLAudioAlert;

@interface GameViewController : UIViewController <GMSMapViewDelegate, UIAlertViewDelegate>{
    
    GMSMapView *mapView_;
    GMSMarker *playerMarker_;
    
    CLLocation *currentLocation;
    __block NSArray*place;
    
    Line * activeLine;
    LineRun * activeLineRun;
    
    AVAudioPlayer * audioPlayer;
    
    BLineLoadingView * gpsWaiter;
    BDView* debugView;
    
    NSTimer * gpsCheckTimer;
    
    NSString * activeDestination;

    double distanceFromLine;
    
    BOOL hasTouchedRecently;
    BOOL hasLine;
    int touchTimeCounter;
    
    
}

//Game Loop Stuff
-(void)gameLoop;
-(void)startGameLoop;
-(void)stopGameLoopWithStatus:(LRFinishStatus)status;
-(void)calculateChanges;
-(void)renderMap;
-(void)playSound:(BLAudioAlert)sound;

-(void)setLocation:(CLLocationCoordinate2D)coords;

-(id)initWithDestination:(NSString*)destination;
-(id)initWithLine:(Line*)lineToLoad;
@property(nonatomic)BOOL isRunning;
@property(strong, nonatomic) NSTimer *gameTimer;



@end
