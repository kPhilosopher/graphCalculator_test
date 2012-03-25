Demo Applications
===
These projects were initiated by the Stanford University’s CS193P, [iPhone Application Development class](http://www.stanford.edu/class/cs193p/cgi-bin/drupal/downloads-2010-fall). There are __two__ projects, in __three__ repositories. 

![Workflow](https://github.com/kPhilosopher/CoreDataPlaces/raw/master/Readme/workflow_of_repo.png)


[GraphCalculator](https://github.com/kPhilosopher/graphCalculator_test) was the first project. GraphCalculator is a simple two screen application that ushered me into Objective-C and iOS application development. This project gave me a glimpse to the syntax of Objective-C, Xcode, and the cocoa framework.

[Places](https://github.com/kPhilosopher/Places) and [CoreDataPlaces](https://github.com/kPhilosopher/CoreDataPlaces) were completed after GraphCalculator. The main difference between the two part project is the mechanism of persistence. Places uses NSUserDefaults while CoreDataPlaces uses Core Data. Whilst following the lectures supplied by Stanford, I also attempted to experiment with the suggestions detailed in *Clean Code: A Handbook of Agile Software Craftsmanship* and *The Pragmatic Programmer: From Journeyman to Master*.

Graph Calculator
---
The Graph Calculator application allows the user to do simple math computations and draw a graph of an expression. The specifications to this assignment can be found on the [CS193P page](http://www.stanford.edu/class/cs193p/cgi-bin/drupal/downloads-2010-fall).

Graph Calculator is a two UIViewController application. The first UIViewController’s view is a calculator view, setup with a xib file. The second UIViewController’s view is setup programmatically with axes to allow graphing of an expression. The [axes drawer](http://www.stanford.edu/class/cs193p/cgi-bin/drupal/system/files/sample_code/AxesDrawer_0.zip) is supplied by Stanford University.

----

The following lists outlines my first-time attempts, and experiments executed throughout the course of completing the projects.

Attempts
--------

- Objective-C
- Xcode
- Git / Github
- Dash for framework documentation lookup
<br /><br />
- Model-View-Controller design/implementation
- [Delegation](https://github.com/kPhilosopher/Places/blob/master/Places_09/PLAppDelegate.m)
- [Notification](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/CoreDataTableMVC/CPCoreDataTableViewController.m)
- [Strategy design pattern](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/IndexedTableMVC/CPIndexedTableViewController.m)
- [Factory design pattern](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/CoreDataTableMVC/CPCoreDataTableViewController.m)
- Multi-MVC application - [Places](https://github.com/kPhilosopher/Places) & [CoreDataPlaces](https://github.com/kPhilosopher/CoreDataPlaces)
<br /><br />
- [Multithreading with Grand Central Dispatch](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/ScrollableImageMVC/CPScrollableImageViewController.m)
- [Algorithm utilizing NSDictionary](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/PhotosTableMVC/CPPhotosDataIndexer.m)
- [Key-Value-Observing](https://github.com/kPhilosopher/Places/blob/master/Places_09/PlaceTableViewController.m)
- [Objective-C category](https://github.com/kPhilosopher/CoreDataPlaces/tree/master/CoreDataPlaces/Categories)
- iPad/iPhone universal application
- [UIView](https://github.com/kPhilosopher/graphCalculator_test/blob/master/GraphCalculator/GraphView.h)
- [Multi-touch gestures](https://github.com/kPhilosopher/graphCalculator_test/blob/master/GraphCalculatorViewController.m)
- [Core Data implementation with SQLite database](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/AppDelegate/CPAppDelegate.m)
- [Image cache with NSFileManager](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/ScrollableImageMVC/CPImageCacheHandler.m)
<br /><br />
- Utilization of NSZombie
- [nib/xib file based UI design](https://github.com/kPhilosopher/graphCalculator_test/tree/master/GraphCalculator)
<br /><br />
- TDD -> Refactoring development cycle - [Production code](https://github.com/kPhilosopher/CoreDataPlaces/tree/master/CoreDataPlaces/CoreDataPhotosMVC), [Test code (MostRecentPhotos files)](https://github.com/kPhilosopher/CoreDataPlaces/tree/master/CoreDataPlacesTests)
- [OCMock objects](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlacesTests/CPMostRecentPhotosRefinaryTests.m)
- [Integration Tests with Keep It Functional (KIF) by Square](https://github.com/kPhilosopher/CoreDataPlaces/tree/master/KIF)
<br /><br />
- Descriptive coding applied to variable, class, protocol, method and constant names

Experiments
----------

- [KIF to run block steps with dynamic data from Flickr (line 270)](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/KIF/KIFTestScenario%2BPlacesAdditions.m)
<br /><br />
- Descriptive coding with up-down layout of methods - [example 01](https://github.com/kPhilosopher/Places/blob/master/Places_09/PLTabBarController.m), [example 02](https://github.com/kPhilosopher/graphCalculator_test/blob/master/GraphCalculator/GraphView.m)
- [Descriptive coding with readability methods](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlaces/TabBarMVC/CPTabBarController.m)
<br /><br />
- [Unit test of CoreData NSManagedObjects with OCMock](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlacesTests/CPMostRecentPhotosRefinaryTests.m)
- [Unit test of CoreData NSManagedObjects with CoreData Stack](https://github.com/kPhilosopher/CoreDataPlaces/blob/master/CoreDataPlacesTests/CPPlaceFavoriteLogicTests.m)
