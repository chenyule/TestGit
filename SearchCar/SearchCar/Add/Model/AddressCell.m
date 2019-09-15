//
//  AddressCell.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "AddressCell.h"
#import "AddressModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LocalManager.h"

@interface AddressCell ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textview;

@property (nonatomic, weak) IBOutlet UILabel *placherLabel;

@property (nonatomic, weak) AddressModel* addressModel;

@end

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observer) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ItemModel *)itemModel{
    [super setItemModel:itemModel];
    
    AddressModel *addressModel = (AddressModel *)itemModel;
    
    self.textview.text = addressModel.address;
    
    self.addressModel = addressModel;
    
    self.placherLabel.hidden = (self.textview.text.length > 0);
}


- (void)observer{
    
    self.placherLabel.hidden = (self.textview.text.length > 0);
}


- (IBAction)relocation:(id)sender{
    
    __weak typeof(self) wealSelf = self;
    [[LocalManager shareInstace] startLocalWithResult:^(NSString * _Nonnull address) {
        
        wealSelf.addressModel.address = address;
        
        [wealSelf setItemModel:wealSelf.addressModel];
        
    } faild:^(NSInteger code, NSString * _Nonnull message) {
        
        [self showHudWithText:message];
    }];
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)showHudWithText:(NSString *)string{
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.cornerRadius = 4.0f;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    hud.margin = 18.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


@end
