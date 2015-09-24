//
//  CSVData.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_CSVData_h
#define YANSIS_CSVData_h

#import <Foundation/Foundation.h>

@interface CSVData : NSObject
-(id)init;
-(void)append:(NSString *)element;
-(void)insert:(int)index element:(NSString *)element;
-(void)remove:(int)index;
-(void)set:(int)index element:(NSString *)element;
-(void)clear;
-(NSString *)toString;
-(NSString *)enquote:(NSString *)element;
@end
#endif
