!SLIDE

# BDD with Cucumber #
#### Behaviour Driven Development (BDD)
> Kurt Landrus

!SLIDE bullets incremental transition=fade

# Extreme, Agile, Waterfall, Iterative, Formal, Rapid, Plan-driven, etc.
~= "Cowboy Coding" 
compared to 
#### Test Driven Development (TDD)
#### Behaviour Driven Development (BDD)

!SLIDE bullets incremental transition=fade

Methodologies compared
<table border=1>
<thead>
<th>Methodology</th>
<th>Developer's Role</th>
<th>QA's Role</th>
</thead>
<tbody>
<tr>
<td>Cowboy</td>
<td>Write the code, test it. (maybe)</td>
<td>Read the developer's mind. Test everything</td>
</tr>
<tr>
<td>TDD</td>
<td>Write a test,  Code to passing.</td>
<td>Expand the test suite to handle edge/corner cases & security.</td>
</tr>
<tr>
<td>BDD</td>
<td>Describe a feature,  Code to passing.</td>
<td>Same as TDD.</td>
</tr>
<tbody>
</table>

!SLIDE bullets incremental transition=fade

### Cucumber != BDD
### RSpec != BDD

Tools are tools. While Cucumber and RSpec are optimized for BDD, using them doesn't automatically mean you're doing BDD!
- The RSpec Book

#
BDD tools in general, and Jasmine in
particular, try to focus your attention on the
idea that you are specifying code yet to be
written, not validating code that already
exists. So, for example, Jasmine uses should
rather than assert to make verifiable
statements about the code.
In particular, the individual unit of a Jasmine
suite is often referred to not as a “test”, but
rather as an example, specification, or spec. 

### BDD is a mindset not a tool set

Behaviour-driven development is an “outside-in” methodology. It starts at the outside by identifying business outcomes, and then drills down into the feature set that will achieve those outcomes. Each feature is captured as a “story”, which defines the scope of the feature along with its acceptance criteria

We need a way to describe the requirement such that everyone – the business folks, the analyst, the developer and the tester – have a common understanding of the scope of the work. From this they can agree a common definiton of “done”, and we escape the dual gumption traps of “that’s not what I asked for” or “I forgot to tell you about this other thing”.

!SLIDE bullets incremental transition=fade
# Gherkin as a Second Language

    Feature: title                        <= Name of feature
        As a [role]                            <= Who?
        I want to [some action]      <= What?
        In order to (So that) [business value]    <= Why?

- not excuted
- documentation 
- business value up front    

What is important to have in narrative;

- business value
- stakeholder role
- user role
- action to be taken by user

!SLIDE bullets incremental transition=fade
### Acceptance Criteria: (presented as Scenarios)

    Scenario: title                     <= like a test, many per feature
      Given [context]                <= Set the stage
    And [more context]
      When I do [action]
    And [other action]
      Then I should see [outcome]   <= Expectation
    But I should not see [outcome]
    
Also:

- When - interim activity before Then
- Background - before each scenario.
- And - same as the prior step
- @tags - sorting and behavior

The scenario should be described in terms of Givens, Events and Outcomes

!SLIDE bullets incremental transition=fade

First describe a feature

... and watch it fail. (red)
Then code to the test until pass
refactor rinse repeat.
... and watch it pass. (green)


Test coverage with Rcov/Simplecov


!SLIDE bullets incremental transition=fade

# BDD With  #

### Features
* specification
* acceptance test
* documentation

!SLIDE bullets incremental transition=fade

# Communication
## Stakehoder - Tester - Developer

### Plain English language

    Feature: Do something really useful
      As a ...
      In order to ...
      So that ...

    Scenario: useful task
      Given I am here
      When I do something
      Then it should be really useful..
      And make everyone happy!
    
!SLIDE bullets incremental transition=fade

## @wip on master
    cucumber --tags ~@wip --strict
      tag exclusion ^

    rake cucumber:wip:2
      limit tags in flow

    @proposed
    Scenario: some stuff

    @proposed
    Scenario: some more stuff

    $ cucumber features/awesome.feature:7    // line # of scenario

!SLIDE bullets incremental transition=fade
!SLIDE bullets incremental transition=fade
!SLIDE bullets incremental transition=fade
# Why? not How?

BDD for the whole team

This dayʼs workshop is aimed at the whole team: Product Owners, Business Analysts, Project Managers, Testers, Developers, User Experience specialists and everyone inbetween. The aim is to build awareness of and enthusiasm for BDD.

- What is BDD?
- How does BDD fit with agile?
- Specification with examples
- The importance of a ubiquitous language
- The three amigos
- Cucumber demo
- Gherkin syntax
- Writing readable Cucumber features

Day 3: BDD with Cucumber

- The lie of the land: the simplest possible cucumber project
- Adding features: the basic BDD cycle
- Writing features right: layers of abstraction
- Refactoring existing features: tools and tips

Day 4: Advanced BDD

- How to identify and resolve flickering scenarios
- Learning from brittle scenarios
- What slow test suites are telling you
- What to do when your customer won't read your features

!SLIDE bullets incremental transition=fade

# Rails setup.
gem 'rspec-rails'
gem 'cucumber-rails'
gem 'database_cleaner'
gem 'capybara-webkit'
gem 'capybara-selenium'
gem 'launchy'

config/database.yml

    test: &test
    
    cucumber: 
      <<: *test

config/cucumber.yml

features/
    -- awesome.feature
    -- really_great.feature
    -- step_definitions/
        -- domain_concept_a.rb
        -- domain_concept_b.rb
    -- support/
       -- env.rb
       -- blueprints.rb
       -- other_helpers.rb


lib/tasks/cucumber.rake
> rake -T cucumber

!SLIDE bullets incremental transition=fade
# Not just for Rails

- iOS
- Erlang
- Java
- .net
- Selenium
- python
- C++


# Aruba; Cucmber for command line applications

!SLIDE bullets incremental transition=fade

### References
- [Cucumber](http://cukes.info/)
- [WHAT’S IN A STORY?](http://dannorth.net/whats-in-a-story/)
- [Capybara](https://github.com/jnicklas/capybara)
-[ Selenium Browser automation framework](http://code.google.com/p/selenium/)
- [The Cucumber Book](http://pragprog.com/book/hwcuc/the-cucumber-book): Behaviour-Driven Development for Testers and Developers
by Matt Wynne and Aslak Hellesoy
- RailsCasts [#155 Beginning with Cucumber](http://railscasts.com/episodes/155-beginning-with-cucumber)
- RailsCasts [#159 More on Cucumber](http://railscasts.com/episodes/159-more-on-cucumber)

