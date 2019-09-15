//
//  CarModel.h
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarModel : NSObject<NSCoding>

/** 图片 */
@property (nonatomic, copy) NSString *imagePath;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 地点 */
@property (nonatomic, copy) NSString *address;
/** 录音文件 */
@property (nonatomic, copy) NSString *voicePath;
/** 语音备注时长 */
@property (nonatomic, assign) NSInteger timeLenth;





@end

NS_ASSUME_NONNULL_END
