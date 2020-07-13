//
//  id2ViewController.h
//  FinanceAllInOneDevice
//
//  Created by Yuexia Zhao on 14-5-21.
//  Copyright (c) 2014年 sdses. All rights reserved.
//

#import <UIKit/UIKit.h>


#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;


@interface id2ViewController : UIViewController{
    __weak IBOutlet UILabel *xmLable;
    __weak IBOutlet UILabel *xm;
    __weak IBOutlet UILabel *xbLabel;
    __weak IBOutlet UILabel *xb;
    __weak IBOutlet UILabel *mzLabel;
    __weak IBOutlet UILabel *mz;
    __weak IBOutlet UILabel *csLabel;
    __weak IBOutlet UILabel *cs;
    __weak IBOutlet UILabel *nian;
    __weak IBOutlet UILabel *nianLabel;
    __weak IBOutlet UILabel *yue;
    __weak IBOutlet UILabel *yueLabel;
    __weak IBOutlet UILabel *ri;
    __weak IBOutlet UILabel *riLabel;
    __weak IBOutlet UILabel *zzLabel;
    __weak IBOutlet UILabel *zz;
    __weak IBOutlet UILabel *sfzhLabel;
    __weak IBOutlet UILabel *sfzh;
    __weak IBOutlet UILabel *_lblDeviceid;
    __weak IBOutlet UILabel *yxqx;
    __weak IBOutlet UIImageView *id2Img;
    __weak IBOutlet UIButton *btnDk;
    __weak IBOutlet UIButton *btnFh;
    __weak IBOutlet UIButton *btnQsjs;
    __weak IBOutlet UIButton *btnGxmy;
    __weak IBOutlet UIButton *btnDklj;
    

}
@property (strong, nonatomic) CBPeripheral *gPeripheral;
//@property (strong, nonatomic) comminterface *commi;
@property (nonatomic, retain) NSMutableArray *peripheralArray;

//@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value

@property (weak, nonatomic) IBOutlet UILabel *_xmLabel;
@property (weak, nonatomic) IBOutlet UILabel *_xm;
@property (weak, nonatomic) IBOutlet UILabel *_xb;
@property (weak, nonatomic) IBOutlet UILabel *_mz;
@property (weak, nonatomic) IBOutlet UILabel *_nian;
@property (weak, nonatomic) IBOutlet UILabel *_yue;
@property (weak, nonatomic) IBOutlet UILabel *_ri;
@property (weak, nonatomic) IBOutlet UILabel *_zz;
@property (weak, nonatomic) IBOutlet UILabel *_sfzh;
@property (weak, nonatomic) IBOutlet UILabel *_yxqx;
//@property (strong, nonatomic) IBOutlet UITableView *btTableView;
@property (weak, nonatomic) IBOutlet UIImageView *_imgView;
@property (weak, nonatomic) IBOutlet UILabel *_info;
- (IBAction)btnDkPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceid3;
- (IBAction)btnFhPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *lblDeviceid2;
- (IBAction)id2ViewController:(id)sender;

-(NSString *)GetSexFromCode:(NSString *) str;
- (IBAction)btnDkljPress:(id)sender;
- (IBAction)btnQsjsPress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceid;
-(NSString *)GetNationalFromCode:(NSString *) str;
@end
