//
//  EJConfig.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_EJConfig_h
#define YANSIS_EJConfig_h

#import<Foundation/Foundation.h>
#import"GradeTable.h"

@interface EJConfig : NSObject
@property(nonatomic) NSString *basedir;
@property(nonatomic) NSString *sen_dir;
@property(nonatomic) NSString *sen_conf;
@property(nonatomic) NSString *morph_dir;
@property(nonatomic) int n_grade;
@property(nonatomic) NSMutableArray *grade;
@property(nonatomic) NSString *easyword;

-(id)initWithDir:(NSString *)base_dir n:(int)n;
-(void)set_grade:(NSString *)file n:(int)n;
@end
#endif
