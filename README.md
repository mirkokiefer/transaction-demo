#Transaction demo

**Explain in a few words your design decisions you took developing the above app**:

As this is only a quick prototype I decided to make heavy use of storyboards. When building a larger app I would actually resort mostly to programmatic UI flow as large storyboards are hard to maintain in a team.
The app follows the standard MVC model.
As almost all of the logic consists of wiring UI elements, it did not prove useful to write unit tests at this stage.
If given more time, I would start with some UI integration tests instead.
I decided to mock the server API for ease of development and testing.
The app has two targets - one using the mock server and one for the real server endpoint.

There obviously remains a lot to do in terms of UX and error handling...

**Which architectural patterns did you use in the past for mobile app development if any?**

The most important pattern I'd highlight is using dependency injection for all components.
This allows injection of mock components as dependencies for testing.

**What resources would you recommend to someone starting out in iOS development?**

I would recommend Ray Wenderlich's tutorials (http://www.raywenderlich.com).
I also heard good things about the Nerd Ranch Guide (http://www.bignerdranch.com/we-write/ios-programming/).

**How do you keep up with the latest in iOS development?**

I read Daver Verwer's iOS Dev Weekly newsletter, visit local meetups, follow fellow iOS developers on Twitter, ...

**Describe yourself in JSON format**

http://mirkokiefer.com/resume.json

**List some of your favourite libraries with a brief description**

- [BlocksKit](https://github.com/zwaldowski/BlocksKit): convenience functions to manipulate Arrays, Dictionaries using blocks. Also some useful framework additions using blocks e.g. for key-value observing.
- [Async](https://github.com/duemunk/Async): async control flow using blocks and GCD.
- [Reachability](https://github.com/tonymillion/Reachability): network reachability handling with blocks.
- Previously used AFNetworking but moved away from it when NSURLSession arrived.

**What are the top 5 tools that you could not live without?**

- Sublime for all non-iOS coding and writing.
- Dash
- Slack for working in a team
- Trello for organizing sprints and my personal tasks.
- Recently got very excited about [fastlane](https://fastlane.tools) but am still experimenting with it.  
