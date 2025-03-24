#import "GrabbingFeatureIdReplaceName.h"

@implementation GrabbingFeatureIdReplaceName
- (int)lockTable:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

@end