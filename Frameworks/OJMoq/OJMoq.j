@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "CPInvocation+Arguments.j"
@import "OJMoqAssert.j"

// New stuff
@import "OJMoqMock.j"
@import "OJMoqSpy.j"
@import "OJMoqStub.j"

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
    CPArray	selectors;
    CPArray	expectations;
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


/*!
   Creates an OJMoq object based on the base object. If the base object is nil, then a benign
   stub is created. If the base object is non-nil, it creates a spy mock that allows all of
   the messages to go through to the base object.
   
   \param aBaseObject A nil or non-nil base object that will be wrapped by OJMoq
   \returns An instance of OJMoq that wraps the given base object
 */
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

/*!
   Expect that selector is called times on the base object. The selector here will match all
     arguments.
   @param selector The selector which should be called
   @param times The number of times that selector should be called
 */
- (OJMoq)selector:(SEL)selector times:(CPNumber)times
{
    [self selector:selector times:times arguments:[CPArray array]];
}
 
/*!
   Expect that selector is called times with arguments on the base object. The selector here
     will match the arguments that you pass it. If an empty array is passed then the selector
     will match all arguments!

     @param selector The selector which should be called
     @param times The number of times that selector should be called
     @param arguments Arguments for the selector. If an empty array of arguments is passed in, 
          then the selector matches all arguments.
 */
- (OJMoq)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)args   
{
    theSelector = __ojmoq_findUniqueSelector(selector, args, selectors);
    if(theSelector)
    {
    	var expectationFunction = function(){[OJMoqAssert selector:theSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    }
    else
    {
    	var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:args];
    	var expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times];};
        [expectations addObject:expectationFunction];
    	[selectors addObject:aSelector];
    }
    return self;
}

/*!
   Ensure that selector returns value when selector is called. Selector will match all arguments.
   @param aSelector The selector on the base object that will be called
   @param value The value that the selector should return
 */
- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value
{
    [self selector:aSelector returns:value arguments:[CPArray array]];
}

/*!
   Ensure that the selector, when called with the specified arguments, will return the given
     value. If you pass an empty array of arguments, then the selector will match all calls.
     
     @param aSelector The selector on the base object that will be called
     @param arguments The arguments that must be passed to selector for this to work
     @param value The value that the selector should return
 */
- (OJMoq)selector:(SEL)aSelector returns:(CPObject)value arguments:(CPArray)args
{
    var theSelector = __ojmoq_findUniqueSelector(aSelector, args, selectors);
    if(theSelector)
    {
        [theSelector setReturnValue:value];
    }
    else
    {
        var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:args];
        [aNewSelector setReturnValue:value];
        [selectors addObject:aNewSelector];
    }
    return self;
}

/*!
   Provides a callback with the parameters that were passed in to the specified selector
   
   @param aSelector The selector on the base object that will be called
   @param aCallback A single-argument function that is passed the array of arguments
 */
- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback
{
    [self selector:aSelector callback:aCallback arguments:[CPArray array]];
}

/*!
   Provides a callback with the parameters that were passed in to the specified selector and
      match the given arguments

      @param aSelector The selector on the base object that will be called
      @param aCallback A single-argument function that is passed the array of arguments
      @param arguments The arguments that the selector must match
 */
- (OJMoq)selector:(SEL)aSelector callback:(Function)aCallback arguments:(CPArray)args
{
    var theSelector = __ojmoq_findUniqueSelector(aSelector, args, selectors);
    
    if(theSelector)
    {
        [theSelector setCallback:aCallback];
    }
    else
    {
        var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName(aSelector) withArguments:args];
        [aNewSelector setCallback:aCallback];
        [selectors addObject:aNewSelector];
    }
}

/*!
   Verifies all of the expectations that were set on the OJMoq and fails the test if any of
   the expectations fail.
 */
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

/*!
  @ignore
*/
- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return YES;
}

/* @ignore */
- (void)forwardInvocation:(CPInvocation)anInvocation
{		
    var theSelector = __ojmoq_findSelectorFromInvocation(anInvocation, selectors);
    __ojmoq_incrementNumberOfCalls(anInvocation, selectors);
	
	// We forward to the baseObject when:
	// 1. A baseObject exists and
	// 2. No one has added this selector to our selector list or it is a selector the baseobject responds to and no one has tried 
	//    to override the baseObject's implementation
    if (_baseObject !== nil &&
        (!theSelector || ([_baseObject respondsToSelector:CPSelectorFromString([theSelector name])] 
        && ([theSelector returnValue] === undefined && [theSelector callback] === undefined))))
    {
        return [anInvocation invokeWithTarget:_baseObject];
    }
    else
    {
        __ojmoq_setReturnValue(anInvocation, selectors);
        __ojmoq_startCallback(anInvocation, selectors);
    }
}

/*!
  @ignore
*/
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [__ojmoq_findSelectors(aSelector, [CPArray array], selectors, NO) count] > 0;
}

@end

function __ojmoq_findUniqueSelector(selector, selectorArguments, selectors)
{
    var foundSelectors = __ojmoq_findSelectors(selector, selectorArguments, selectors, YES);
    if ([foundSelectors count] > 1)
        [CPException raise:CPInternalInconsistencyException reason:"Multiple selectors found with the exact same name and arguments"];
    else if ([foundSelectors count] === 1)
        return foundSelectors[0];
    else
        return nil;
}

function __ojmoq_findSelectors(selector, selectorArguments, selectors, shouldIgnoreWildcards)
{
    return [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(selector)
                                                     withArguments:selectorArguments] in:selectors ignoreWildcards:shouldIgnoreWildcards];
}

function __ojmoq_findSelectorFromInvocation(anInvocation, selectors)
{
    var foundSelectors = __ojmoq_findSelectors([anInvocation selector], [anInvocation userArguments], selectors, NO);
    // We don't find the unique selector first, since if you did [mock selector:@selector(aSelector:) returns:5],
    // doing [mock aSelector:5] should still return the selector you set up
    if ([foundSelectors count] === 1)
        return foundSelectors[0];
    else if ([foundSelectors count] === 0)
        return nil;
    // More than one selector found - for example, if you did [mock selector:@selector(aSelector:) returns:5] and 
    // [mock selector:@selector(aSelector:) returns:6 arguments:[5]] and then call [mock aSelector:5];, should only
    // call the selector that was set up with args.
    else
        return __ojmoq_findUniqueSelector([anInvocation selector], [anInvocation userArguments], selectors);
}

function __ojmoq_incrementNumberOfCalls(anInvocation, selectors)
{
    var foundSelectors = __ojmoq_findSelectors([anInvocation selector], [anInvocation userArguments], selectors, NO),
        count = [foundSelectors count];
	
    while (count--)
        [foundSelectors[count] call];

    // Make sure we didn't just find the wildcard selector and increment only that.  
    // Taking this out for now - it causes this bug: https://github.com/280north/OJTest/issues#issue/3
//     var uniqueSelector = __ojmoq_findUniqueSelector([anInvocation selector], [anInvocation userArguments], selectors);
//     if (!uniqueSelector)
//     {
//         var aNewSelector = [[OJMoqSelector alloc] initWithName:sel_getName([anInvocation selector]) 
//                                                  withArguments:[anInvocation userArguments]];
//         [aNewSelector call];
//         [selectors addObject:aNewSelector];
//     }
}

function __ojmoq_setReturnValue(anInvocation, selectors)
{
    var theSelector = __ojmoq_findSelectorFromInvocation(anInvocation, selectors);
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
    var theSelector = __ojmoq_findSelectorFromInvocation(anInvocation, selectors);
    if(theSelector && [theSelector callback] !== undefined)
    {
        [theSelector callback]([anInvocation userArguments]);
    }
}

