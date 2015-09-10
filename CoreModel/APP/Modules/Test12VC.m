//
//  Test12VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test12VC.h"

@interface Test12VC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation Test12VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveModelAction:(id)sender {
    
    Person *charlin = [[Person alloc] init];
    charlin.hostID = 1;
    charlin.name = @"冯成林";
    charlin.age = 28;
    charlin.photoData = UIImagePNGRepresentation([UIImage imageNamed:@"1"]);
    
    [Person save:charlin resBlock:^(BOOL res) {
        [self show:res];
    }];
}

- (IBAction)readModelAction:(id)sender {
    
    __weak typeof(self) weakSelf=self;
    
    [Person find:1 selectResultBlock:^(Person *selectResult) {
        
        [weakSelf show:selectResult != nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.imageV.image = [[UIImage alloc] initWithData:selectResult.photoData];
            
            weakSelf.label.text = [NSString stringWithFormat:@"%@%@",selectResult.name,@(selectResult.age)];
        });
        
    }];
}




@end
