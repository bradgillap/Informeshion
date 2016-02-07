# Informeshion

## Purpose

The Informeshion project seeks to script [Raspbian](https://www.raspbian.org/) as an information awareness broadcast station with mesh capabilities. The result will be low powered devices broadcasting wireless signal over short distances of **relevant information**. The solution must be easy for the organizer to setup and easier for the user to retrieve.

### What is Relevant Information?

Think of how many scenarios there are where an access point providing specific event information would be useful. Many of these situations would be best served through different types of images, text, and video formats. Let's think critically about the problem we are trying to solve.

1. The user arrives to an event
2. The user has to know this access point exists with relevant information making this. **barrier one**
3. The user connects to the access point and then has to know, to open a browser. **barrier two**
4. The user retrieves relevant information and perhaps adds to the conversation. **success**

## Goals
### General
* Provide an image for each Raspberry Pi one and two to be loaded to an SDCard.
* Provide a curl script that will complete all steps necessary to setup a default Informeshion with graphical installer options.
* Construct media, supporting the device and idea in ways that might make sense to a user.
* Offer less restrictive templating for users to construct and provide their own Informeshion user experience.
* Offer modules in the way of user choice for their Informeshion.
* Provide a tool to load images onto an SDCard without relying on third party software for Windows.

### Loose Living Tasks

#### Stage 1
- [ ] Build a skeleton prototype for Raspberry Pi 1 and 2.
  - [ ] Configure Services.
  - [ ] Build a simple webpage to output service information.

#### Stage 2
- [ ] Bash script the prototype for consumption with curl by the community.
  - [ ] Build a community portal feedback website.
- [ ] Release preconfigured images.

#### Stage 3
- [ ] Refine and expand possible services.
  - [ ] Auto open device browsers, add features etc, possibly generate QR codes for configuration etc.
- [ ] Refine and build in more user control options for theming.

#### Stage 4
- [ ] Optimize for hardware example: SDCard lifespan, threaded processing etc.
- [ ] Test against a range of cheap available wireless hardware paying close attention to the testing environment. Focus on mesh.
- [ ] Create a recommended hardware list. 

#### Stage 5
- [ ] Mesh the [C.H.I.P](http://getchip.com/) hardware as cheap deployable access points leaving the pi to do the heavy lifting.
- [ ] Package a combination of pi2,c.h.i.p, and cheap batteries as a possible disposable network.

## Questions:
How is this different from [Piratebox](https://piratebox.cc/) or [Librarybox](http://librarybox.us) ?

We absolutely fell in love the piratebox project but we found development to be constrained by the low cost devices selected. We plan to leave legacy devices in the dust in favour of new software features. Since the project is focused on Raspbian, it is likely to stay with the Raspberry Pi product. 

## License
Copyright [2016] [Bradley Gillap & Ryan Morris]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
