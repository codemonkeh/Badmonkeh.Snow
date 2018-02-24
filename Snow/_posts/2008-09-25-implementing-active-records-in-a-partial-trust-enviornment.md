---
layout: post
title: Implementing Active Records in a Partial Trust Environment
date: 2008-09-25
author: xian
comments: true
categories: Software Development
tags: .net, c#, lazy loading, orm, Castle, Active Records, partial trust
---

# Implementing Active Records in a Partial Trust Environment


a) Create a new project for the Model (a.k.a Data Access Layer)

b) Presuming you already have an existing database the next step is to generate classes for all of your strong entities.
   This can be done using the fantastic tool available here: http://www.bryanchen.com/2007/07/18/caragen-tool-the-castle-active-record-autonomous-generator-tool/
   One thing to note about this tool is that is will not generate relationships between entities so you'll have to do that yourself. If you are unsure the on how to do this the manual is a great help.
   Also you might want to update the templates first to fit your coding style, and fix up any areas in the resulting classes afterwards
  
c) The next step is to create the connection source for your database. It is better practice to do this in an xml file but you can do it in code of you prefer.

First add the following line inside your webconfig, in the configSections:

    <section name="activerecord" requirePermission="false" type="Castle.ActiveRecord.Framework.Config.ActiveRecordSectionHandler, Castle.ActiveRecord"/>
       
Then add a new section as below:
        
    <activerecord isWeb="true">
        <config>
            <add key="connection.driver_class" value="NHibernate.Driver.SqlClientDriver" />
            <add key="dialect" value="NHibernate.Dialect.MsSql2005Dialect" />
            <add key="connection.provider" value="NHibernate.Connection.DriverConnectionProvider" />
            <add key="connection.connection_string_name" value="badmonkeh" />            
        </config>
    </activerecord>
    
In this case i am referring to a MSSQL 2005 database with a predefined connection string with the name badmonkeh.
   
d) Then we need a class to initialise your database connection.
   This class basically has to tweak a couple of settings initialise all of the our record types. An elegant solution would be to use reflection for this, but unfortunately my host does not trust me enough for that. Below is an example class.

```
    public class ActiveRecordsInitialiser
    {
        public static void InitaliseSession()
        {
            IConfigurationSource config = ActiveRecordSectionHandler.Instance;
            ActiveRecordStarter.Initialize(config, GetAllActiveRecordTypes());
            NHibernate.Cfg.Environment.UseReflectionOptimizer = false;
        }   
        private static Type[] GetAllActiveRecordTypes()
        {
            List<Type> types = new List<Type>();    
            //TODO: Manually add types here 
            return types.ToArray();
        }
    }
```    

d) The next step is to ensure that the model is initialised every time the domain is loaded. Open up your global.asax file, or create a new "Global Application Class" if you do not have one.
   In the Appllication_Start event insert the following code:
   
    `YourNameSpace.ActiveRecordsInitialiser.InitaliseSession();`
   
   Obviously replacing the namespace with your own.

e) To get this to run you will need to add a reference to the following libraries (that are included with active records) to your web.config:
   
   `Iesi.Collections.dll, log4net.dll, Castle.Components.Validator.dll`

f) Enable lazy loading in a partial trust environment is the final (optional) step. Personally lazy loading is a huge benefit so i can't do without it. However i will leave this for a post of it's own :)

