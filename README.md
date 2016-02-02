# Pitch-Perfect
Source code for project 1 on Udacity iOS Developer Nanodegree 

Project 1 Report

Project Name: Pitch Perfect

Basic features
      Based on the criteria found in here:

https://docs.google.com/document/d/1LlcUT90j-ItbRQpB3ivLHwjP-KgKOUdoOLpz0WirpSo/pub?embedded=true

I have completed all tasks listed in the form under column “Exceeds Specifications” (if    applicable) or under column “Meets Specifications” (if the column above is not applicable) before section “Code Improvements”. 

Code Improvements
Based on the requirements listed in here:

https://docs.google.com/document/d/1uotwFB5A3qmQL4-NTNuI4UT_UqqPrsZ17wZMY6XhlB0/pub?embedded=true

1. Finished adding initializer to class RecordedAudio and called in  RecordSoundsViewController.
2. Finished fixing this bug. Actually, I implemented a feature that immediately after user taps a button to start playing one sound effect, all buttons will be disabled until current audio finishes. 
3. Legacy code removed.
4. Added a new label under the microphone button to give the user some basic indication of the current status of the app. 
 
Code Quality

1. I have did my best to extract reusable code into functions. 
2. I have read through the code style guide on github:

   https://github.com/github/swift-style-guide

   and tried to comply to it as best as I can. Due to my limited Swift knowledge, there are a lot of syntax that I don’t understand now so I didn’t follow all of them.
3. I have commented in an “as necessary and detailed” style, which might be too much but I think it would be a good practice at least for now.

Other modifications
I have changed the behaviour of the stop button on the second screen, so that it won’t be visible when the view loaded. Then after the user tapped on one of the buttons, all button will be disabled, and the stop button will appear. When the current audio finishes, all buttons will be enabled, and the stop button will disappear.

This repo only contains all the changes I made, starting from the end of the Intro course to finally finish the project.  




