//
//  SecondViewController.h
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/16/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *dacBar0;
@property (weak, nonatomic) IBOutlet UISlider *dacBar1;
@property (weak, nonatomic) IBOutlet UISlider *dacBar2;
@property (weak, nonatomic) IBOutlet UILabel *dac0;
@property (weak, nonatomic) IBOutlet UILabel *dac1;
@property (weak, nonatomic) IBOutlet UILabel *dac2;
- (IBAction)setAio0:(id)sender;
- (IBAction)setAio1:(id)sender;
- (IBAction)setAio2:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *adc0;
@property (weak, nonatomic) IBOutlet UILabel *adc1;
@property (weak, nonatomic) IBOutlet UILabel *adc2;
- (IBAction)getAio0:(id)sender;
- (IBAction)getAio1:(id)sender;
- (IBAction)getAio2:(id)sender;
- (IBAction)getTemperature:(id)sender;


@property (weak, nonatomic) IBOutlet UISwitch *pin0;
@property (weak, nonatomic) IBOutlet UISwitch *pin1;
@property (weak, nonatomic) IBOutlet UISwitch *pin2;
@property (weak, nonatomic) IBOutlet UISwitch *pin3;
@property (weak, nonatomic) IBOutlet UISwitch *pin4;
@property (weak, nonatomic) IBOutlet UISwitch *pin5;
@property (weak, nonatomic) IBOutlet UISwitch *pin6;
@property (weak, nonatomic) IBOutlet UISwitch *pin7;

@property (weak, nonatomic) IBOutlet UISwitch *out0;
@property (weak, nonatomic) IBOutlet UISwitch *out1;
@property (weak, nonatomic) IBOutlet UISwitch *out2;
@property (weak, nonatomic) IBOutlet UISwitch *out3;
@property (weak, nonatomic) IBOutlet UISwitch *out4;
@property (weak, nonatomic) IBOutlet UISwitch *out5;
@property (weak, nonatomic) IBOutlet UISwitch *out6;
@property (weak, nonatomic) IBOutlet UISwitch *out7;

@property (weak, nonatomic) IBOutlet UISwitch *in0;
@property (weak, nonatomic) IBOutlet UISwitch *in1;
@property (weak, nonatomic) IBOutlet UISwitch *in2;
@property (weak, nonatomic) IBOutlet UISwitch *in3;
@property (weak, nonatomic) IBOutlet UISwitch *in4;
@property (weak, nonatomic) IBOutlet UISwitch *in5;
@property (weak, nonatomic) IBOutlet UISwitch *in6;
@property (weak, nonatomic) IBOutlet UISwitch *in7;

@property (weak, nonatomic) IBOutlet UISwitch *pullup0;
@property (weak, nonatomic) IBOutlet UISwitch *pullup1;
@property (weak, nonatomic) IBOutlet UISwitch *pullup2;
@property (weak, nonatomic) IBOutlet UISwitch *pullup3;
@property (weak, nonatomic) IBOutlet UISwitch *pullup4;
@property (weak, nonatomic) IBOutlet UISwitch *pullup5;
@property (weak, nonatomic) IBOutlet UISwitch *pullup6;
@property (weak, nonatomic) IBOutlet UISwitch *pullup7;



@end

