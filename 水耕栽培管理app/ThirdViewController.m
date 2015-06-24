//
//  ThirdViewController.m
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/19/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//

#import "ThirdViewController.h"
#import <UIKit/UIKit.h>
#import "Konashi.h"


@interface ThirdViewController()

@end

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    
    // 入力状態の変化イベントハンドラ
    [Konashi addObserver:self selector:@selector(updatePioInput) name:KonashiEventDigitalIODidUpdateNotification];
    
    [Konashi shared].digitalInputDidChangeValueHandler = ^(KonashiDigitalIOPin pin, int value) {
        NSLog(@"pio input changed:%d(pin:%d)", value, pin);
    };
    [Konashi shared].digitalOutputDidChangeValueHandler = ^(KonashiDigitalIOPin pin, int value) {
        NSLog(@"pio output changed:%d(pin:%d)", value, pin);
    };
    [Konashi pinMode:KonashiDigitalIO0 mode:KonashiPinModeOutput];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)LightOn:(id)sender
{
    [Konashi pinMode:KonashiDigitalIO1 mode:KonashiPinModeOutput];
    [self performSelector:@selector(LightOn1) withObject:nil afterDelay:0.01];
}

- (void)LightOn1
{
    [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelHigh];
}

- (void)LightOff:(id)sender
{
    [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelLow];
}



@end
