
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "blecomm.h"

@interface comminterface : NSObject {
}
-(comminterface*) init:(id)myself;
-(Boolean) connectBt:(CBPeripheral * )bt;
-(Boolean)  disconnectBt;
-(Boolean)  getBtStatus;

int SDSS_rcvBuf(char *outbuf,int outLength,int timeOut);
int SDSS_writeBufComm(char cmd1,char cmd2,char *DataBuf,int DataLen,int timeOut);
int SDSS_readBufFromComm(char *outbuf,int timeOut);
int SDSS_writeAndReadBufFromComm(char cmd1,char cmd2,char *DataBuf,int DataLen,char *outbuf,int timeOut);
int writeBufAndReadGA467(char cmd1,char cmd2,char *outbuf,int timeOut);


/*
int rcvBuf(char *outbuf,int outLength,int timeOut);
int rcvBufFromHeadByteBuf(char *outbuf,int outLength,char *HeadByteBuf,int headByteBufLen,int timeOut);
int SendBuf( Byte*buf,int bufLen);
int RcvBuf(Byte*buf,int nNumberOfBytesToRead,int * nNumberOfBytesRead);
 int SDSS_rcvBufFromHeadByteBuf(char *outbuf,int outLength,char *HeadByteBuf,int headByteBufLen,int timeOut);
*/

@end