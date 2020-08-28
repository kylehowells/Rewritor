//
//  KHSettingRow.h
//  Rewritor
//
//  Created by Kyle Howells on 28/08/2020.
//

#import <Foundation/Foundation.h>

@interface KHSettingRow : NSObject
+(instancetype)rowWithTitle:(NSString*)title;
-(instancetype)initWithTitle:(NSString*)title;

@property (nonatomic, copy) NSString *title;
@end

@interface KHSettingRowBool : KHSettingRow
+(instancetype)rowWithTitle:(NSString*)title state:(BOOL)state;
-(instancetype)initWithTitle:(NSString*)title state:(BOOL)state;

@property (nonatomic, assign) BOOL state;
@end


