//
//  AddViewController.h
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController

//确定添加
@property (nonatomic, copy) void (^SureAdd)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
