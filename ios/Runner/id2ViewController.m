
#import "id2ViewController.h"
#include "comminterface.h"
#import "idinterface.h"
//#import "BLEViewController.h"


#import <AudioToolbox/AudioToolbox.h>


@implementation id2ViewController
@synthesize rssi_container;

@synthesize peripheralArray;

//@synthesize timer;
//@synthesize commi;
//CBCentralManager *manager;


@class comminterface;
@synthesize _yxqx = yxqx;
@synthesize _xm = xm;
@synthesize _imgView;
@synthesize   _xb = xb;
@synthesize   _mz = mz;
@synthesize   _nian = nian;
@synthesize   _yue = yue;
@synthesize   _ri = ri;
@synthesize   _zz = zz;
@synthesize   _sfzh = sfzh;
@synthesize   _info;

@synthesize   lblDeviceid = _lblDeviceid;
//CBPeripheral *gPeripheral;
@synthesize   gPeripheral;

int okCount = 0;
int errorCount = 0;
int readCardCount = 0;

static SystemSoundID shake_sound_male_id = 0;

Byte device_uuid[] =  {0x00,0x00,0x11,0x01,0x00,0x00,0x10,0x00,0x80,0x00,0x00,0x80,0x5F,0x9B,0x34,0xFB};
bool bStop = false;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    peripheralArray = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    bStop = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    okCount = 0;
    errorCount = 0;
    [self clearId2Info];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)btnDkljPress:(id)sender {
   /* bStop = false;
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(readCardThread)
                                                   object:nil];
    [myThread start];*/
    
    unsigned char pucSamMsg[256];
    int puiSamMsgLen;

    int nRet = ReadSamNum(pucSamMsg,&puiSamMsgLen);
    
    NSString *SamId =  [[NSString alloc]initWithBytes:&pucSamMsg[0] length:puiSamMsgLen encoding:NSUTF8StringEncoding ];
    self._info.text = SamId;

}

- (IBAction)btnQsjsPress:(id)sender {
}

- (IBAction)btnGxmyPress:(id)sender {
}

- (IBAction)btnDkPress:(id)sender {
    NSString * yxqxqs = @"";
    NSString * yxqxjz = @"";
    unsigned char idTxt[256];
    unsigned char idPic[1024];
    unsigned char idFp[1024];
//    
//    unsigned char pucSamMsg[256];
//    int puiSamMsgLen;
    //int nRet = ReadSamNum(pucSamMsg,&puiSamMsgLen);

    
    int nRet = getIdCardInfo(&idTxt, &idPic, &idFp, 3);
    //05000300
    //61793301
    //218e3800
    //d3bfaa52
    
    [self clearId2Info];

    if(nRet != 0){
        self._info.text = @"读卡失败";
        [self playSound:2];
        return;
    }
    
    [self playSound:1];

    self._xm.text = [[NSString alloc]initWithBytes:&idTxt[0] length:30 encoding:NSUTF16LittleEndianStringEncoding ];
    NSLog(@"xm is:%@",[[NSString alloc]initWithBytes:&idTxt[0] length:30 encoding:NSUTF16LittleEndianStringEncoding ]);
    self._xb.text = [self GetSexFromCode:[[NSString alloc]initWithBytes:&idTxt[30] length:2 encoding:NSUTF16LittleEndianStringEncoding ]];//[[NSString alloc]initWithBytes:&idTxt[30] length:2 encoding:NSUTF16LittleEndianStringEncoding ];
    self._mz.text = [self GetNationalFromCode:[[NSString alloc]initWithBytes:&idTxt[32] length:4 encoding:NSUTF16LittleEndianStringEncoding ]];//[[NSString alloc]initWithBytes:&idTxt[32] length:4 encoding:NSUTF16LittleEndianStringEncoding ];
    self._nian.text = [[NSString alloc]initWithBytes:&idTxt[36] length:8 encoding:NSUTF16LittleEndianStringEncoding ];
    self._yue.text = [[NSString alloc]initWithBytes:&idTxt[44] length:4 encoding:NSUTF16LittleEndianStringEncoding ];
    self._ri.text = [[NSString alloc]initWithBytes:&idTxt[48] length:4 encoding:NSUTF16LittleEndianStringEncoding ];
    self._zz.text = [[NSString alloc]initWithBytes:&idTxt[52] length:70 encoding:NSUTF16LittleEndianStringEncoding ];
    self._sfzh.text = [[NSString alloc]initWithBytes:&idTxt[122] length:36 encoding:NSUTF16LittleEndianStringEncoding ];
    self.lblDeviceid3.text = [[NSString alloc]initWithBytes:&idTxt[158] length:30 encoding:NSUTF16LittleEndianStringEncoding ];//certOrg
    yxqxqs =  [[NSString alloc]initWithBytes:&idTxt[188] length:16 encoding:NSUTF16LittleEndianStringEncoding ];
    yxqxqs =  [yxqxqs stringByAppendingString:@"--"];
    yxqxjz =  [[NSString alloc]initWithBytes:&idTxt[204] length:16 encoding:NSUTF16LittleEndianStringEncoding ];
    self._yxqx.text = [yxqxqs stringByAppendingString:yxqxjz];
    self._info.text = @"读卡成功";
    
    char bmpBuff[40000];
    
    //NSLog(@"idPic is: %@", [self bytesToHexString:idPic :1024]);
    nRet= id2GetBmpBuff((Byte*)&idPic[0] ,(Byte*)&bmpBuff[0]);
    
    NSData * bmpData = [[NSData alloc]initWithBytes:bmpBuff length:38862];
    UIImage *zpImg=[UIImage imageWithData:bmpData];
    [self._imgView setImage:zpImg];

}

-(void) updateUI:(NSDictionary * )dic{
    if(dic != NULL){
    }else
    {
        [self clearId2Info];
        self._info.text = @"请放卡...";
    }
}

-(void) readCardThread
{
    NSDictionary *dic ;
    
    okCount = 0;
    errorCount = 0;
    readCardCount = 0;

    while(!bStop){
        readCardCount ++;
    //    dic =  [bletool readCert];
        if(dic != NULL)
        {
            [self performSelectorOnMainThread:@selector(updateUI:)
                                   withObject:dic
                                waitUntilDone:YES];
          //  break;
        }else
        {
            [self performSelectorOnMainThread:@selector(updateUI:)
                                   withObject:dic
                                waitUntilDone:YES];
            
        }
        [NSThread sleepForTimeInterval:1.00];
    }
}
-(NSString *)GetSexFromCode:(NSString *) str
{
    NSString * sexStr = @"";
    NSInteger n =  [str intValue];
    switch (n) {
		case 1:
			return @"男";
		case 2:
			return @"女";
		default:
			return @"其他";
    }
    return sexStr;
}

-(NSString *)GetNationalFromCode:(NSString *) str
{
    NSString * nationalStr = @"";
    NSInteger n =  [str intValue];
    switch (n) {
		case 1:
			return @"汉族";
		case 2:
			return @"蒙古族";
		case 3:
			return @"回族";
		case 4:
			return @"藏族";
		case 5:
			return @"维吾尔族";
		case 6:
			return @"苗族";
		case 7:
			return @"彝族";
		case 8:
			return @"壮族";
		case 9:
			return @"布依族";
		case 10:
			return @"朝鲜族";
		case 11:
			return @"满族";
		case 12:
			return @"侗族";
		case 13:
			return @"瑶族";
		case 14:
			return @"白族";
		case 15:
			return @"土家族";
		case 16:
			return @"哈尼族";
		case 17:
			return @"哈萨克族";
		case 18:
			return @"傣族";
		case 19:
			return @"黎族";
		case 20:
			return @"傈僳族";
		case 21:
			return @"佤族";
		case 22:
			return @"畲族";
		case 23:
			return @"高山族";
		case 24:
			return @"拉祜族";
		case 25:
			return @"水族";
		case 26:
			return @"东乡族";
		case 27:
			return @"纳西族";
		case 28:
			return @"景颇族";
		case 29:
			return @"柯尔克孜族";
		case 30:
			return @"土族";
		case 31:
			return @"达斡尔族";
		case 32:
			return @"仫佬族";
		case 33:
			return @"羌族";
		case 34:
			return @"布朗族";
		case 35:
			return @"撒拉族";
		case 36:
			return @"毛难族";
		case 37:
			return @"仡佬族";
		case 38:
			return @"锡伯族";
		case 39:
			return @"阿昌族";
		case 40:
			return @"普米族";
		case 41:
			return @"塔吉克族";
		case 42:
			return @"怒族";
		case 43:
			return @"乌孜别克族";
		case 44:
			return @"俄罗斯族";
		case 45:
			return @"鄂温克族";
		case 46:
			return @"崩龙族";
		case 47:
			return @"保安族";
		case 48:
			return @"裕固族";
		case 49:
			return @"京族";
		case 50:
			return @"塔塔尔族";
		case 51:
			return @"独龙族";
		case 52:
			return @"鄂伦春族";
		case 53:
			return @"赫哲族";
		case 54:
			return @"门巴族";
		case 55:
			return @"珞巴族";
		case 56:
			return @"基诺族";
		default:
			return @"其他";
    }
    return nationalStr;
}

-(void) hexStringToBytes:(NSString*)hexString :(Byte*)bytes
{
    //NSString *hexString = @"3e435fab9c34891f"; //16进制字符串
    int j=0;
   // Byte bytes[2048];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        //NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    // NSLog(@"newData=%@",newData);
   // return bytes;
}

-(NSString*) bytesToHexString:(unsigned char *) bytes :(int) len
{
    NSString *hexStr = @"" ;
    for(int i=0;i < len; i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
-(void) saveDataToFile:(NSData*) bmpData
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath= [NSHomeDirectory()
                         stringByAppendingPathComponent:@"zp.bmp"];
    [bmpData writeToFile:filePath atomically:YES ];
}
-(void) clearId2Info
{
    self._xm.text = @"";
    self._xb.text = @"";
    self._mz.text = @"";
    self._nian.text = @"";
    self._yue.text = @"";
    self._ri.text = @"";
    self._zz.text = @"";
    self._sfzh.text = @"";//
    self._yxqx.text = @"";
    self._info.text = @"";

    self.lblDeviceid3.text = @"";//-->fzjg

    [self._imgView setImage:NULL];

}

-(void) playSound:(NSInteger)id
{
    NSString *path;
    if(id == 1)
        path = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    else if(id == 2)
        path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"wav"];
    else
        return;
    
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id); //注册声音到系统
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"in id2view cbcm didDiscoverPeripheral");
}
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"in id2view cbcm didConnectPeripheral");
    //self._info.text = @"蓝牙连接状态：已连接";
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"in id2view cbcm didDisconnectPeripheral");
  //  self._info.text = @"蓝牙连接状态：未连接";
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"in id2view cbcm didFailToConnectPeripheral");
   // self._info.text = @"蓝牙连接状态：建立连接失败";
}

- (IBAction)btnFhPress:(id)sender {
    bStop = true;
 /*   sdsesAppDelegate *appdelegate ;
    UIWindow *window;
    NSPredicate *predicate;
//    if(bletool!=NULL)
//        [bletool disconnect];
    appdelegate = [UIApplication sharedApplication].delegate;
    window = appdelegate.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];*/

    if ([[self navigationController] topViewController] == self)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


/*
 
 -(void) didOpretionFail:(NSDictionary *) dic
 {
 NSLog(@"In id2ViewController didOperationFail");
 if(dic == NULL){
 self._info.text = @"操作失败";
 return;
 }
 NSString * status = [dic objectForKey:@"getIdCardInfoStatus"];
 if ([status isEqualToString:@"-1"])
 {
 self._info.text = @"接受二代证数据失败";
 }else if ([status isEqualToString:@"-2"])
 {
 self._info.text = @"未放卡";
 }else if ([status isEqualToString:@"-3"])
 {
 self._info.text = @"寻卡失败";
 }else if ([status isEqualToString:@"-4"])
 {
 self._info.text = @"选卡失败";
 }else if ([status isEqualToString:@"-5"])
 {
 self._info.text = @"照片解码失败，授权文件不正确";
 }else if ([status isEqualToString:@"-6"])
 {
 self._info.text = @"未建立蓝牙连接";
 }
 }

 //recv data
 -(void) didOpretionSuc:(NSDictionary *) dic
 {
 NSLog(@"In id2ViewController didOpretionSuc");
 if(dic == NULL){
 // self._info.text = @"";
 return;
 }
 
 self._xm.text  = [dic objectForKey:@"name"];
 self._xb.text = [dic objectForKey:@"sex"];
 self._mz.text =[self GetNationalFromCode:[dic objectForKey:@"nation"]];
 
 NSRange range = NSMakeRange(0, 4);
 NSString * strCs =  [dic objectForKey:@"birth"];
 NSLog(@"strCs is:%@",strCs);
 self._nian.text = [strCs substringWithRange:(range)] ;
 range = NSMakeRange(4, 2);
 self._yue.text = [strCs substringWithRange:(range)] ;
 range = NSMakeRange(6, 2);
 self._ri.text = [strCs substringWithRange:(range)] ;
 
 self._zz.text = [dic objectForKey:@"address"];
 self._sfzh.text = [dic objectForKey:@"idCardNo"];
 NSLog(@"_yxqx is:%@",[dic objectForKey:@"validate"]);
 
 self._yxqx.text =[dic objectForKey:@"validate"];
 self.lblDeviceid3.text = [dic objectForKey:@"authority"];//fzjg
 //self._info.text = @"读卡成功";
 
 char bmpBuff[40000];
 NSData * base64BmpData  =  (NSData *)[dic objectForKey:@"image"];
 int bytes = base64_decode( [base64BmpData bytes], bmpBuff );
 
 NSData * bmpData = [[NSData alloc]initWithBytes:bmpBuff length:bytes];
 
 UIImage *zpImg=[UIImage imageWithData:bmpData];
 [self._imgView setImage:zpImg];
 
 }
 
 -(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
 {
 self._info.text = @"蓝牙连接状态：已连接";
 }
 -(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 {
 self._info.text = @"蓝牙连接状态：未连接";
 }
 -(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 {
 self._info.text = @"蓝牙连接状态：建立连接失败";
 }*/


@end
