//
//  CarModel.m
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel


- (void)encodeWithCoder:(NSCoder *)encoder

{
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([CarModel class], &count);
    
    for (int i = 0; i<count; i++) {
        
        Ivar ivar = ivars[i];
        
        const char *name = ivar_getName(ivar);
        
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:key];
        
        [encoder encodeObject:value forKey:key];
        
    }
    
    free(ivars);
    
}



- (id)initWithCoder:(NSCoder *)decoder

{
    
    if (self = [super init]) {
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([CarModel class], &count);
        
        for (int i = 0; i<count; i++) {
            
            Ivar ivar = ivars[i];
            
            const char *name = ivar_getName(ivar);
            
            NSString *key = [NSString stringWithUTF8String:name];
            
            id value = [decoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
            
        }
        
        free(ivars);
        
    }
    
    return self;
    
}

@end
