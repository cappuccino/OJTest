ANSI_ESC = String.fromCharCode(0x1B);

function colorText(text, colorCode)
{
  if (colorAllowed())
    return ANSI_ESC + "[" + colorCode + text + ANSI_ESC + "[0m";
  else
    return colorCode;
}

function red(text)
{
  return colorText(text, "31m");
}

function green(text)
{
  return colorText(text, "32m");
}

function yellow(text)
{
  return colorText(text, "33m");
}

function blue(text)
{
  return colorText(text, "34m");
}

function colorAllowed()
{
  return true;
}
