iStudy
=====================
An iPhone Flash Card App for CIS 600 at Syracuse University Fall 2011.

![simulator_screenshot_home_page.png](https://github.com/raulchacon/iPhone-Flash-Card-App/raw/master/simulator_screenshot_home_page.png "iStudy")

Contributors
----------------------

+ [Raul Chacon](http://github.com/raulchacon)
+ Aditya Patil

About
----------------------
This project was created with Xcode 4.2  utilizing the new storyboard feature and ARC (automatic reference counting). The latter means that retains and releases are deprecated with ARC enabled. Where you would normally see retain, is replaced with the keyword, "strong" which specifies that there is a strong (owning) relationship to the destination object.

Installation
----------------------
Xcode 4.2.1 with Storyboard required. App tested on iOS 5 simulator.

Usage
----------------------
From Subjects view you can select, create or delete subjects. After selecting a subject you will see a list of flash cards associated with the subject. From flash card list you can select, create or delete a flash card. Selecting a flash card sends you to flash card mode. 

In flash card mode, the front side of the flash card (navigation title: Question) accepts double tap gesture to flip the flash card over. From the back side of the flash card (navigation title: Answer) you must double tap to flip back over to the front since you can only return to the to flash card list from the front side view. The front side view also accepts swiping left and right to switch to other flash cards in the same subject. Lastly, front side view also contains a button which sends the title of the flash card as a search request to wikipedia.

License
-----------------------
The MIT License (MIT)