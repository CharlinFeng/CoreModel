//
//  ContactVC.m
//  CoreClass
//
//  Created by 冯成林 on 15/5/28.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ContactVC.h"
#import "ContactModel.h"

@interface ContactVC ()

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UILabel *label5;









@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据读取
    [self contactModelPrepare];
}


/** 数据读取 */
-(void)contactModelPrepare{
    
    NSDictionary *params = @{@"areaCode":@"028"};
    
    [ContactModel selectWithParams:params beginBlock:^(BOOL needHUD) {
        
        if(needHUD){
            NSLog(@"请求开始，需要HUD");
        }else{
            NSLog(@"不显示HUD");
        }
        
    }  successBlock:^(NSArray *models,BaseModelDataSource source) {
        
        ContactModel *contactModle = models.firstObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _label1.text = contactModle.name;
            _label2.text = contactModle.tel;
            _label3.text =contactModle.link;
            _label4.text=contactModle.addr;
            _label5.text = contactModle.areaCode;
            
            
        });
        
        
    } errorBlock:^(NSString *errorResult) {
        NSLog(@"请求失败，错误原因：%@",errorResult);
    }];
}





@end
