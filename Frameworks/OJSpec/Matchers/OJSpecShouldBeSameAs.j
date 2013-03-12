@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeSameAs : OJSpecMatcher

- (BOOL)matches:(id)actual
{
    [self setActual:actual];
    [OJAssert assertTrue:([self expected] === [self actual])];
}

- (BOOL)doesNotMatch:(id)actual
{
    [self setActual:actual];
    [OJAssert assertTrue:([self expected] !== [self actual])];
}

@end

/**
 * Checks if two objects are the same (has the same identity).
 */
@implementation CPObject (ShouldBeSameAsMatcher)

- (void)shouldBeSameAs:(id)expected
{
    [[[OJSpecShouldBeSameAs alloc] initWithExpected:expected] matches:self];
}

- (void)shouldNotBeSameAs:(id)expected
{
    [[[OJSpecShouldBeSameAs alloc] initWithExpected:expected] doesNotMatch:self];
}

@end