//
//  SecondViewController.m
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/16/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float Rth;
    float R0;
    float B;
    float temp;
    float absT;
    float T0;
    float A;
    T0 = 25;
    absT = 273;
    Rth = 2979;
    R0 = 10000;
    B = 3380;
    A = (log(Rth/R0))/B+(1/(T0+absT));
    temp = 1/A - absT;
    NSLog(@"%f",temp);
    NSLog(@"%f", A);
    NSLog(@"%f", log(Rth/R0));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
