@import <Foundation/Foundation.j>

@implementation OJTestSuite : CPObject
{
    CPArray     _tests;
    CPString    _name;
}

- (id)init
{
    if (self = [super init])
    {
        _tests = [];
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
    if (self = [self init])
    {
        var superClass = aClass,
            names = [];
        while (superClass)
        {
            var methods = class_copyMethodList(superClass);
            for (var i = 0; i < methods.length; i++)
            {
                [self addTestMethod:methods[i].name names:names class:aClass]
            }
        
            superClass = superClass.super_class;
        }
    
        if ([_tests count] == 0)
            CPLog.warn("No tests");
    }
        
    return self;
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
    if ([names containsObject:selector] || ![self isTestMethod:selector])
        return;
        
    [names addObject:selector];
    [self addTest:[self createTestWithSelector:selector class:aClass]];
}

- (OJTest)createTestWithSelector:(SEL)selector class:(Class)aClass
{
    var initSelector = [self getTestConstructor:aClass];
    
    var test;
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

- (void)isTestMethod:(SEL)selector
{
    return selector.substring(0,4) == "test" && selector.indexOf(":") == -1;
}

- (SEL)getTestConstructor:(Class)aClass
{
    return "init";
}

- (void)run:(OJTestResult)result
{
    for (var i = 0; i < _tests.length; i++)
    {
        if ([result shouldStop])
            break;
            
        [_tests[i] run:result];
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