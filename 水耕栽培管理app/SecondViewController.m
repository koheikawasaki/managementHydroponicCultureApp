//
//  SecondViewController.m
//  水耕栽培管理app
//
//  Created by Kohei Kawasaki on 6/16/15.
//  Copyright (c) 2015 koheikawsaki. All rights reserved.
//
/*
 温度測定のやり方
 1. 3v or 5v の出力は出してる
 2. とりあえずはボタンをおす
 3. 3回ほどAIO0(thermistor + resiterの電圧降下値), AIO1(resiterの電圧降下)の電圧を読み取る
 4. 平均を出すかひどいのを弾くかでいい値を取ってくる←いるかな？
 5. 電圧から温度を計算する
 6. UILabalに表示させる*/
#import "SecondViewController.h"
#import "Konashi.h"
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
    
    [self.dacBar0 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    [self.dacBar1 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    [self.dacBar2 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    
    // ADC
    [Konashi addObserver:self selector:@selector(onGetAio0) name:KonashiEventAnalogIO0DidUpdateNotification];
    [Konashi addObserver:self selector:@selector(onGetAio1) name:KonashiEventAnalogIO1DidUpdateNotification];
    [Konashi addObserver:self selector:@selector(onGetAio2) name:KonashiEventAnalogIO2DidUpdateNotification];
    
    [Konashi shared].analogPinDidChangeValueHandler = ^(KonashiAnalogIOPin pin, int value) {
        NSLog(@"aio changed:%d(pin:%d)", value, pin);
    };
    int volt = 1300;
    [Konashi analogWrite:KonashiAnalogIO2 milliVolt:volt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onChangeDacBar:(id)sender
{
    if(sender == self.dacBar0){
        self.dac0.text = [NSString stringWithFormat:@"%.3f", self.dacBar0.value * 1.3];
    }
    else if(sender == self.dacBar1){
        self.dac1.text = [NSString stringWithFormat:@"%.3f", self.dacBar1.value * 1.3];
    }
    else if(sender == self.dacBar2){
        self.dac2.text = [NSString stringWithFormat:@"%.3f", self.dacBar2.value * 1.3];
    }
}

- (IBAction)setAio0:(id)sender {
    int volt = (int)(self.dacBar0.value * 1300);
    [Konashi analogWrite:KonashiAnalogIO0 milliVolt:volt];
}

- (IBAction)setAio1:(id)sender {
    int volt = (int)(self.dacBar1.value * 1300);
    [Konashi analogWrite:KonashiAnalogIO1 milliVolt:volt];
}

- (IBAction)setAio2:(id)sender {
    int volt = (int)(self.dacBar2.value * 1300);
    [Konashi analogWrite:KonashiAnalogIO2 milliVolt:volt];
}


/////////////////////////////////////
// ADC

- (IBAction)getAio0:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO0];
}

- (IBAction)getAio1:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO1];
}

- (IBAction)getAio2:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO2];
}

- (void)onGetAio0
{
    self.adc0.text = [NSString stringWithFormat:@"%.3f", (double)[Konashi analogRead:KonashiAnalogIO0] / 1000];
}
- (void)onGetAio1
{
    self.adc1.text = [NSString stringWithFormat:@"%.3f", (double)[Konashi analogRead:KonashiAnalogIO1] / 1000];
}
- (void)onGetAio2
{
    self.adc2.text = [NSString stringWithFormat:@"%.3f", (double)[Konashi analogRead:KonashiAnalogIO2] / 1000];
}


- (IBAction)getTemperature:(id)sender {
    float V1;
    float V2;
    V1 = [Konashi analogReadRequest:KonashiAnalogIO0];
    V2 = [Konashi analogReadRequest:KonashiAnalogIO1];
    NSLog(@"%f", V1);
    NSLog(@"%f", V2);
    
    
}



@end
