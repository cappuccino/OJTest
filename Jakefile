#!/usr/bin/env narwhal

JAKE = require("jake");
SYSTEM = require("system");
FILE = require("file");
OS = require("os");

JAKE.task ("docs", ["documentation"]);

JAKE.task ("documentation", function()
{
    if (executableExists("doxygen"))
    {
        if (OS.system(["ruby", FILE.join("documentation", "make_headers")]))
            OS.exit(1); //rake abort if ($? != 0)

        if (OS.system(["doxygen", FILE.join("documentation", "OJTest.doxygen")]))
            OS.exit(1); //rake abort if ($? != 0)
    }
    else
        print("doxygen not installed. skipping documentation generation.");
});

executableExists = function(/*String*/ aFileName)
{
    return SYSTEM.env["PATH"].split(':').some(function(/*String*/ aPath)
    {
        return FILE.exists(FILE.join(aPath, aFileName));
    });
}