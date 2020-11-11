---
layout: page
title:  "What is MVC Design Pattern?"
date:   2018-07-27 21:00:00 -0700
categories: design_pattern
---

I used the MVC design pattern for a side project I worked with some of my friends. I am gonna leave a note of what I learned about the MVC design pattern.

## What is MVC?
`MVC` stands for `Model`, `View`, and `Controller`. 

`Model` is responsible for databases, business enities, or any storage systems. Data Schema goes to Model. 
`View` is respinsible for displaying everything for system's users (UI of the system). View renders data from Model and display to users. 
`Controller` is for logics. All business logics go to the controllers folder.

In some companies or the iOS world, Model is called Data Manager. View is called View Controller or Storyboard. Controller is called Core or Manager.

## Why Do We Need a Design Pattern Like MVC?
A design pattern like MVC improves the maintainability of source codes. We don't want spaghetti codes such as an object that depends on many files. If you try to change one thing in a file, you have to open up 4-5 files to read and change it. A good desgin pattern can avoid this kind of situations. 

## Note
One thing to note here is just because View means UI of a system and Model is for data management and Controller is for business logics, it does NOT mean that View is for front-end people and Model and Controller are for back-end people. You can apply a MVC pattern to both front-end and back-end.