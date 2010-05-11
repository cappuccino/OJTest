@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeSameAs : OJSpecMatcher
{
}

- (BOOL)matches:(id)actual
{
    [self setActual:actual];
    return ([self expected] === [self actual]);
}

@end

/**
 * Checks if two objects are the same (has the same identity).
 */
@implementation CPObject (ShouldBeSameAsMatcher)

- (void)shouldBeSameAs:(id)expected
{
    if(![[[OJSpecShouldBeSameAs alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotBeSameAs:(id)expected
{
    if([[[OJSpecShouldBeSameAs alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

@end