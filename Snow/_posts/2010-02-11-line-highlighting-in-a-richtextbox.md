---
layout: post
title: Line highlighting in a RichTextBox
date: 2010-02-11
author: xian
comments: true
categories: Software Development
tags: RichTextBox
---

# Line highlighting in a RichTextBox

I often find myself writing little tools to perform specific purposes, as is the wont of a programmer.

However, mostly out of laziness, i tend to avoid writing command line utils and instead prefer little GUI apps. They allow me to add features that i can't have with a CLI, such as persisting settings and allowing file selection dialogs.

Anyways, one of the easiest ways to adapt a console app is to create a windows forms app that features a text box containing the output of whatever you wish to achieve. Now this itself is quite easy to do, however it is just as one dimensional as a console app. Why, you may ask, it is because you are still limited to displaying text in one colour. Should you wish to clearly identify your output you are limited to formatting the position or the characters of the text, which can be quite limiting. For example what if you wanted the errors in a process to be more visible that informational messages?

The solution is to use a RichTextBox. It allows you all of the rich text formatting of a rudimentary RTF editor, such as Wordpad. You could even display HTML in it.

Now, you could change your input to have the appropriate HTML/RTF tags, but this is a quite heavy handed approach and requires you to combine the format with the data. All i really want is to be able to change the colour of text as i insert it, quickly an easily. And here is a method to just do that:

        /// <summary>
        /// Appends a log message and highlights it with the specified text colour
        /// </summary>
        /// <param name="message">The message to append</param>
        /// <param name="colour">The colour to display the text in</param>
        private void AppendAndHighlightLogMessage(string message, Color colour)
        {
            int startIndex = txtLog.Text.Length;
            txtLog.AppendText(message + Environment.NewLine);
            txtLog.Select(startIndex, message.Length);
            txtLog.SelectionColor = colour;            
        }

In this example we have a `RichTextBox` named `txtLog`, and we are appending a string to it and highlighting only that with the colour specified.

It is important to note that you call the `AppendText(..)` method. If you just set the text using `txtLog.Text += message;` this will not work!

One of the nice things about this approach is even though you are only 'highlighting' the text, the colour will remain.