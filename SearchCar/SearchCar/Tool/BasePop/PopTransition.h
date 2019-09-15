//
//  PopTransition.h
//  HwariotGlobal
//
//  Created by a11 on 2018/7/24.
//  Copyright © 2018年 hrwl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , PopType) {
    
    PopTypePresent = 0,//底部
    PopTypeDismiss = 1,//底部消失
    
    PopTypeCenter = 2, //中心出现
    PopTypeDismissCenter//中心消失
};

@interface PopTransition : NSObject <UIViewControllerAnimatedTransitioning>


@property (nonatomic ,assign) PopType type;

@end
