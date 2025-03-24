#import <Foundation/Foundation.h>
@interface GetFloatFontStructCollection : NSObject
- (int)lockTable:(int)version cache:(int)cache;
- (int)validateToken:(int)version cache:(int)cache;
@end