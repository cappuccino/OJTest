SpecFailedException = "specFailedException";
var currentPreFn, currentPostFn;

// in case capp is outdated
if (! CPSelectorFromString) {
    var CPSelectorFromString = function(sel) { return sel; };
}
if (! CPStringFromSelector) {
    var CPStringFromSelector = function(sel) { return sel; };
}

@implementation CPObject (Specs)

/**
 * Registers a given matcher class. By default, this converts the class name
 * into a selector with one parameter (e.g., OSShouldBeInstanceOf becomes
 * shouldBeInstanceOf:) that invokes the matches: method on a new instance of
 * the given class.
 *
 * If you need more than just one parameter, or if you need no parameters, use
 * registerMatcher:withSelector:.
 */
+ (void)registerMatcher:(Class)matcherClass
{
    var name = class_getName(matcherClass);
    var selName = name.substr(2, 1).toLowerCase() + name.substr(3) + ":";
    selName = selName.replace(/Matcher/, "");

    [self registerMatcher:matcherClass
             withSelector:CPSelectorFromString(selName)];
}

/**
 * Registers a given matcher class.
 */
+ (void)registerMatcher:(Class)matcherClass withSelector:(SEL)matcherSelector
{
    if (class_getInstanceMethod(matcherClass, matcherSelector))
    {
        [CPException raise:OSMethodExistsException
                    reason:"Registering matcher with selector " + CPStringFromSelector(matcherSelector) +
                           " but that selector is already registered on class " +
                           class_getName(matcherClass)]
    }

    var selString = CPStringFromSelector(matcherSelector),
        expectsMultipleArgs = (matcherSelector.split(":").length > 2);
    class_addMethods(CPObject,
        [new objj_method(matcherSelector,
                    function(self, _cmd, expected)
                    {
                        [[[matcherClass alloc] initWithExpected:expected] matches:self]
                    },
                    "")]);
}

/**
 *
 * @param specDescription A description of what this spec is testing. The
 *   description is automatically prefixed with ``should''.
 * @param by A block of code to run for this spec. It should make calls to the
 *   shouldEqual: or shouldNotEqual: methods.
 */
+ (void)should:(CPString)specDescription by:(Function)specFn
{
    var currentContext = {};
    for (var prop in this)
        currentContext[prop] = this[prop];

    try
    {
        [Mock resetMockTracking]

        if (currentPreFn) currentPreFn.call(currentContext);
        specFn.call(currentContext);
        if (currentPostFn) currentPostFn.call(currentContext);

        [Mock freezeMockTracking]

        [self ensureMockExpectationsWereMet]

        [Test addSuccess:specDescription]
    }
    catch (obj)
    {
          if (obj.specFailure == SpecFailedException)
              [Test addFailure:specDescription]
          else
              [Test addFailure:specDescription fromException:obj]
    }
}

+ (void)should:(CPString)specDescription
{
    [Test addResult:@"pending" forSpec:specDescription]
}

+ (void)setCurrentPre:(Function)preFn andPost:(Function)postFn
{
    currentPreFn = preFn;
    currentPostFn = postFn;
}

/**
 * Throws an exception if the expectations of any mocks set up in the beforeEach
 * block are not met.
 */
+ (void)ensureMockExpectationsWereMet
{
    [Mock ensureTrackedExpectationsWereMet]
}

@end

@import "Matchers/OSShouldBeInstanceOf.j"
@import "Matchers/OSShouldBeNil.j"
@import "Matchers/OSShouldBeSameAs.j"
@import "Matchers/OSShouldEqual.j"

