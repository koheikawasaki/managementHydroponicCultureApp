//
//  FirstViewController.h
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/16/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

- (IBAction)connect:(id)sender;
- (IBAction)disconnect:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UIProgressView *dbBar;
@property (weak, nonatomic) IBOutlet UIProgressView *batteryBar;
@property (weak, nonatomic) IBOutlet UILabel *softwareRevisionString;


@end

