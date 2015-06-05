#import "BaseModel.h"



@protocol BaseCellProtocol <NSObject>

@optional

/** 数据填充 */
-(void)dataFill:(BaseModel *)baseModel;

@end
