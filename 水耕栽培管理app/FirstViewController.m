//
//  FirstViewController.m
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/16/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//

#import "FirstViewController.h"
#import "Konashi.h"


@interface FirstViewController ()

@end

@implementation FirstViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // コネクション系
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi shared].connectedHandler = ^() {
        NSLog(@"connected");
    };
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
    [Konashi shared].readyHandler = ^() {
        NSLog(@"ready to use");
    };
    
    [Konashi shared].disconnectedHandler = ^() {
        NSLog(@"disconnected");
    };
    
    // 電波強度
    [Konashi addObserver:self selector:@selector(updateRSSI) name:KonashiEventSignalStrengthDidUpdateNotification];
    [Konashi shared].signalStrengthDidUpdateHandler = ^(int value) {
        NSLog(@"RSSI did update:%d", value);
    };
    
    // バッテリー
    [Konashi addObserver:self selector:@selector(updateBatteryLevel) name:KonashiEventBatteryLevelDidUpdateNotification];
    [Konashi shared].batteryLevelDidUpdateHandler = ^(int value) {
        NSLog(@"battery level did update:%d", value);
    };
    
    if ( [Konashi isConnected] ) {
        [Konashi disconnect];
        [self.connectButton setTitle: @"konashi に接続する" forState:UIControlStateNormal];
    } else {
        [Konashi find];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
    self.statusMessage.hidden = true;
}

- (IBAction)reset:(id)sender {
    [Konashi reset];
}

///////////////////////////////////////////////////
// 使い方
- (IBAction)howto:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://konashi.ux-xu.com/getting_started/#first_touch"]];
}

- (void)connected
{
    NSLog(@"CONNECTED");
}

- (void)ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
    
    // 電波強度タイマー
    NSTimer *tm = [NSTimer
                   scheduledTimerWithTimeInterval:01.0f
                   target:self
                   selector:@selector(onRSSITimer:)
                   userInfo:nil
                   repeats:YES
                   ];
    [tm fire];
}

///////////////////////////////////////////////////
// 電波強度

- (void) onRSSITimer:(NSTimer*)timer
{
    [Konashi signalStrengthReadRequest];
}

- (void) updateRSSI
{
    float progress = -1.0 * [Konashi signalStrengthRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.dbBar.progress = progress / 100;
    
    //NSLog(@"RSSI: %ddb", [Konashi signalStrengthRead]);
}


///////////////////////////////////////////////////
// バッテリー

- (IBAction)getBattery:(id)sender {
    [Konashi batteryLevelReadRequest];
}

- (void) updateBatteryLevel
{
    float progress = [Konashi batteryLevelRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.batteryBar.progress = progress / 100;
    
    NSLog(@"BATTERY LEVEL: %d%%", [Konashi batteryLevelRead]);
}

@end
