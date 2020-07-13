//
//  SerialGATT.h
//  Sdses
//
//  Created by Sdsess on 7/13/12.
//  Copyright (c) 2012 sdses.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//                                                                                                    //49535343 fe7d4ae5 8fa99faf d205e455    service
//#define  SERVICE_UUID   {0x49,0x53,0x53,0x43,0x20,0xfe,0x7d,0x4a,0xe5,0x20,0x8f,0xa9,0x9f,0xaf,0x20,0xd2,0x05,0xe4,0x55 }   //49535343 1e4d4bd9 ba6123c6 47249616 //read
//#define  CHAR_UUID      {0x49,0x53,0x53,0x43,0x20,0x88,0x41,0x43,0xf4,0x20,0xa8,0xd4,0xec,0xbe ,0x20,0x34,0x72,0x9b,0xb3} //49535343 884143f4 a8d4ecbe 34729bb3  //write

@protocol BTSmartSensorDelegate

@optional
- (void) peripheralFound:(CBPeripheral *)peripheral;
- (void) recvShakeHandCallback:(bool)bOk;
- (void) recvReadCardCallback:(NSDictionary*)NSDictionary;
- (void) recvConnectCallback;
- (void) recvDisconnectCallback;
@end

@interface SerialGATT : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
    NSMutableData *_sendData;
    NSMutableData *_recvData;
    uint32_t _totalBytesRead;
    long gRq,gBh;
    bool bCanSend ;
    
    bool bHaveCopyData ;
    NSData * gNsData;
    unsigned char sendBuff[1024];
    unsigned char recvBuff[2048];
    int maxRecvBuffLen ;
#define EAD_INPUT_BUFFER_SIZE 1024
    int gRecvLen;
    int gFunValue;//1 取随机数；  2 更新密钥 ； 3 读二代证
    NSString * gId2Param ;
    int tmpRecvLen;
    bool cmdExeOk ;
    
    unsigned char wzTxt[256];
}

@property (nonatomic, assign) id <BTSmartSensorDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;


#pragma mark - Methods for controlling the Sdses Sensor
- (void)id2ShakeHand;
- (void)id2ReadCard;

-(void) Init; //controller init
-(void) stopScan;

-(int) ScanDeviceList:(float)timeout;
-(void) scanTimer: (NSTimer *)timer;

-(void) connect: (CBPeripheral *)peripheral;
-(void) disconnect: (CBPeripheral *)peripheral;

-(void) write:(CBPeripheral *)peripheral data:(NSData *)data;
-(void) read:(CBPeripheral *)peripheral;
-(void) notify:(CBPeripheral *)peripheral on:(BOOL)on;


- (void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(UInt16) swap:(UInt16)s;

-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service;
-(void) writeValue:(Byte *)serviceUUID characteristicUUID:(Byte *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (Byte *)serviceUUID characteristicUUID:(Byte *)characteristicUUID p:(CBPeripheral *)p;
-(void) notification:(Byte *)serviceUUID characteristicUUID:(Byte *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on;
-(NSString*) bytesToHexString:(unsigned char *) bytes :(int) len;
- (void)_writeToBtDev:(NSInteger)sLen;
-(void) _readFromBtDev;
-(Byte*) hexStringToBytes:(NSString*)hexString;

-(NSInteger) recvTelcomCheck:(unsigned char *) _rData :(NSInteger) rLen;
-(void) sendCmdChinaTelecom:(int)CMD :(Byte*)data :(NSInteger)dataLen :(long)timeOut :(NSInteger) recvLen;
-(Boolean)  checkId2Data:(Byte*) data :(int) len;

struct cmdPara{
    NSInteger cmd ;
    NSInteger dataLen;
    unsigned char * sendData;
    long timeOut;
};
struct returnValue{
    NSInteger recvBuffLen;
    NSInteger returnFlag;
    unsigned char recvData[92300];
};

struct id2Txt{
 	unsigned char idname[30];
 	unsigned char idsex[2];
 	unsigned char idfolk[4];	    //36
    
 	//unsigned char idbirth[16];
 	unsigned char idyearBirth[8];
 	unsigned char idmonthBirth[4];
 	unsigned char iddayBirth[4];  //16
    
 	unsigned char idaddress[70];
 	unsigned char idnum[36];
 	unsigned char idissue[30];
 	unsigned char idstart[16];
 	unsigned char idend[16];
 	unsigned char deviceid[10];
 	unsigned char idother[26]; //100 + 104
};
struct id2Info{
    bool bHaveId2data ;//是否存在二代证数据
    struct id2Txt id2txt;
    unsigned char zpwlt[1024] ;
    bool bHaveFp;//是否存在指纹数据
    unsigned char fpdata[1024];
};
struct id2Data{
    bool bHaveId2data ;//是否存在二代证数据
    struct id2Txt id2txt;
    unsigned char zpwlt[1024] ;
    bool bHaveFp;//是否存在指纹数据
    unsigned char fpdata[1024];
};


@end
