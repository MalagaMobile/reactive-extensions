# Introduction to Reactive Extensions
This repo contains the resources used in the Málaga Mobile Meetup in March 2019.

## Slides
They can be found [here](./Slides/Reactive-Extensions.pdf).

## Demo Project
The Demo project shows one of the major caveats in Reactive Extensions: "Errors terminate the sequence".

In particular, that project shows a very real use case in which you may have a button tap action bound to an Observable. That observable may produce an error at some point. If that error is not handled properly it may cause the sequence to terminate. That means that tapping on that button won't have any effect from there on.

To represent that issue in an easy way for demo purposes, there is 1 button with title `Value` that causes the counter to increment by one. If you tap on `Error`, it will generate an error in that sequence. Note that the value and error button observables have been [merged](https://github.com/MalagaMobile/reactive-extensions/blob/master/Demo/RxErrors/RxErrors/ViewController.swift#L40).

#### Errors not handled
If you run the project as is, you'd notice that after tapping on `Error`, tapping on `Value` has no effect; the error has terminated the sequence.

#### Error handled
If you now comment the call to the function [configureView()](https://github.com/MalagaMobile/reactive-extensions/blob/master/Demo/RxErrors/RxErrors/ViewController.swift#L27) and uncomment [configureViewWithoutErrors()](https://github.com/MalagaMobile/reactive-extensions/blob/master/Demo/RxErrors/RxErrors/ViewController.swift#L28) you will see the difference. Now the error generated by the `Error` button is handled so other taps to `Value` would still increment the counter.

### Running the project
All pods have been checked in. So, all you should need is to open the workspace and hit run.

Note that the build configuration is set to `Release`. That is because if set to `Debug`, when an Observable emits an error that is not handled, an exception will be thrown. That is of great help when debugging but on production the behaviours your users would see is like the one depicted here.
