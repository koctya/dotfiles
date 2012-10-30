## A user story is to a use case as a gazelle is to a gazebo
- [Alistar Cockburn](http://alistair.cockburn.us/)
>  I concluded that the answer is,
After the first three letters, they have nothing in common.

I’ve tried answering this question so many times and in so many ways: “What’s the difference between a use case and a user story?”
I know what each is, I know how to describe each; I’ve described each and even how to relate the two. I’ve finally concluded that a user story is to a use case as a gazelle is to a gazebo.
See if you can describe the difference without just enumerating what each is.
As the Mad Hatter asked: “Why is a raven like a writing desk?”

A better answer is A user story is the title of one scenario whereas a use case is the contents of multiple scenarios (discussion: Re: A user story is the title of one scenario whereas a use case is the contents of multiple scenarios).

> Why is a raven like a writing desk?, asked Lewis Caroll in “Alice Through the Looking Glass”
Because each begins with ‘e’ (is the accepted answer)

> What’s the difference between a user story and a use case?, asks almost everyone
— silence follows — (because there is no accepted answer)

###
User Story is simply, a user’s story. It is business ppl’s version of describing the world, their way of “starting an idea”
basically starting a conversation (requirements elicitation) of whether their idea (to get some business benefit) is
feasible?
Stories should be simple and business-focussed, because when faced with complex things which make profit & loos look like a
gamble, human mind always wants to cut through all crap and see things in simple and convincing way.
“Divide & Conquer” the most intuitive of human manipulation skills can be applied with Stories so you can break or merge
stories as well.
Let the “user” (the business man) freely express his idea, uninfluenced and undeterred by “system-hardened” developers.
Once he has spoken completely, which means the Story has been written (in say half an hour), then is the time to “start the
conversation” which means start scrutinising the idea, check its feasibility, uncover missing links/detail, design, plan and
when sufficient confidence and consensus exists, make it a decision. The Story can undergo some changes, but still is in a
format that is simple. It is better if it restricts to WHAT and not tries to do HOW.
System ppl or Techies model a complex “real world” into a virtual software world for manupulation, so they will have to
analyse the Story to death. Basically as the software does not have a mind of its own, it needs to be told everything
preciserly and hence what is very simply said in a Story then has to become elaborate and formal so that it can be
implemented.

Welcome to the realm of Use-Cases. Systems folks will have to analyse and carry out “thought-experiment” and conceive how
their system (black-box) should precisely work in order to realise the agreed Story. And Use-Cases are a very effective tool
to do that.

1 User Story can relate to 1 or multiple Use-Cases. And they may realte only to some parts of these use-cases,
simultaneously (they are being written by someone who doesnt know what use-cases are)
If there is a science of Modelling a real-world in abstract way e.g. Software then -
it will perhaps say Use-Cases is what will happen to the system in consideration.
Thus Use-Cases are the “Stories” of that System, when viewed with the business benefit.
So fundamentally given a concrete system definition, finite actors and Business Logic Rules that dont contradict Computation
Theory, there is a finite (but large) set of possibilities that can occur and they group together as Scenarios and
Use-Cases. Use-Cases are something really fundamental, but only when considered from a Modelling perspective.
But surely when Stories are written all these complex thoughts cannot be factored in, and not required as well, lest
Business ppl will lose the focus. Also Business ppl dont have that expertise or outlook and why should they? 1 Human Brain
cannot do all these varied things in reasonable time. Thinking about everything at once is only a fantasy.
If Business ppl were “system-intelligent” then they would write User-Stories that perfectly mapped with Use-Cases or could
write use-cases themselves. Then systems ppl are not reqd to be “domain-intelligent” they need to be just dumb coders. May
be robots could do the coding job!!!
Thankfully or otherwise that is not tru. In reality, its actually a team-effort: Business ppl with business intelligence,
Technical ppl with system intelligence.
Yes maybe with training and experience, Business ppl can write good stories that are more prone to be easily mapped to the
systems, but that is really a bonus.

THUS USER STORIES AND USE CASES IS A QUESTION ONLY FROM SYSTEMS’ PERSPECTIVE, THE “USER” ONLY KNOWS “USER STORIES”. IT IS
NOT THE SAME AS USE-CASES AND ARE NOT THE MEANS TO DO SYSTEMS ANALYSIS, THEY ARE JUST AN SIMPLE ABSTRACTION OF USE-CASES FOR
BUSINESS USERS.
YOU NEED BOTH!!!
-by Nikhil Shah on 3/5/2009 at 12:58 PM

### i
A User Story summarises the user goal, what they want and why they want it. A Use Case elaborates how that goal may, or may not, be achieved.
To be mischevious surely any explanation taking more than two or three sentences isn’t “Agile”? :-)

##### User Story
“As an engaged reader I want to be able to leave comments on Alistair’s blog so he gets quality feedback from intelligent and erudite readers.”

Use cases; User will

1. Leave a name (Mandatory) because we like to know who is saying what
2. Leave an email address so Alistair can contact the poster
3. Leave text comments
4. Human verification to eliminate spam
