
var results,
    tests,
    currentGroup;

@implementation Test :CPObject
{
}

+ (void)resetSpecs
{
  results = {};
  tests = {};
  [CPObject setCurrentPre:null andPost:null]
}

+ (CPArray)runSpecsOn:(CPString)fileName whenDone:(Function)resultHandler
{
  objj_import(fileName, true, function()
    {
      resultHandler(results);
    });
}

/**
 * Defines a group of specifications to be run. The group has a name, which may
 * be a string or an actual class, and may have functions to be run before all
 * spec functions, before each spec function, after each spec function, or after
 * all spec functions.
 *
 * If the group name is an actual class, it can be followed by a description of
 * the conditions being speced by following the for:argument with a when:
 * argument.
 *
 * @example
 *  [Test for:MyClass
 *        checking:function() {
 *          [MyClass should:"return 5 for reversing"
 *                   by:function() {
 *                     [[[[MyClass alloc] initialize] reverse] shouldEqual:5]
 *                   }];
 *          [MyClass should:"return 4 for reversing"
 *                   by:function() {
 *                     [[[[MyClass alloc] initialize] reverse] shouldEqual:4]
 *                   }];
 *        }]
 *
 * A more elaborate example with pre- and post-code:
 *
 * @example
 *  [Test for:MyClass when:"doing magic"
 *        beforeAll:function() { print("Starting!"); }
 *        beforeEach:function() {
 *          this.instance = [[MyClass alloc] init];
 *        }
 *        checking:function() {
 *          [MyClass should:"return 5 for reversing"
 *                   by:function() {
 *                     [[this.instance reverse] shouldEqual:5]
 *                   }];
 *          [MyClass should:"return 4 for reversing"
 *                   by:function() {
 *                     [[this.instance reverse] shouldEqual:4]
 *                   }];
 *        }
 *        afterEach:function() {
 *          [this.instance destroy]
 *        }
 *        afterAll:function() { print("Done!"); }]
 *
 * Note that the printing use of the beforeAll:and afterAll:parameters is not
 * a particularly good one, and indeed code that runs before or after all specs
 * is seldom a good idea.
 *
 * You can omit any of the before and after parameters to the method if you do
 * not want to use them, as long as the rest are kept in order.
 *
 * @param klassOrGroupName Can be a string (as in "creating users") or a class
 *   (as in MyClass).
 * @param groupDescription If provided, a string that extends the information
 *   provided in the for:part of the selector. Note that this is prefixed by
 *   `when' in the descriptions of the sepcifications.
 * @param allPreFn A function that runs before all specs. Assign to properties
 *   of this if you want to use a variable defined here in the specs.
 * @param preFn A function that runs before each spec. Assign to properties of this
 *   if you want to use a variable defined here in the specs.
 * @param groupFn A block of code to run that will run the tests for this group.
 * @param postFn A function that runs after each spec.
 * @param allPostFn A function that runs after all specs.
 */
+ (void)for:(id)klassOrGroupName when:(CPString)groupDescription
        beforeAll:(Function)allPreFn
        beforeEach:(Function)preFn
        checking:(Function)groupFn
        afterEach:(Function)postFn
        afterAll:(Function)allPostFn
{
  if (klassOrGroupName.isa)
    currentGroup = klassOrGroupName.isa.name;
  else
    currentGroup = klassOrGroupName;

  if (groupDescription)
    currentGroup += " when " + groupDescription;

  results[currentGroup] = [];

  var context = {};
  if (allPreFn) allPreFn.call(context);
  [self run:groupFn withPre:preFn andPost:postFn andContext:context]
  if (allPostFn) allPostFn.call(context);
}

+ (void)run:(Function)groupFn withPre:(Function)preFn andPost:(Function)postFn
        andContext:aContext
{
  [CPObject setCurrentPre:preFn andPost:postFn]

  groupFn.call(aContext);
}

+ addSuccess:(CPString)specDescription
{
  [self addResult:'success' forSpec:specDescription];
}

+ addFailure:(CPString)specDescription
{
  [self addResult:'failure' forSpec:specDescription];
}

+ addFailure:(CPString)specDescription fromException:(id)exception
{
  [self addResult:'exception' forSpec:specDescription
        withProperties:{ exception:exception }]
}

+ addResult:(CPString)status forSpec:(CPString)specDescription
{
  results[currentGroup].push({ spec:specDescription, status:status });
}

+ addResult:(CPString)status forSpec:(CPString)specDescription
  withProperties:(id)properties
{
  var obj = { spec:specDescription, status:status };
  for (var prop in properties)
    obj[prop] = properties[prop];

  results[currentGroup].push(obj);
}


+ (bool)methodSignatureForSelector:(SEL)aSelector
{
  var selector = CPStringFromSelector(aSelector);

  if (selector.match(/^for:(when:)?(beforeAll:)?(beforeEach:)?checking:(afterEach:)?(afterAll:)?$/))
    return true;
}

+ (void)forwardInvocation:(CPInvocation)anInvocation
{
  // Here we simulate optional parameters for the for:when:... selector.
  var selector = CPStringFromSelector([anInvocation selector]);
  var match =
    selector.match(/^(for:)(when:)?(beforeAll:)?(beforeEach:)?(checking:)(afterEach:)?(afterAll:)?$/);

  if (match)
  {
    match = match.slice(1); // drop full string match

    // Construct an invocation for the full method.
    var newArgs = []; // for passing to the full method
    var currentInvocationArg = 2; // out of the args passed to this invocation
    match.forEach(function(foundArg) {
      if (foundArg)
      {
        newArgs.push([anInvocation argumentAtIndex:currentInvocationArg]);
        currentInvocationArg++;
      }
      else
        newArgs.push(null);
    });

    var invocation = [CPInvocation invocationWithMethodSignature:null];
    [invocation setSelector:@selector(for:when:beforeAll:beforeEach:checking:afterEach:afterAll:)];
    newArgs.forEach(function(arg, index) {
      // Index is + 2 to leave space for self and _cmd.
      [invocation setArgument:arg atIndex:index + 2]
    });

    [invocation invokeWithTarget:self]
  }
  else
    [super forwardInvocation:anInvocation]
}

@end
