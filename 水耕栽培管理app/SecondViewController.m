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
 3. AIO0(thermistor + resiterの電圧降下値), AIO1(resiterの電圧降下)の電圧を読み取る
 4. 平均を出すかひどいのを弾くかでいい値を取ってくる←いるかな？
 5. 電圧から温度を計算する
 6. UILabalに表示させる
 */
#import "SecondViewController.h"
#import "Konashi.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////
// DAC

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
double a, b, c, d;

- (IBAction)getAio0:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO0];
    [self performSelector:@selector(readAio1) withObject:nil afterDelay:0.1];
}
- (void)readAio1
{
    NSLog(@"performSelector complete!");
    [Konashi analogReadRequest:KonashiAnalogIO1];
    [self performSelector:@selector(defV0V1calc) withObject:nil afterDelay:0.1];
}
- (void)defV0V1calc
{
    double V0, V1;
    V0 = [Konashi analogRead:KonashiAnalogIO0];
    V1 = [Konashi analogRead:KonashiAnalogIO1];
    NSLog(@"Voltage is %f%f", V0, V1);
    float Rth, R0, B, temp, absT, T0, A;
    T0 = 25;
    absT = 273;
    R0 = 10000;
    B = 3380;
    Rth = 330*(V0/V1);
    A = (log(Rth/R0))/B+(1/(T0+absT));
    temp = 1/A - absT;
    NSLog(@"%f//%f", Rth, temp);
    NSString *str3 = [NSString stringWithFormat:@"%.1f", temp];
    self.adc0.text = str3;
    
    
    
        /*// ラベルの設置
        CGRect rect = CGRectMake(10, 10, 100, 100);
        UILabel *label = [[UILabel alloc]initWithFrame:rect];
        
        // ラベルのテキストを設定
        label.text = str3;
        
        // ラベルのテキストのフォントを設定
        label.font = [UIFont fontWithName:@"Helvetica" size:16];
        
        // ラベルのテキストの色を設定
        label.textColor = [UIColor blueColor];
        
        // ラベルのテキストの影を設定
        label.shadowColor = [UIColor grayColor];
        label.shadowOffset = CGSizeMake(1, 1);
        
        // ラベルのテキストの行数設定
        label.numberOfLines = 0; // 0の場合は無制限
        
        // ラベルの背景色を設定
        label.backgroundColor = [UIColor whiteColor];
        
        // ラベルをビューに追加
        [self.view addSubview:label];*/
}


- (IBAction)getAio1:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO1];
}

- (IBAction)getAio2:(id)sender {
    [Konashi analogReadRequest:KonashiAnalogIO2];
}

- (void)onGetAio0
{
}
- (void)onGetAio1
{
    self.adc1.text = [NSString stringWithFormat:@"%.3f", (double)[Konashi analogRead:KonashiAnalogIO1] / 1000];
}
- (void)onGetAio2
{
    self.adc2.text = [NSString stringWithFormat:@"%.3f", (double)[Konashi analogRead:KonashiAnalogIO2] / 1000];
}
- (IBAction)getTemperature:(id)sender
{
    int a;
    a = [Konashi analogReadRequest:KonashiAnalogIO0];
    NSLog(@"testTemperature%d", a);
}

/////////////////////////////////////
// I/O設定

- (void)onChangePin:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
    
    if(pin==self.pin0){
        if(pin.on){
            self.out0.enabled = YES;
            self.pullup0.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO0 mode:KonashiPinModeOutput];
        } else {
            self.out0.enabled = NO;
            self.pullup0.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO0 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin1){
        if(pin.on){
            self.out1.enabled = YES;
            self.pullup1.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO1 mode:KonashiPinModeOutput];
        } else {
            self.out1.enabled = NO;
            self.pullup1.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO1 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin2){
        if(pin.on){
            self.out2.enabled = YES;
            self.pullup2.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO2 mode:KonashiPinModeOutput];
        } else {
            self.out2.enabled = NO;
            self.pullup2.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO2 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin3){
        if(pin.on){
            self.out3.enabled = YES;
            self.pullup3.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO3 mode:KonashiPinModeOutput];
        } else {
            self.out3.enabled = NO;
            self.pullup3.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO3 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin4){
        if(pin.on){
            self.out4.enabled = YES;
            self.pullup4.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO4 mode:KonashiPinModeOutput];
        } else {
            self.out4.enabled = NO;
            self.pullup4.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO4 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin5){
        if(pin.on){
            self.out5.enabled = YES;
            self.pullup5.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO5 mode:KonashiPinModeOutput];
        } else {
            self.out5.enabled = NO;
            self.pullup5.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO5 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin6){
        if(pin.on){
            self.out6.enabled = YES;
            self.pullup6.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO6 mode:KonashiPinModeOutput];
        } else {
            self.out6.enabled = NO;
            self.pullup6.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO6 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin7){
        if(pin.on){
            self.out7.enabled = YES;
            self.pullup7.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO7 mode:KonashiPinModeOutput];
        } else {
            self.out7.enabled = NO;
            self.pullup7.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO7 mode:KonashiPinModeInput];
        }
    }
}


/////////////////////////////////////
// OUTPUT / 出力

- (void)onChangeOutput:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
    
    if(pin==self.out0){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO0 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO0 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out1){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out2){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out3){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO3 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO3 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out4){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO4 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO4 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out5){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO5 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO5 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out6){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO6 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO6 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out7){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO7 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO7 value:KonashiLevelLow];
        }
    }
}


/////////////////////////////////////
// PULLUP / プルアップ

- (void)onChangePullup:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
    
    if(pin==self.pullup0){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO0 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO0 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup2){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO2 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO2 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup3){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO3 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO3 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup4){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO4 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO4 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup5){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO5 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO5 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup6){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO6 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO6 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup7){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO7 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO7 mode:KonashiPinModeNoPulls];
        }
    }
}


/////////////////////////////////////
// 入力の変化

- (void)updatePioInput
{
    self.in0.on = [Konashi digitalRead:KonashiDigitalIO0];
    self.in1.on = [Konashi digitalRead:KonashiDigitalIO1];
    self.in2.on = [Konashi digitalRead:KonashiDigitalIO2];
    self.in3.on = [Konashi digitalRead:KonashiDigitalIO3];
    self.in4.on = [Konashi digitalRead:KonashiDigitalIO4];
    self.in5.on = [Konashi digitalRead:KonashiDigitalIO5];
    self.in6.on = [Konashi digitalRead:KonashiDigitalIO6];
    self.in7.on = [Konashi digitalRead:KonashiDigitalIO7];
}



@end
