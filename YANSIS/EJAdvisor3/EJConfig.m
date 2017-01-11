//
//  EJConfig.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EJConfig.h"

@implementation EJConfig{
    int current_grade;
}

-(id)initWithDir:(NSString *)base_dir n:(int)n{
    if(self = [super init]){
        self.basedir = base_dir;
        self.n_grade = n;
        self.grade = [[NSMutableArray alloc] initWithCapacity:n];
        current_grade = 0;
    }
    
    return self;
}

-(void)set_grade:(NSString *)file n:(int)n{
    NSString *filenameStr = [NSString stringWithFormat:@"%@/%@", self.morph_dir,file];
    
    self.grade[current_grade++] = [[GradeTable alloc] initWithString:filenameStr grade:n];
}

@end
