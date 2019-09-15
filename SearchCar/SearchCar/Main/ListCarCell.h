//
//  ListCarCell.h
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListCarCell : UITableViewCell

@property (nonatomic, weak) CarModel  *carModel;

@end

NS_ASSUME_NONNULL_END
