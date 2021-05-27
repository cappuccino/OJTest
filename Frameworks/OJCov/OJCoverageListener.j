@import <Foundation/CPObject.j>
@import "OJCoverageSelector.j"

var og_objj_msgSend = objj_msgSend;
var og_objj_msgSendFast = objj_msgSendFast;
var og_objj_msgSendFast0 = objj_msgSendFast0;
var og_objj_msgSendFast1 = objj_msgSendFast1;
var og_objj_msgSendFast2 = objj_msgSendFast2;
var og_objj_msgSendFast3 = objj_msgSendFast3;
var og_class_addMethod = class_addMethod;
var og_class_addMethods = class_addMethods;

SHOULD_APPEND = YES;

@implementation OJCoverageListener : CPObject
{
    id          delegate            @accessors;
}

- (void)start
{
    objj_msgSend = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    objj_msgSendFast = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    objj_msgSendFast0 = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    objj_msgSendFast1 = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    objj_msgSendFast2 = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    objj_msgSendFast3 = function(aReceiver, aSelector) {

        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }

        return og_objj_msgSend.apply(this, arguments);
    };

    class_addMethod = function(aClass, aName, anImplementation, aType) {
        if(aClass != null)
        {
            var resolvedClass = objj_getClass(class_getName(aClass));
            [delegate foundMethod:[OJCoverageSelector selectorWithClassName:resolvedClass selector:aName]];
        }

        og_class_addMethod(aClass, aName, anImplementation, aType);
    }

    class_addMethods = function(aClass, methods) {
        if(aClass != null)
        {
            var resolvedClass = objj_getClass(class_getName(aClass));
            methods.map(function(method){[delegate foundMethod:[OJCoverageSelector
                selectorWithClassName:resolvedClass selector:method_getName(method)]];});
        }

        og_class_addMethods.apply(this, arguments);
    }
}

- (void)stop
{
    objj_msgSend = og_objj_msgSend;
    objj_msgSendFast = og_objj_msgSendFast;
    objj_msgSendFast0 = og_objj_msgSendFast0;
    objj_msgSendFast1 = og_objj_msgSendFast1;
    objj_msgSendFast2 = og_objj_msgSendFast2;
    objj_msgSendFast3 = og_objj_msgSendFast3;
    class_addMethod = og_class_addMethod;
    class_addMethods = og_class_addMethods;
}

@end
