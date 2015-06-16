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

@end

