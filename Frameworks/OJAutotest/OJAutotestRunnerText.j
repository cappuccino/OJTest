#!/usr/bin/env objj

@import <OJUnit/OJTestRunnerText.j>

var SYSTEM = require("system");
var OS = require("os");
var FILE = require("file");
var GROWLER_SCRIPT_OPTIONS = "-w -n OJAutotest -p 0 --image '%@' -m '%@' '%@' '' &";
var ERROR_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "error.png");
var SUCCESS_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "success.png");

var stream = require("term").stream;

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

        if(isDirty === "true") // because isDirty needs to be coerce. UGH.
        {
            [self growlWithMessage:@"Dirty tests passed!", "OJAutotest Success!", SUCCESS_IMAGE];
        }
        else
        {
            [self growlWithMessage:@"All tests passed!", "OJAutotest Success!", SUCCESS_IMAGE];
        }
        
        stream.print("\0green(All tests passed in the test suite.\0)");
        return CPLog.info("End of all tests.");
    }
    
    [self growlWithMessage:totalErrors+" failures!" title:"OJAutotest Failed!" image:ERROR_IMAGE];

    stream.print("Test suite failed with \0red(" + [[_listener errors] count] + 
        " errors\0) and \0red(" + [[_listener failures] count] + " failures\0).");
    
    [self exit];
}

- (void)growlWithMessage:(CPString)message title:(CPString)title image:(CPString)image
{
    var growlArguments = [CPString stringWithFormat:GROWLER_SCRIPT_OPTIONS, image, message, title];
    var growlCommand = "ojautotest-growl " + growlArguments;
    OS.system(growlCommand+growlArguments);
}

@end

function main(args) {

    runner = [[OJAutotestRunnerText alloc] init];
    [runner startWithArguments:args.slice(2) withDirty:args[1]];
}
