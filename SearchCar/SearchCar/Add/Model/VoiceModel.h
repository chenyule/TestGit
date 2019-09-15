//
//  VoiceModel.h
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceModel : ItemModel

/** 录音文件缓存路径 */
@property (nonatomic, copy) NSString *voicePathTemp;
/** 录音时长 */
@property (nonatomic, assign) NSInteger time;
/** 录音文件本地化路径 */
@property (nonatomic, copy,readonly) NSString *localPath;

@end

NS_ASSUME_NONNULL_END
