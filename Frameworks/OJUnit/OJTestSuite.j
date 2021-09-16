@import <Foundation/Foundation.j>

var DEFAULT_REGEX = @".*";

@implementation OJTestSuite : CPObject
{
    BOOL            _shouldStopAtFirstFailureOrError @accessors(property=shouldStopAtFirstFailureOrError);

    CPArray         _testClassesRan;
    CPArray         _tests;
    CPString        _name;
    CPString        _selectorRegex;
}

- (id)init
{
    if (self = [super init])
    {
        _tests = [];
        _testClassesRan = [];
        _selectorRegex = DEFAULT_REGEX;
    }
    return self;
}

- (id)initWithName:(CPString)aName
{
    if (self = [self init])
    {
        [self setName:aName];
    }
    return self;
}

- (id)initWithClass:(Class)aClass
{
    return [self initWithClass:aClass selectorRegex:DEFAULT_REGEX];
}

- (id)initWithClass:(Class)aClass selectorRegex:(CPString)selectorRegex
{
    if (self = [self init])
    {
        var superClass = aClass,
            names = [];

        _selectorRegex = selectorRegex;

        while (superClass)
        {
            var methods = class_copyMethodList(superClass);

            for (var i = 0; i < methods.length; i++)
            {
                [self addTestMethod:method_getName(methods[i]) names:names class:aClass]
            }

            var autotestObject;

            if ([aClass respondsToSelector:@selector(autotest)])
                autotestObject = [aClass autotest];

            if (autotestObject && ![_testClassesRan containsObject:aClass])
            {
                [self createAccessorAutotests:class_copyIvarList([autotestObject class]) inClass:aClass forObject:autotestObject];
                [_testClassesRan addObject:aClass];
            }

            superClass = superClass.super_class;
        }

        if ([_tests count] == 0)
            CPLog.warn("No tests");
    }

    return self;
}

- (void)createAccessorAutotests:(CPArray)ivars inClass:(Class)aClass forObject:(id)autotestObject
{
    for (var i = 0; i < ivars.length; i++)
    {
        if (ivars[i].accessors)
        {
            var getAccessorName = ivars[i].accessors.get,
                ivarName = ivar_getName(ivars[i]),
                newMethodName = "testThat__" + ivars[i].accessors.get + "__WorksIn" + [autotestObject class];

            class_addMethod(aClass, newMethodName, function(){
                var target = [aClass autotest],
                    expected = @"";
                target[ivarName] = expected;
                var actual = objj_msgSend(target, getAccessorName);
                [OJAssert assert:expected equals:actual];
            });

            [self addTestMethod:newMethodName names:[] class:aClass];

            if (ivars[i].accessors.set)
            {
                var setAccessorName = ivars[i].accessors.set,
                    newMethodName = "testThat__" + ivars[i].accessors.set + "__WorksIn" + [autotestObject class];

                class_addMethod(aClass, newMethodName, function(){
                    var target = [aClass autotest],
                        expected = @"";
                    objj_msgSend(target, setAccessorName, expected);
                    var actual = objj_msgSend(target, getAccessorName);
                    [OJAssert assert:expected equals:actual];
                });

                [self addTestMethod:newMethodName names:[] class:aClass];
            }
        }
    }
}

- (id)initWithClass:(Class)aClass name:(CPString)aName
{
    [self initWithClass:aClass];
    [self setName:aName];
}

- (void)addTest:(OJTest)aTest
{
    [_tests addObject:aTest];
}

- (void)addTestSuite:(Class)aTestClass
{
    [self addTest:[[OJTestSuite alloc] initWithClass:aTestClass]];
}

- (void)addTestMethod:(SEL)selector names:(CPArray)names class:(Class)aClass
{
    var isTestMethod = [self isTestMethod:selector],
        testNameAlreadyDeclared = [names containsObject:selector];

    if (testNameAlreadyDeclared
        || !isTestMethod
        || ![self selectorMatchesTestPattern:selector])
    {
        if (isTestMethod && testNameAlreadyDeclared)
            CPLog.warn("It looks like you have declared the test `"+ selector +"` in the file "+ [aClass className] +".j several times !")

        return;
    }

    [names addObject:selector];
    [self addTest:[self createTestWithSelector:selector class:aClass]];
}

- (OJTest)createTestWithSelector:(SEL)selector class:(Class)aClass
{
    var initSelector = [self getTestConstructor:aClass],
        test;

    if (selector.indexOf(":") < 0)
    {
        test = [[aClass alloc] performSelector:initSelector];
        if ([test isKindOfClass:[OJTestCase class]])
            [test setSelector:selector];
    }
    else
    {
        test = [aClass performSelector:initSelector withObject:selector];
    }

    return test;
}

- (BOOL)isTestMethod:(SEL)selector
{
    return selector.substring(0,4) == "test" && selector.indexOf(":") == -1;
}

- (BOOL)selectorMatchesTestPattern:(SEL)selector
{
    return [selector.match(_selectorRegex) count];
}

- (SEL)getTestConstructor:(Class)aClass
{
    return "init";
}

- (async void)run:(OJTestResult)result
{
    for (var i = 0; i < _tests.length; i++)
    {
        if (i == 0)
            [_tests[i] setUpClass];

        if ([result shouldStop])
            break;

        await [_tests[i] run:result];

        if (i == (_tests.length - 1))
            [_tests[i] tearDownClass];

        if (_shouldStopAtFirstFailureOrError && ([result numberOfFailures] || [result numberOfErrors]))
            break;
    }
}

- (CPString)name
{
    return _name;
}

- (void)setName:(CPString)aName
{
    _name = aName;
}

- (int)countTestCases
{
    var count = 0;

    for (var i = 0; i < _tests.length; i++)
        [_tests[i] countTestCases];

    return count;
}

@end
