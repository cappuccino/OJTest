@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "OJMoqAssert.j"

spy = function(obj) {
	return [OJMoqSpy spyOnBaseObject:obj];
}

@implementation OJMoqSpy : CPObject
{
	CPObject		_baseObject		@accessors(property=baseObject);
	CPArray			expectations;
	CPArray			selectors;
}

+ (OJMoqSpy)spyOnBaseObject:(id)baseObject
{
	return [[OJMoqSpy alloc] initWithBaseObject:baseObject];
}

- (id)init
{
	return [[OJMoqSpy alloc] initWithBaseObject:nil];
}

- (id)initWithBaseObject:(CPObject)baseObject
{
	if(self = [super init]) {
		_baseObject = baseObject;
		
		expectations = [];
		selectors = [];
	}
	return self;
}

- (void)selector:(SEL)selector times:(CPNumber)times
{
	[self selector:selector times:times arguments:[]];
}

- (void)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)arguments
{
	[self replaceMethod:selector];

   	var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:arguments];
   	var expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times];};
    [expectations addObject:expectationFunction];
   	[selectors addObject:aSelector];
}

- (void)verifyThatAllExpectationsHaveBeenMet
{
	expectations.forEach(function(expectation){
		require("system").print();
		expectation();
	});
}

- (void)incrementNumberOfCallsForMethod:(SEL)selector arguments:(CPArray)userArguments
{
	var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(selector)
                                        withArguments:userArguments] in:selectors ignoreWildcards:NO],
    	count = [foundSelectors count];

	while (count--)
    	[foundSelectors[count] call];
}

- (void)replaceMethod:(SEL)selector
{
	var aFunction = class_getMethodImplementation([_baseObject class], selector);
	class_replaceMethod([_baseObject class],
		selector,
		function(object, _cmd) {
			var userArguments = Array.prototype.slice.call(arguments).splice(2, arguments.length);
			[self incrementNumberOfCallsForMethod:selector arguments:userArguments];
			aFunction.apply(this, arguments);
		});
}

@end