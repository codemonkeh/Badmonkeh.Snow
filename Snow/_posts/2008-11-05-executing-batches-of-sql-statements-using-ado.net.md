---
layout: post
title: Executing batches of SQL statements using ADO.NET
date: 2008-11-05
author: xian
comments: true
categories: Software Development
tags: sql, ado.net
---

# Executing batches of SQL statements using ADO.NET

I was writing an auditing tool recently that generated scripts to create triggers. Of course i wanted to guarantee that these scripts did not fail so i did the right thing and first checked if the trigger existed, and dropped it if it did.

Now i wrote these scripts originally in SQL Server Management Studio of course, and used the GO statement to separate them into batches. If you don't do this you will get a horrible error message informing you that CREATE statements must be the first line in a batch.

For more information about batches see: http://www.teratrax.com/tsg/help/queries.html

Now when i went to execute this scripts on the fly, lo and behold i came upon a familiar error message: '`CREATE TRIGGER`' must be the first statement in a query batch.

It turns out for some perverse reason ADO.NET interprets the SQL you give it as a single batch, in fact it must go as far as to strip or ignore all `GO` statements within it. Logically a `Command` would appear to be singular, but regardless you would hope that it would execute the SQL as written.

So having this in mind there is a very simple solution. The below code splits the SQL into separate batches for singular execution:

    string sql = "... your sql ...";
    Regex regex = new Regex("^GO", RegexOptions.IgnoreCase | RegexOptions.Multiline);
    string[] batches = regex.Split(sql);

Then of course to execute them you just need to loop through each, and execute it as a separate command.