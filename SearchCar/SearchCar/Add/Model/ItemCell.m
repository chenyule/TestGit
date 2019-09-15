//
//  ItemCell.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ItemCell.h"


@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutManager:)]){
        
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ItemModel *)itemModel{
    _itemModel = itemModel;
    
    
}

- (void)touchEvent{
    
    
}

@end
