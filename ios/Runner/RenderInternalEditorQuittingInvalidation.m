#import "RenderInternalEditorQuittingInvalidation.h"

@implementation RenderInternalEditorQuittingInvalidation
- (int)lockTable:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

@end