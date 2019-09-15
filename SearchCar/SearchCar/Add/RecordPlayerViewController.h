//
//  RecordPlayerViewController.h
//  SearchCar
//
//  Created by a11 on 2019/5/31.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "PopView.h"

typedef void (^RecodeFinished) (NSString *recodUrl,NSInteger time);

NS_ASSUME_NONNULL_BEGIN

@interface RecordPlayerViewController : PopView

@property (nonatomic, copy) NSString *voiceToPlayURL;

@property (nonatomic, assign) __block NSInteger time;

@property (nonatomic, copy) RecodeFinished recodeFinished;

@end

NS_ASSUME_NONNULL_END
