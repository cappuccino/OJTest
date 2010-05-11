@import "Frameworks/BlankSlate/BlankSlate.j"

var UnexpectedInvocationException = "UnexpectedInvocationException",
    UnmetExpectationException = "UnmetExpectationException";

var mockList = [],
    trackMocks = true;

@implementation Mock : BlankSlate
{
    CPString name;
    CPArray expectations;

    id baseObject;
    id baseClass;

    id dtable;
}

/**
 * Creates a new mock object to mock an object of class aClass. The object is
 * named aMockName (optional) and starts off with a set of stubs corresponding
 * to aStubList.
 *
 * @example
 *  var mock = [Mock a:CPObject as:"My object" withStubs:{ hash: 'fake' }];
 *  [mock hash] // => "fake"
 *  [mock copy] // => Unexpected invocation of copy ...
 *
 * @param aClass The class that this mock will be mocking.
 * @param aMockName A name to identify this mock. This parameter is optional
 *   and can be null.
 * @param aStubList A list of stubs to set up initially. This list should be a
 *   JSON-style object associating Obj-J selectors to their return values
 *   (potentially null).
 *
 * @note Unexpected invocations throw an exception.
 */
+ (Mock)a:(id)aClass as:(CPString)aMockName withStubs:(id)aStubList
{
    var mock = [[self alloc] initForClass:aClass];

    var className = aClass.isa.name;
    [mock setName:className + ": " + aMockName]
  
    if (aStubList)
    {
        for (var selector in aStubList)
            [mock stub:sel_getUid(selector) returning:aStubList[selector]]
    }

    return mock;
}


+ (void)resetMockTracking
{
    mockList = [];
    trackMocks = true;
}


+ (void)freezeMockTracking
{
    trackMocks = false;
}


+ (void)ensureTrackedExpectationsWereMet
{
    mockList.forEach(
        function(mock)
        {
            var unmetExpectation = [mock firstUnmetExpectation];
            if (unmetExpectation)
            {
                /*CPStringForSelector(unmetExpectation.selector)*/
                var selector = unmetExpectation.selector,
                    errorMessage = "Mock <" + [mock name] + "> was expecting ";

                if (unmetExpectation.args && unmetExpectation.args.length > 0)
                {
                    var message = "",
                        selectorParts = selector.split(":"),
                        args = unmetExpectation.args;

                    // Drop the last, blank item.
                    delete selectorParts[selectorParts.length - 1];
                    selectorParts.forEach(
                        function(paramName, i)
                        {
                            message += paramName + ":" + args[i] + " ";
                        });

                    errorMessage += message;
                }
                else
                    errorMessage += selector + " ";

                errorMessage += "but did not receive it.";

                [CPException raise:UnmetExpectationException
                            reason:errorMessage]
            }
        });
}


- (Mock)init
{
    if (trackMocks)
        mockList.push(self);

    expectations = [];

    return self;
}

- (Mock)initForClass:(id)aClass
{
    [self init]

    baseClass = aClass;
    dtable = baseClass.method_dtable;

    return self;
}

- (void)setBaseObject:(id)aBaseObject
{
    baseObject = aBaseObject;
    dtable = baseObject.isa.method_dtable;
}

- (void)setName:(CPString)aName
{
    name = aName;
}

- (CPString)name
{
    return name;
}

- (id)firstUnmetExpectation
{
    var expectation;
    for (var selector in expectations)
    {
        expectation = expectations[selector];
        if (! expectations[selector].selector)
            continue;
        else if (! expectation.called)
            return expectation;
    }

    return nil;
}

/**
 * Defines a message expectation. This mock should expect aSelector to be sent
 * to it with anArgList (if null, any arguments), and will then return
 * aReturnProducer. aReturnProducer may be a Function, see below.
 *
 * @param aSelector An Obj-J selector, created via @selector(sel:), that the
 *   mock object should expect to receive.
 * @param anArgList An array of parameters that will come with said selector.
 *   These are compared to the actual received parameters using ==. If this
 *   parameter is null, then any argument list is accepted.
 * @param aReturnProducer Either a literal value to return when this method
 *   is invoked, or a function that will be called to determine the return
 *   value. Functions will be passed all Obj-J parameters -- that is to say,
 *   the first parameter will be the Obj-J `self' parameter, and the rest will
 *   be the parameters passed to the selector.
 */
- expects:(SEL)aSelector with:(CPArray)anArgList returning:(id)aReturnProducer
{
    expectations[aSelector] = { selector: aSelector,
                                args: anArgList,
                                returnProducer: aReturnProducer };
}

- stub:(SEL)aSelector returning:(id)aReturnProducer
{
    expectations[aSelector] = { selector: aSelector,
                                returnProducer: aReturnProducer,
                                called: true };
}

- stub:(SEL)aSelector
{
    [self stub:aSelector returning:null]
}

- (bool)methodSignatureForSelector:(SEL)aSelector
{
    return dtable[aSelector];
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
    var selector = [anInvocation selector];
    var strSelector = CPStringFromSelector(selector);
    var numArgs = strSelector.split(':').length - 1;
    var expectation = expectations[selector];

    // Make sure we actually got a real expectation, not an instance method on
    // the array.
    if (! expectation.returnProducer)
        expectation = null ;

    var args = [];
    for (var i = 0; i < numArgs; ++i)
        args.push([anInvocation argumentAtIndex:i + 2]);

    var unexpected = "Unexpected invocation of " + strSelector +
        " with [" + args.join(', ') + "]" +
        " on mock object " + name;

    if (! expectation)
        [CPException raise:UnexpectedInvocationException reason:unexpected]
    else
    {
        var argsEqual = false;
    
        if (! expectation.args)
            argsEqual = true;
        else if (args.length == expectation.args.length)
            argsEqual = args.every(function(arg, i) { return arg == expectation.args[i]; });

        if (argsEqual)
        {
            var retVal;

            expectation.called = true;
            if (expectation.returnProducer instanceof Function)
            {
                args.unshift(self);
                retVal = expectation.returnProducer.apply(this, args);
            }
            else
                retVal = expectation.returnProducer;

            [anInvocation setReturnValue:retVal]
        }
        else
            [CPException raise:UnexpectedInvocationException reason:unexpected]
    }
}

@end

