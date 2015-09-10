//
//  Test15VC.m
//  CoreModel
//
//  Created by 冯成林 on 15/9/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "Test15VC.h"

@interface Test15VC ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgVs;


@end

@implementation Test15VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)saveAction:(id)sender {
    
    Person *p = [[Person alloc] init];
    p.hostID=7;
    p.name = @"大雄";
    p.dreams = @[
                 [self dataWithImageName:@"p1"],
                 [self dataWithImageName:@"p2"],
                 [self dataWithImageName:@"p3"],
                 ];
    
    [Person save:p resBlock:^(BOOL res) {
        [self show:res];
    }];
    
}

- (IBAction)readAction:(id)sender {
    
    [Person find:7 selectResultBlock:^(Person *p) {
        
        
        CoreSVPSuccess(@"读取成功")
        
        [p.dreams enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                ((UIImageView *)self.imgVs[idx]).image = [[UIImage alloc] initWithData:data];
            });
            
        }];
        
        
    }];
    
    
}


-(NSData *)dataWithImageName:(NSString *)name{
    return UIImagePNGRepresentation([UIImage imageNamed:name]);
}






@end
