@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "OJMoqAssert.j"
@import "CPInvocation+Arguments.j"

function mock(obj) {
	return [[OJMoqMock alloc] initWithBaseObject:obj];
}

@implementation OJMoqMock : CPObject
{
	id			baseObject			@accessors;
	CPArray		expectations		@accessors;
	CPArray		selectors			@accessors;
}

- (id)initWithBaseObject:(id)aBaseObject
{
	self = [super init];
	if(self)
	{
		baseObject = aBaseObject;
		expectations = [CPArray array];
		selectors = [CPArray array];
	}
	return self;
}

- (void)selector:(SEL)aSelector times:(CPNumber)times
{
	var selector = [[OJMoqSelector alloc] initWithName:aSelector withArguments:[CPArray array]];
	[expectations addObject:function(){[OJMoqAssert selector:selector hasBeenCalled:times];}];
	[selectors addObject:selector];
}

- (void)verifyThatAllExpectationsHaveBeenMet
{
	expectations.forEach(function(expectation){expectation();});
}

/* @ignore */
- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return YES;
}

/* @ignore */
- (void)forwardInvocation:(CPInvocation)anInvocation
{
	var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
																	withArguments:[anInvocation userArguments]] 
	                                    in:selectors ignoreWildcards:NO],
    	count = [foundSelectors count];

	while (count--)
    	[foundSelectors[count] call];
}

/*!
  @ignore
*/
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return YES;
}

@end
