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
	[self selector:aSelector times:times arguments:[CPArray array]];
}

- (void)selector:(SEL)aSelector times:(CPNumber)times arguments:(CPArray)arguments
{
	var selector = [[OJMoqSelector alloc] initWithName:aSelector withArguments:arguments];
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
	if (![self respondsToSelector:[anInvocation selector]])
		[CPException raise:"InvalidArgumentException" reason:"The selector " + [anInvocation selector] + " could not be found."];
	
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
    return [baseObject respondsToSelector:aSelector];
}

@end
