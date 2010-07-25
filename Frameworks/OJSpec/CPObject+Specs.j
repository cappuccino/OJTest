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
        if (currentPreFn) currentPreFn.call(currentContext);
        specFn.call(currentContext);
        if (currentPostFn) currentPostFn.call(currentContext);

        [OJSpecTest addSuccess:specDescription]
    }
    catch (obj)
    {
          if (obj.specFailure == SpecFailedException)
              [OJSpecTest addFailure:specDescription]
          else
              [OJSpecTest addFailure:specDescription fromException:obj]
    }
}

+ (void)should:(CPString)specDescription
{
    [OJSpecTest addResult:@"pending" forSpec:specDescription]
}

+ (void)setCurrentPre:(Function)preFn andPost:(Function)postFn
{
    currentPreFn = preFn;
    currentPostFn = postFn;
}

@end

@import "Matchers/OJSpecShouldBeInstanceOf.j"
@import "Matchers/OJSpecShouldBeNil.j"
@import "Matchers/OJSpecShouldBeSameAs.j"
@import "Matchers/OJSpecShouldEqual.j"

