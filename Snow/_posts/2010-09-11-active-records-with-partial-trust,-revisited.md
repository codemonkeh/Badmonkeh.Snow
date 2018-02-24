---
layout: post
title: Active Records with Partial Trust, Revisited
date: 2010-09-11
author: xian
comments: true
categories: Software Development
tags: castle, active records, partial trust
---

# Active Records with Partial Trust, Revisited

Getting active records to run under medium trust is a problem i have once solved before, and after upgrading to v2.1.2 it has come back again.
Essentially the problem is two fold:

 1. Ensuring all referenced Castle assemblies has the APTCA attribute applied
 2. Statically generating proxies with the APTCA attribute applied (is this still necessary?)

To begin i need to identify which assemblies are the problem. So i created a small test project and noted the assemblies that were directly or indirectly used, using Reflector. At the same time i could go through the list and note which ones did not have the attribute applied. This lead to the following list.

Referenced Assemblies Without APTCA:

* Castle.Core (1.2.0.0)
* Castle.Components.Validator (1.1.1.0)
* Castle.ActiveRecord (2.1.2)

Now in order to call these assemblies under medium trust i will have to rebuild them, applying the correct attribute, this could be quite a problem but fortunately Active Records is an open source project.
After a short search i discovered that the source is now stored at Github: http://github.com/castleproject

Then it was a simple case of downloading the source, labeled at the appropriate versions listed above.

This however seemed to be more trouble that it was worth, given that the code was hard to build when it was first split into individual projects (read: required Nant and i couldn't be bothered.)

Building the projects from source was simple enough when you copy in the buildscripts\ folder from the root project 'castle'. You might have manually reference the key to get them strong named but this is a simple matter.

From here all you have to do is apply the attribute as below to the CommonAssemblyInfo file, and voila you are done.

    [assembly: System.Security.AllowPartiallyTrustedCallers]

If your website is just a personal site and you do not have strongly name assemblies, then this is all you need to do.

Step 2 is the harder part. Assuming your assemblies are strongly signed, ensure first that they also have the APTCA.
