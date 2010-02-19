@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "CPInvocation+Arguments.j"
@import "OJMoqAssert.j"

var DEPRECATED_METHOD = "%@ is deprecated and will be removed in a future release. Please use %@. Thanks!";

// Create a mock object based on a given object.
function moq(baseObject)
{
    if(!baseObject)
    {
        baseObject = nil;
    }
       
	return [OJMoq mockBaseObject:baseObject];
}

/*!
 * A mocking library for Cappuccino applications
 */
@implementation OJMoq : CPObject
{
	CPObject	_baseObject		@accessors(readonly);
	CPArray		selectors;
	CPArray		expectations;
}

/*!
    Creates an OJMoq object based on the base object. If the base object is nil, then a benign
    stub is created. If the base object is non-nil, it creates a spy mock that allows all of
    the messages to go through to the base object.
    
    \param aBaseObject A nil or non-nil base object that will be wrapped by OJMoq
    \returns An instance of OJMoq that wraps the given base object
 */
+ (id)mockBaseObject:(CPObject)aBaseObject
{
	return [[OJMoq alloc] initWithBaseObject:aBaseObject];
}

- (id)initWithBaseObject:(CPObject)aBaseObject
{
	if(self = [super init])
	{
		_baseObject = aBaseObject;
		expectations = [[CPArray alloc] init];
		selectors = [[CPArray alloc] init];
	}
	return self;
}

- (OJMoq)expectSelector:(SEL)selector times:(int)times
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"expectSelector:times:", @"selector:times:"]);
	return [self selector:selector times:times arguments:[CPArray array]];
}

- (OJMoq)expectSelector:(SEL)selector times:(int)times arguments:(CPArray)arguments
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"expectSelector:times:arguments:", @"selector:times:arguments:"]);
    [self selector:selector times:times arguments:[CPArray array]];
}

- (OJMoq)selector:(SEL)selector times:(CPNumber)times
{
    [self selector:selector times:times arguments:[CPArray array]];
}
 
- (OJMoq)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)arguments   
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
    if(theSelector)
    {
    	var expectationFunction = function(){[OJMoqAssert selector:theSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    }
    else
    {
    	var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:arguments];
    	var expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    	[selectors addObject:aSelector];
    }
	return self;
}

- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value
{
	[self selector:aSelector returns:value arguments:[CPArray array]];
}

- (OJMoq)selector:(SEL)aSelector withArguments:(CPArray)arguments returns:(CPObject)value
{
    CPLog.warn([[CPString alloc] initWithFormat:DEPRECATED_METHOD, @"selector:withArguments:returns:", @"selector:returns:arguments:"]);
    [self selector:aSelector returns:value arguments:arguments];
}

- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value arguments:(CPArray)arguments
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
	if(theSelector)
	{
		[theSelector setReturnValue:value];
	}
	else
	{
		var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments];
		[aNewSelector setReturnValue:value];
		[selectors addObject:aNewSelector];
	}
	
	return self;
}

- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback
{
    [self selector:aSelector callback:aCallback arguments:[CPArray array]];
}

- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback arguments:(CPArray)arguments
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments] in:selectors];
    
    if(theSelector)
    {
        [theSelector setCallback:aCallback];
    }
    else
    {
        var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:arguments];
        [aNewSelector setCallback:aCallback];
        [selectors addObject:aNewSelector];
    }
}

- (OJMoq)verifyThatAllExpectationsHaveBeenMet
{
	for(var i = 0; i < [expectations count]; i++)
	{
		expectations[i]();
	}
	
	return self;
}

// Ignore the following interface unless you know what you are doing! 
// These are here to intercept calls to the underlying object and 
// should be handled automatically.

- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
	return YES;
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{		
	__ojmoq_incrementNumberOfCalls(anInvocation, selectors);
	
	if(_baseObject !== nil)
	{
	    return [anInvocation invokeWithTarget:_baseObject];
	}
	else
	{
		__ojmoq_setReturnValue(anInvocation, selectors);
		__ojmoq_startCallback(anInvocation, selectors);
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector) 
            withArguments:[CPArray array]] in:selectors];
}

@end

function __ojmoq_incrementNumberOfCalls(anInvocation, selectors)
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector])
		withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[theSelector call];
	}
	else
	{
		var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
			withArguments:[anInvocation userArguments]];
		[aNewSelector call];
		[selectors addObject:aNewSelector];
	}
}

function __ojmoq_setReturnValue(anInvocation, selectors)
{
	var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
	    withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[anInvocation setReturnValue:[theSelector returnValue]];
	}
	else
	{
		[anInvocation setReturnValue:[[CPObject alloc] init]];
	}
}

function __ojmoq_startCallback(anInvocation, selectors)
{
    var theSelector = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
	    withArguments:[anInvocation userArguments]] in:selectors];
	if(theSelector)
	{
		[theSelector callback]([anInvocation userArguments]);
	}
}