Setup Guide
===========

You have multiple options available for integrating BarCodeKit into your own apps. Ranked from most to least convenient they are:

- [Using Cocoapods](#Cocoapods)
- [As Sub-Project and/or Git Submodule](#Subproject)

BarCodeKit is designed to be included as static library from a subproject.

Requirements
------------

BarCodeKit is still in flux, for now it requires iOS 7 but the functions it needs from there can easily be replaced with something compatible with earlier versions. Also support for OS X is relatively simple to implement.

If you need one of these criteria to be met please contact us.

<a id="Cocoapods"></a>
Integrating via Cocoapods
-------------------------

Having [set up Cocoapods](http://www.cocoanetics.com/2013/01/digging-into-cocoapods/) and added the private Cocoanetics CocoaPods repository, you add BarCodeKit to your `Podfile` like this:

    platform :ios
    pod 'BarCodeKit'

This always gets the latest version of the pod spec from the global repository. It also automatically resolves the DTFoundation reference.

Cocoapods works by copying all source files into an Xcode project that compiles into a static library. It also automatically sets up all header search path and dependencies.

One mild disadvantage of using Cocoapods is that you cannot easily make changes and submit them as pull requests. But generally you should not need to modify BarCodeKit code anyway.

<a id="Subproject"></a>
Integrating via Sub-Project
---------------------------

This is the recommended approach as it lets Xcode see all the project symbols and dependencies and also allows for execution of the special build rule that processes the `default.css` file into a link-able form.

If you use `git` as SCM of your apps you would add BarCodeKit as a submodule, if not then you would simply clone the project into an Externals sub-folder of your project. The repo URL can either be the one of the master repository or - if you plan to [contribute to it](http://www.cocoanetics.com/2012/01/github-fork-fix-pull-request/) - could be a fork of the project.

### Getting the Files

The process of getting the source files of BarCodeKit differs slightly whether or not you use `git` for your project's source code management.

#### As Git Submodule

You add BarCodeKit as a submodule:

    git submodule add https://github.com/Cocoanetics/barcodekit.git Externals/BarCodeKit
   
BarCodeKit has several dependencies into the DTFoundation project. To have git clone the main project and also set up the dependencies do this:
	
    git submodule update --init --recursive
   
Now you have a clone of BarCodeKit in Externals/BarCodeKit.

   
#### As Git Clone

If you don't use git for your project's SCM you clone the project into the Externals folder:

    git clone --recursive https://github.com/Cocoanetics/barcodekit.git Externals/BarCodeKit
   
Now you have a clone of BarCodeKit in `Externals/BarCodeKit`.

### Project Setup

You want to add a reference to `BarCodeKit.xcodeproj` in your Xcode project so that you can access its targets. You also have to set the header search paths, add some framework/library references and check your linker flags.

#### Adding the Sub-Project

Open the destination project and create an "Externals" group.

Add files… or drag `BarCodeKit.xcodeproj` to the Externals group. Make sure to uncheck the Copy checkbox. You want to create a reference, not a copy.

#### Setting up Header Search Paths

For Xcode to find the headers of BarCodeKit add `Externals/BarCodeKit/Core` to the *User Header Search Paths*. Make sure you select the *Recursive* check box.

#### Setting Linker Flags

For the linker to be able to find the symbols of BarCodeKit, specifically category methods, you need to add the `-ObjC` linker flag:

In Xcode versions before 4.6 you also needed the `-all_load` flag but that appears to no longer be necessary.

#### Resources

BarCodeKit will use the OCR-B font for rendering the captions, if it is present in the app bundle. The demo app has this font included.
