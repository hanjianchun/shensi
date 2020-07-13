//
//  imageLib.h
//  imageLib
//
//  Created by xiangby on 14-5-17.
//  Copyright (c) 2014年 HB. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef __cplusplus
//extern "C" {
//#endif
//    
//#ifdef __cplusplus
//}
//#endif


@interface imageLib : NSObject

int Unpack(char* Infile, char* Outfile);
@end
