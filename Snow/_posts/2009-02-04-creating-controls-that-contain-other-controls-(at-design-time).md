---
layout: post
title: Creating controls that contain other controls (at design time)
date: 2009-02-04
author: xian
comments: true
categories: Software Development
tags: asp.net, control
---

# Creating controls that contain other controls (at design time)

I oft wondered how to create controls that accept static controls (defined in the .aspx page at design time) as content. This is very useful for designing the "look" of the output, especially in a databind control such as a repeater.
There are 2 parts of this.

1. Adding controls to a collection at design time.
An example of this would be a `DataGrid`'s Columns property. e.g.

```
    <asp:DataGrid>
    	<Columns>
    		<asp:Column />
    		<asp:Column />
    	</Columns>
    </asp:DataGrid>
```

These Column controls will be instantiated at runtime and added to the DataGrids Columns collection. To see how this works lets examine the code for the DataGrid property:

    [MergableProperty(false), DefaultValue((string) null), PersistenceMode(PersistenceMode.InnerProperty), WebSysDescription("DataControls_Columns"), Editor("System.Web.UI.Design.WebControls.DataGridColumnCollectionEditor, System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", typeof(UITypeEditor)), WebCategory("Default")]
    public virtual DataGridColumnCollection Columns
    { get; }

Now i have omitted the actual code of the property as it's not relevant, what is relevant is the attributes. However, notice that a set property is not even defined. How is that possible?
The key attribute here is `PersistenceMode`. This property defines how a property is persisted to HTML at design time. Let's have a look at all the available values:

    public enum PersistenceMode
    {
        Attribute,
        InnerProperty,
        InnerDefaultProperty,
        EncodedInnerDefaultProperty
    }

Now by default all of the properties of your server control will be specified as Attribute. As the name implies this property will be accessible as an attribute from your controls tag.

The one we are interested in is `InnerProperty`. This means that your property will be rendered as an element with your controls tag, this is exactly how a the Columns collection works on a DataGrid!
If you add `[PersistenceMode(PersistenceMode.InnerProperty)]` to a strongly type collection, then voila! You will be able to add strongly typed controls to your collection at design time.

Oh and for completion the other 2 enum values allow you to specific that a particular Property will be default value of a tag. i.e. The value between the opening and closing tag of your control, just like a Label. The second just implies that the value will be HTML encoded.

Note: In order for this to work properly your control must extend from `UserControl`and not Control :)

2. Creating a dynamic templated control to contain other controls

Surprisingly there isn't a whole lot of information out there that is specific to this particular example. In this case i want to have a control that can contain other controls, without having an .ascx file.

If you just want a container and no data-binding then this is actually quite easy to do. I'll show you my code and then go through it:

```
    public class TestTab : UserControl
    {
        private PlaceHolder _ContentPlaceHolder;
        private ITemplate _ContentTemplate;

        [PersistenceMode(PersistenceMode.InnerProperty)]
		[TemplateInstance(TemplateInstance.Single)]
        public ITemplate ContentTemplate
        {
            get { return _ContentTemplate; }
            set { _ContentTemplate = value; }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (_ContentPlaceHolder == null)
            {
                _ContentPlaceHolder = new PlaceHolder();
                this.Controls.Add(_ContentPlaceHolder);
            }

            _ContentTemplate.InstantiateIn(_ContentPlaceHolder);
        }
    }
```

Okay, first you need to create a class that extends from `UserControl`. You can instead extend from Control if you like, but you have to implement the interface `INamingContainer`. This interface does not actually have any methods, it just signifies to the framework that this control will become a naming container. This just means that the controls within ours will have unique id's, which is more applicable to a repeating control but i digress.

Next add a `PlaceHolder` to hold the template for obvious reasons. Then create an `ITemplate` property. The important thing to note here is that you set the `PersistenceMode` (as defined above) so you can easily set it's contents declaratively.

Also the `TemplateInstance.Single` attribute value as it allows you to reference the templated controls directly within the page.

Finally the real meat of it. In the `OnInit` event you need to create the content place holder to store your contained controls and add it to the control tree. It is important that you do it in this event so that ViewState is enabled for your sub controls.

The crucial line after that is that you instantiate the templated controls into your place holder. This will replace the place holder with whatever controls were in the template.

I have not tested the ViewState of this, but it should all work.

Note, if you do wish to create templates with values please see the MSDN article: http://msdn.microsoft.com/en-us/library/36574bf6(VS.80).aspx

Note2: Ensure the controls are create in Init to access them in Page_Load (otherwise they'll be created in Page_PreRender)

REF: http://www.csharper.net/blog/container_user_controls___user_controls_that_can_contain_other_controls.aspx - Comment by Ego

also of interest: http://msdn.microsoft.com/en-us/library/aa478964.aspx, http://msdn.microsoft.com/en-us/library/aa479300.aspx