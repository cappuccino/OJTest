@import <Foundation/CPObject.j>

function stub() {
	return [[OJMoqStub alloc] init];
}

@implementation OJMoqStub : CPObject

/* @ignore */
- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return YES;
}

/* @ignore */
- (void)forwardInvocation:(CPInvocation)anInvocation
{
	// We are going to do nothing.		
}

/*!
  @ignore
*/
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return YES;
}

@end
