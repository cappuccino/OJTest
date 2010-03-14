@import <OJUnit/OJTestRunnerText.j>

var SYSTEM = require("system");
var FILE = require("file");
var STREAM = require("term").stream;
var GROWL = require("growl-js");

var ERROR_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "error.png");
var SUCCESS_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "success.png");


/*!
   This is a subclass of OJTestRunnerText that provides growl functionality along with some
   other pertinent information in the context of OJAutotest.
 */
@implementation OJAutotestRunnerText : OJTestRunnerText
{
    BOOL        isDirty;
}

- (void)startWithArguments:arguments withDirty:(BOOL)shouldSetDirty
{
    isDirty = shouldSetDirty;
    [self startWithArguments:arguments];
}

- (void)report
{
    var totalErrors = [[_listener errors] count] + [[_listener failures] count];

    if (!totalErrors) {

        if(isDirty === "true") // because isDirty needs to be coerced. UGH.
        {
            GROWL.postNotification("OJAutotest Success!", "Dirty tests passed!", SUCCESS_IMAGE);
        }
        else
        {
            GROWL.postNotification("OJAutotest Success!", "All tests passed!", SUCCESS_IMAGE);
        }
        
        STREAM.print("\0green(All tests passed in the test suite.\0)");
        return CPLog.info("End of all tests.");
    }
    
    GROWL.postNotification("OJAutotest Failure!", totalErrors + " failures!", ERROR_IMAGE);

    STREAM.print("Test suite failed with \0red(" + [[_listener errors] count] + 
        " errors\0) and \0red(" + [[_listener failures] count] + " failures\0).");
    
    [self exit];
}

@end