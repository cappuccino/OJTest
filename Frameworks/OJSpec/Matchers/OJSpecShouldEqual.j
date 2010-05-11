@import "../OJSpecMatcher.j"

@implementation OJSpecShouldEqual : OJSpecMatcher
{
}

@end

/**
 * Checks if two objects has the same value.
 *
@implementation CPObject (ShouldEqualMatcher)

- (void)shouldEqual:(id)expected
{
    if(![[[OJSpecShouldEqual alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotEqual:(id)expected
{
    if([[[OJSpecShouldEqual alloc] initWithExpected:expected] matches:self])
        throw SpecFailedException;
}

@end*/

[CPObject registerMatcher:OJSpecShouldEqual];
