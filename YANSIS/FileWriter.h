//
//  FileWriter.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_FileWriter_h
#define YANSIS_FileWriter_h

#import<Foundation/Foundation.h>
#import "FileWriter.h"

@interface FileWriter : NSObject
-(id)initWithString:(NSString *)filename;
-(void)writeShort:(short)value;
-(void)writeInt:(int)value;
@end

#endif
