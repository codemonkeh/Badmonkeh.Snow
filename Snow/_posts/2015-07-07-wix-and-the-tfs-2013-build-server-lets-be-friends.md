---
layout: post
title: Wix and the TFS 2013 build server, let's be friends
date: 2015-07-07 03:15
author: xian
comments: true
categories: Software Development
tags: dev, error1719, error217, tfs, tfs2013, tfsbuild, wix, wix-3.9
---
We recently commissioned a new build server as part of an upgrade and moved to WiX 3.9R2 as part of the process. After setting up a new build profile my installer build would fail with this same message per each ICE action:


>light.exe (0): Error executing ICE action 'ICE01'. The most common cause of this kind of ICE failure is an incorrectly registered scripting engine. See [http://wixtoolset.org/documentation/error217/](http://wixtoolset.org/documentation/error217/) for details and how to solve this problem. The following string format was not expected by the external UI message logger: "The Windows Installer Service could not be accessed. This can occur if you are running Windows in safe mode, or if the Windows Installer is not correctly installed. Contact your support personnel for assistance.".

Which produces a similar message in the server's event logs:

>Product: ProductNameRemoved -- Error 1719. The Windows Installer Service could not be accessed. This can occur if you are running Windows in safe mode, or if the Windows Installer is not correctly installed. Contact your support personnel for assistance.

At this point much googling leads to to a similar set of instructions, re-register msiexec, check registry permissions, etc. I tried all of these to no avail, until finally I came across an insightful post from <a href="http://www.wintellect.com/devcenter/jrobbins/wix-projects-vs-tfs-2010-team-build">John Robbins</a> that has the solution:

>"In order for the .WiXProj files to compile, the account running the build controller/agent must be in the local machine’s administrator group."


Therefore the solution is simply:

1. Add the service account to the *Local Administrators* user group
2. Restart the server
3. ...
4. Profit!

**Note: If you do not already have a service account then I strongly advise you to create one, it is a dangerous security practice to run add a low privileged account like NT SERVICE as an administrator.**
