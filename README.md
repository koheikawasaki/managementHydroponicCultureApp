workspaceから開いてください、エラーが出ます。
NSLOGで取ってきた値
2015-06-17 09:07:31.396 水耕栽培管理app[872:334114] aio changed:2718(pin:0)
2015-06-17 09:07:31.486 水耕栽培管理app[872:334114] aio changed:74(pin:1)

/*
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
NSLog(@"%f", log(Rth/R0));*/