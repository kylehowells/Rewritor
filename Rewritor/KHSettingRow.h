//
//  KHSettingRow.h
//  Rewritor
//
//  Created by Kyle Howells on 28/08/2020.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface KHSettingRow : NSObject
+(instancetype)rowWithTitle:(NSString*)title;
-(instancetype)initWithTitle:(NSString*)title;

@property (nonatomic, copy) NSString *title;
@end

typedef void (^StateChanged)(BOOL);
//StateChanged blockName = ^returnType(BOOL) {...};

@interface KHSettingRowBool : KHSettingRow
+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state stateChange:(StateChanged)stateChanged;
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state stateChange:(StateChanged)stateChanged;

@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) StateChanged stateChanged;

-(void)setupSwitch:(UISwitch*)uiSwitch;
@end


