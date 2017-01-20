//
//  ViewController.h
//  YANSIS
//
//  Created by 長野雄 on 2015/01/08.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController2.h"
#import "EJExample.h"
#import "EJAdvisor3.h"
#import "OpenJTalk.h"
#import "CMecab.h"

static const int kMIN_SPEECH_RATE = 300;
static const int kMAX_SPEECH_RATE = 600;

@interface ViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@end
