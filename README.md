workspaceから開いてください、エラーが出ます。


T0 = 25;サーミスタの基準温度
absT = 273;絶対温度
Rth: サーミスタの抵抗
R0 = 10000;サーミスタの基準温度での抵抗値
B = 3380;B値
A: 気温の絶対温度の逆数
A = (log(Rth/R0))/B+(1/(T0+absT));
temp = 1/A - absT;
NSLog(@"%f",temp);
NSLog(@"%f", A);
NSLog(@"%f", log(Rth/R0));*/