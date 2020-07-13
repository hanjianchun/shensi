//
//  IDCardReadPlugin.m
//  Runner
//
//  Created by 韩健春 on 2020/7/1.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import "id2ViewController.h"
#import "IDCardReadPlugin.h"


static NSString *const CHANNEL_NAME = @"idcard_plugin";

@interface IDCardReadPlugin()
@property(nonatomic,retain) FlutterMethodChannel *channel;
@property(nonatomic,retain) FlutterResult results;
@end

@implementation IDCardReadPlugin{
    FlutterResult _result;
//    comminterface *commi;
}
@synthesize sensor;
comminterface *commi;
@synthesize peripheralViewControllerArray;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME binaryMessenger:[registrar messenger]];
    
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    IDCardReadPlugin * instance = [[IDCardReadPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    
    commi = [[comminterface alloc] init:self];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    self.results = result;
    if([@"init" isEqualToString:call.method]){
    
        sensor = [[SerialGATT alloc] init];
         [sensor Init];
         sensor.delegate = self;
         peripheralViewControllerArray = [[NSMutableArray alloc] init];
        
        [self showMsg:@"106"];
        [self actionChoise:106];
    } else if([@"connect" isEqualToString:call.method]){
        [self showMsg:@"105"];
        [self actionChoise:105];
    } else if([@"read" isEqualToString:call.method]){
        [self showMsg:@"101"];
        [self actionChoise:101];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) showMsg:(NSString *) msg
{
    NSLog(@"log---%@",msg);
}

- (void) actionChoise:(int)code{
    bool bBtConnected;
//    id2ViewController *id2Vc ;
    switch (code) {
        case 101:
            if(!bHadSetController){
//                NSURL *filePath = [[NSBundle mainBundle] URLForResource:   @"tap" withExtension: @"aif"];
              //  AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
              //  _lbeInfo.text = @"请先建立蓝牙连接";
            }else{
                //id2Vc =[[id2ViewController alloc] initWithNibName:@"id2ViewController" bundle:nil];
                //id2Vc.gPeripheral = sensor.activePeripheral;
//                [[self navigationController] pushViewController:id2Vc animated:YES];
            }
            
            unsigned char idTxt[256];
            unsigned char idPic[1024];
            unsigned char idFp[1024];
            int nRet = getIdCardInfo((char *)&idTxt, (char *)&idPic, (char *)&idFp, 3);
            
            if(nRet != 0){
                [self showMsg:[NSString stringWithFormat:@"read---%ld",nRet]];
            }else{
                [self showMsg:@"read success"];
            }
            
            break;
        case 105:
            
            //NSString *str = [NSString stringWithFormat:@"read---%@",self.peripheral.name];
            [self showMsg:sensor.activePeripheral.name];
            
            [NSThread sleepForTimeInterval:3.0];
            
            bBtConnected = [commi connectBt:sensor.activePeripheral];
            if(bBtConnected){
                [self showMsg:@"建立连接成功"];
              //  _lbeInfo.text = @"建立连接成功,请演示各模块功能";
              //  [self playSound:1];
                bHadSetController = true;
                self.results([NSNumber numberWithBool:true]);
            }else{
                
                bool isConnected = [commi getBtStatus];
                if(isConnected) [self showMsg:@"connected"];
                else [self showMsg:@"not connected"];
                
                [self showMsg:@"建立连接失败"];
              //  _lbeInfo.text = @"建立连接失败";
              //  [self playSound:2];
                self.results([NSNumber numberWithBool:false]);
            }
            break;
        case 106:
            if ([sensor activePeripheral]) {
                if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
                    [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
                    sensor.activePeripheral = nil;
                }
            }

            if ([sensor peripherals]) {
                sensor.peripherals = nil;
                [peripheralViewControllerArray removeAllObjects];
//                [btTableView reloadData];
            }

            sensor.delegate = self;
//            [Scan setTitle:@"扫描中..." forState:UIControlStateNormal];
            [self showMsg:@"扫描中..."];
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];

//            [sensor ScanDeviceList :5];
            
//            int a = [sensor ScanDeviceList :5];
//            NSString *str = [NSString stringWithFormat:@"read---%ld",a];
//            [self showMsg:str];
            
            break;
    }
}
- (void) scanTimer
{
    NSInteger a = [sensor ScanDeviceList :5];
    NSString *str = [NSString stringWithFormat:@"read---%ld",a];
    [self showMsg:str];
}

//scan device callback method
- (void) peripheralFound:(CBPeripheral *)peripheral
{
    [self showMsg:@"In peripheralFound..."];
//    NSString *str = [NSString stringWithFormat:@"read---%@",peripheral.name];
//    [self showMsg:str];
    
    if([peripheral.name hasPrefix:@"SS-"] || [peripheral.name hasPrefix:@"SYN"] || [peripheral.name hasPrefix:@"PSB"]){
        
        [sensor stopScan];
        
        id2ViewController *controller = [[id2ViewController alloc] init];
        controller.gPeripheral = peripheral;
        [commi connectBt:controller.gPeripheral];
        
//        [self.navigationController pushViewController:controller animated:YES];
        
        sensor.activePeripheral = peripheral;
//        bool bBtConnected = [commi connectBt:sensor.activePeripheral];
//        if(bBtConnected)[self showMsg:@"success-----"];
//        else [self showMsg:@"error------"];
        self.results([NSNumber numberWithBool:true]);
    }
}

@end
