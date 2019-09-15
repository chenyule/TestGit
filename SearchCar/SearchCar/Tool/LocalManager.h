//
//  LocalManager.h
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^LocalSuccess)(NSString *address);

typedef void(^LocalFaild)(NSInteger code,NSString *message);

@interface LocalManager : NSObject

+ (instancetype )shareInstace;

- (void)startLocalWithResult:(LocalSuccess )success faild:(LocalFaild )faild;

@end

NS_ASSUME_NONNULL_END
