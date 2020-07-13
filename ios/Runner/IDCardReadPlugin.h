//
//  IDCardReadPlugin.h
//  Runner
//
//  Created by 韩健春 on 2020/7/1.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "SerialGATT.h"
#import "comminterface.h"
#import "idinterface.h"

@class comminterface;
//@class CBPeripheral;

@interface IDCardReadPlugin : NSObject<FlutterPlugin>
{
    Boolean bHadSetController;
}

@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

@end
