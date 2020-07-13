#ifndef IDINTERFACE_INCLUDED 
#define IDINTERFACE_INCLUDED  

#include <string.h>
#ifdef __cplusplus
extern "C" {
#endif
    
    int StartFindIDCard();
    int SelectIDCard();
    int ReadBaseMsg(
                    unsigned char *pucCHMsg,
                    unsigned int  *puiCHMsgLen,
                    unsigned char *pucPHMsg,
                    unsigned int  *puiPHMsgLen,
                    unsigned char *pucFPMsg,
                    unsigned int  *puiFPMsgLen);
    int ReadNewAppMsg(
                      unsigned char * pucAppMsg,
                      unsigned int * puiAppMsgLen
                      );
    int ReadSamNum (
                    unsigned char * pucSamMsg,
                    unsigned int * puiSamMsgLen
                    );
    int id2GetBmpBuff(Byte* wltBuff  ,Byte *bmpBuff);
    int getIdCardInfo(
                      char *idTxt,
                      char *idPic,
                      char *idFp,
                      int timeout);
    
#ifdef __cplusplus
}
#endif
#endif

