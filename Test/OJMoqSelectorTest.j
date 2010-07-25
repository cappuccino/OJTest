@import "../Frameworks/OJMoq/OJMoqSelector.j"

@implementation OJMoqSelectorTest : OJTestCase

- (void)testThatSelectorsWithDifferentNamesDoNotEquate
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"sel1" withArguments:[CPArray array]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"sel2" withArguments:[CPArray array]];
    [OJAssert assert:NO equals:[sel1 equals:sel2]];
    [OJAssert assert:NO equals:[sel2 equals:sel1]];
}

- (void)testThatSelectorsWithSameNamesButDifferentArgumentsDontEquate
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray arrayWithObject:@"yes"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray arrayWithObject:@"no"]];
    [OJAssert assert:NO equals:[sel1 equals:sel2]];
    [OJAssert assert:NO equals:[sel2 equals:sel1]];
}

- (void)testThatSelectorsWithSameNamesAndNoArgumentsEquate
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray array]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray array]];
    [OJAssert assert:YES equals:[sel1 equals:sel2]];
    [OJAssert assert:YES equals:[sel2 equals:sel1]];
}

- (void)testThatSelectorsWithSameNamesAndOneSelectorWithNoArgumentsEquate
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray arrayWithObject:@"yes"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"same" withArguments:[CPArray array]];
    [OJAssert assert:NO equals:[sel1 equals:sel2]];
    [OJAssert assert:NO equals:[sel2 equals:sel1]];
}

- (void)testThatOJMoqSelectorDoesFindNameInSelectors
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray arrayWithObject:@"a"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"b" withArguments:[CPArray array]];
    var sel3 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    
    var array = [sel2, sel3];
    
    [OJAssert assert:[sel3] equals:[OJMoqSelector find:sel1 in:array]];
}

- (void)testThatOJMoqSelectorDoesFindAllMatchingSelectors
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray arrayWithObject:@"a"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"b" withArguments:[CPArray array]];
    var sel3 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    var sel4 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray arrayWithObject:@"a"]];
    
    var array = [sel2, sel3, sel4];
    
    [OJAssert assert:[sel3, sel4] equals:[OJMoqSelector find:sel1 in:array]];
}

- (void)testThatOJMoqSelectorCanFindMatchingSelectorsWhenPassedInSelectorHasWildcardForArguments
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray arrayWithObject:@"a"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"b" withArguments:[CPArray array]];
    var sel3 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    var sel4 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    
    var array = [sel1, sel2, sel4];
    
    [OJAssert assert:[sel1, sel4] equals:[OJMoqSelector find:sel3 in:array]];
}

- (void)testThatOJMoqSelectorOnlyFindsSelectorMatchingArgumentsWhenIgnoringWildcards
{
    var sel1 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray arrayWithObject:@"a"]];
    var sel2 = [[OJMoqSelector alloc] initWithName:@"b" withArguments:[CPArray array]];
    var sel3 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    var sel4 = [[OJMoqSelector alloc] initWithName:@"a" withArguments:[CPArray array]];
    
    var array = [sel1, sel2, sel4];
    
    [OJAssert assert:[sel4] equals:[OJMoqSelector find:sel3 in:array ignoreWildcards:YES]];
}
@end
