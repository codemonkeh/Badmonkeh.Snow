---
layout: post
title: Enabling Lazy Loading for Active Records under Partial Trust
date: 2008-09-25
author: xian
comments: true
categories: Software Development
tags: .net, c#, lazy loading, orm, Castle, Active Records
---

Lazy loading is one of the great features of nHibernate and is one that i could not do without. The problem is that like with most good things they don't work inheritanly on a medium trust web host.
The problem is that lazy loading relies on creating proxy classes for your records, at runtime. However you can using a nifty little tool generate your own proxy classes such that Active Records (nHibernate) does not have to generate them for you.

1. Download the source for the nHibernateProxyGenerator from http://blechie.com/WPierce/archive/2008/02/17/Lazy-Loading-with-nHibernate-Under-Medium-Trust.aspx

2. Copy across your recently compiled libraries for Active Records into the lib dir. Make sure that you have signed them or this will not work.

2. Build it. Depending on what version of source you got you may have to change the code a little to get it to compile. I had to update the config so it used a generic dictionary, but that was all.

3. Now as you are going to have to regenerate the proxies every time your change your model i would recommend that you copy the build dir of this program into a folder inside your libraries folder.

4. Create a build step to autmomatically generate the proxies for your Model project. Something like this:
    "$(SolutionDir)libs\NHibernateProxyGenerator\NPG.exe" /in:"$(TargetDir)BadMonkeh.DAO.dll" /out:"$(SolutionDir)libs\BadMonkeh.DAO.Proxies.dll"

    Obviously this step assumes you places NPG in a folder structure libs\NHibernateProxyGenerator off your builds dir, and that your assembly is called BadMonkeh.DAO.dll.
    
5. Then add the following line to your configuration inside the activerecord section, substituting the name of your proxy library:
    <add key="proxyfactory.factory_class" value="StaticProxyFactoryFactory, BadMonkeh.DAO.Proxies" />
            
6. And finally add a reference to the proxy library in your web.config.


###References:

* http://blechie.com/WPierce/archive/2008/02/17/Lazy-Loading-with-nHibernate-Under-Medium-Trust.aspx
* http://www.nhforge.org/wikis/howtonh/pre-generate-lazy-loading-proxies.aspx