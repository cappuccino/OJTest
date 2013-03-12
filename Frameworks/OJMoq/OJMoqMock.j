@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "OJMoqAssert.j"
@import "CPInvocation+Arguments.j"

function mock(obj) {
    return [[OJMoqMock alloc] initWithBaseObject:obj];
}

@implementation OJMoqMock : CPObject
{
    id          baseObject          @accessors;
    CPArray     expectations        @accessors;
    CPArray     selectors           @accessors;
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

- (void)selector:(SEL)aSelector times:(CPNumber)times arguments:(CPArray)args
{
    var selector = [self findOrCreateSelector:aSelector withArguments:args];
    [expectations addObject:function(){[OJMoqAssert selector:selector hasBeenCalled:times];}];
}

- (void)selector:(SEL)aSelector returns:(id)returnValue
{
    [self selector:aSelector returns:returnValue arguments:[CPArray array]];
}

- (void)selector:(SEL)aSelector returns:(id)returnValue arguments:(CPArray)args
{
    [[self findOrCreateSelector:aSelector withArguments:args] setReturnValue:returnValue];
}

- (void)selector:(SEL)aSelector callback:(Function)callback
{
    [self selector:aSelector callback:callback arguments:[CPArray array]];
}

- (void)selector:(SEL)aSelector callback:(Function)callback arguments:(CPArray)args
{
    [[self findOrCreateSelector:aSelector withArguments:args] setCallback:callback];
}

- (void)verifyThatAllExpectationsHaveBeenMet
{
    expectations.forEach(function(expectation){expectation();});
}

- (OJMoqSelector)findOrCreateSelector:(SEL)aSelector withArguments:(CPArray)args
{
    var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(aSelector)
                                                                    withArguments:args]
                                        in:selectors ignoreWildcards:NO],
        selector = nil;

    if ([foundSelectors count] > 1)
        [CPException raise:CPInternalInconsistencyException reason:"Multiple selectors found with the exact same name and arguments"];
    else if ([foundSelectors count] === 1)
        selector = foundSelectors[0];
    else {
        selector = [[OJMoqSelector alloc] initWithName:aSelector withArguments:args];
        [selectors addObject:selector];
    }

    return selector;
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

    while (count--) {
        var selector = foundSelectors[count],
            returnValue = [selector returnValue],
            callback = [selector callback];

        [selector call];
        [anInvocation setReturnValue:returnValue];
        if(callback) callback([anInvocation userArguments]);
    }
}

/*!
  @ignore
*/
- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [baseObject respondsToSelector:aSelector];
}

@end
