@implementation CPInvocation (Arguments)

- (CPArray)arguments
{
    return _arguments;
}

- (CPArray)userArguments
{
    return _arguments.slice(2,_arguments.length);
}

@end