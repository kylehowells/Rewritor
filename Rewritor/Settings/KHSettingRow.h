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



typedef void (^BoolStateChanged)(BOOL);
//StateChanged blockName = ^returnType(BOOL) {...};

@interface KHSettingRowBool : KHSettingRow
+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state stateChange:(BoolStateChanged)stateChanged;
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state stateChange:(BoolStateChanged)stateChanged;

@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) BoolStateChanged stateChanged;

-(void)setupSwitch:(UISwitch*)uiSwitch;
@end



typedef void (^NumberStateChanged)(NSInteger);
//StateChanged blockName = ^returnType(BOOL) {...};

@interface KHSettingRowNumber : KHSettingRow
+(instancetype)rowWithTitle:(NSString*)title state:(NSInteger)state stateChange:(NumberStateChanged)stateChanged;
-(instancetype)initWithTitle:(NSString*)title state:(NSInteger)state stateChange:(NumberStateChanged)stateChanged;

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NumberStateChanged stateChanged;

-(void)setupStepper:(UIStepper*)stepper cell:(UITableViewCell*)cell;
@end

