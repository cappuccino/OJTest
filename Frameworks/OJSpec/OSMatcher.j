
@implementation OSMatcher : CPObject
{
    id _expected @accessors(property=expected);
    id _actual @accessors(property=actual);
}

- (id)initWithExpected:(id)expected
{
    if (self = [super init])
        _expected = expected;
    
    return self;
}

- (void)matches:(id)actual
{
    [self setActual:actual];

    return [self expected] == [self actual];
}

- (CPString)failureMessageForShould
{
    return @"expected " + [self expected] + " but was " + [self actual];
}

- (CPString)failureMessageForShouldNot
{
    return @"expected " + [self expected] + " but was " + [self actual];
}

@end
