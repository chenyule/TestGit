//
//  ImageCell.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ImageCell.h"
#import "ImageItem.h"
#import <YYKit/YYKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ImageCell ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *parkIngImage;
@property (nonatomic, weak) ImageItem *imageItem ;


@end

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ItemModel *)itemModel{
    [super setItemModel:itemModel];
    
    ImageItem *imageItem = (ImageItem *)itemModel;
    
    if (imageItem.image) {
        
        self.parkIngImage.image = imageItem.image;
    }
    
    self.imageItem = imageItem;
    
}

- (void)touchEvent{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"请允许应用访问相机" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        [alertVc addAction:cancelAction];
        [alertVc addAction:sureAction];
        
        [self.viewController presentViewController:alertVc animated:YES completion:nil];
        
    }else{
        
        //判断是否可以打开相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;  //是否可编辑
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.viewController presentViewController:picker animated:YES completion:nil];
            
        }else{
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"错误" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertVc addAction:sureAction];
            
            [self.viewController presentViewController:alertVc animated:YES completion:nil];
            
        }
    }
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
       
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            self.imageItem.image = image;
            [self setItemModel:self.itemModel];
        }];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
