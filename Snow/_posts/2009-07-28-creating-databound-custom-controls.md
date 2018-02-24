---
layout: post
title: Creating a custom databound control with postbacks
date: 2009-07-28
author: xian
comments: true
categories: Software Development
tags: asp.net, control, postback
---

# Creating a custom databound control with postbacks

    /// <summary>
    /// Creating a custom databound control with postbacks
    /// --------------------------------------------------
    /// This class provides you the basis for a databound custom control
    /// and shows you where to place logic to ensure the data is saved in
    /// the ViewState and the dynamically created child controls work
    /// as intended
    /// </summary>
    class MyControl : Control
    {
    	private object datasource;
    	//CF: A list we are using for example
    	private RadioButtonList _List;
    
    	//CF: Define this as whatever you want if this control is databound
    	//	  This object should not be persisted as you are relying on ViewState
    	public object DataSource
    	{ 
    		get { return datasource; }
    		set { datasource = value; }
    	}
    	
    	//CF: This variable holds the number of items that were databound
    	//	  It is used on post back to recreate the items that are stored in the ViewState
    	private int NumberOfItems
    	{
    		get
    		{
    			if (ViewState["NumberOfItems"] == null)
    				return 0;
    			return (int) ViewState["NumberOfItems"];
    		}
    		set { ViewState["NumberOfItems"] = value; }
    	}	
    
    	protected override void OnInit(EventArgs e)
    	{
    		base.OnInit(e);
    
    		//CF: The controls must be created here otherwise the postback data will not be loaded!!!
    		EnsureChildControls();
    		
    		//CF: If your control requires ControlState uncomment this line
    		//Page.RegisterRequiresControlState(this);
    	}
    
    	protected override void CreateChildControls()
    	{
    		//CF: Only create the list and it's items here it will be populated on databinding, or via viewstate
    		_List = new RadioButtonList();
    		for (int i = 0; i < NumberOfItems; i++)
    		{
    			ListItem item = new ListItem();
    			_List.Items.Add(item);
    		}
    		Controls.Add(_List);
    		
    		//CF: Setting additional properties of the controls should be done *after* 
    		//	  they are added to Controls collection. This will "dirty" the ViewState
    		//	  and ensure their value is persisted
    		//	  Ensure you give your dynamic controls an ID, to associate them to their 
    		//	  ViewState data
    		_List.ID = "list";
    	}
    	
    	protected override void OnDataBinding(EventArgs e)
    	{
    		//CF: You need to set the number of items here
    		NumberOfItems = DataSource.Count;
    		
    		//CF: As the list was already created in OnInit() with no items, it must be recreated here
    		Controls.Clear();
    		CreateChildControls();
    		
    		//CF: Now we loop through each item and databind it's actual value
    		for (int i = 0; i < NumberOfItems; i++)
    		{
    			ListItem item = _List.Items[i];
    			//TODO: Obtain the value from the DataSource and set the Controls properties
    		}
    	}
    	
    	//CF: If necessary override Render() to specify custom control rendering, otherwise leave it as it is
    	//protected override void Render(HtmlTextWriter writer)
    	//{
    	//	//TODO: Do stuff
    	//}
    	
    	//CF: If you are using control state uncomment the following 2 paragraphs and customise them 
    	//	  as necessary. If you need to save multiple objects it is probably best to wrap them up
    	//	  in a struct/class.
    	//	  Remember all objects must be Serializable.
    	/*
    	protected override void LoadControlState(object savedState)
    	{
    		object[] state = (object[]) savedState;
    		base.LoadControlState(state[0]);
    		MyObject = state[1];
    	}
    
    	protected override object SaveControlState()
    	{
    		object[] state = new object[2];
    		state[0] = base.SaveControlState();
    		state[1] = MyObject;
    		return state;
    	}	
    	*/
    }