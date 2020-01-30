These are some basic notes and modifications of their code explaining Atkeson and Bustein's 2010 JPE paper on "[Innovation, Firm dynamics, and International Trade](http://www.econ.ucla.edu/arielb/innovation.pdf)"

- Basic idea: Lot's of accumulated evidence suggesting importance of the firm as an object of interest in the context of trade. This takes lots of forms, selection into exporting, entry, and innovation processes. The idea is to use a model to understand the importance of these different mechanisms for the gains from trade.

- The model is essentially a Meltiz model with some new stuff...firms can innovate to influence their productivity is the key margin, but an entry margin, and then selection into exporting is incorporated as well. This is all done in the context of a well define GE economy regarding preferences of consumers, etc.

- Here is the key result: Despite all the bells and whistles, the first-order effect from the gains to trade are given by the first part of equation (24), which is the (share of exports in output)x(change in trade costs). Entry stuff, reallocation effects, innovation stuff, this is all second-order. And the second-order stuff is, well, second-order. Hence their punch line statement "microeconomic evidence on firms
responses to changes trade costs may not be informative about...aggregate welfare." Why is this, I think the clearest intuition is about the economy being efficient and then it follows from a direct application of the envelope theorem (see for example footnote 24). Honestly, it's harder for me to follow the intuition of how free-entry has to move to offset stuff in the decentralized equilibrium...maybe I'll figure it out one day (It took me like 10 years to figure this part of AB anyways)

Let's see this in practice... I downloaded the code from [here](http://www.econ.ucla.edu/arielb/innovcodes.zip) and modified it and is in the repository.

---
##### Small change in trade costs
Simply do...
```
>> Master_AB
```
which will run the version of their model with intermediate innovation elasticity (b = 30), compute the welfare gains along the transition path, etc. The default is set for a small change in trade costs. Below I will illustrate the larger change.

**Note:** computing the transition path can take a while but essentially from a welfare perspective the numbers are the same after a couple of iterations. Reducing the tolerance solves this too...

Below are three key outcomes.
```
welfare elasticity = 0.075925 , welfare = 0.0037973 , welfare_direct = 0.0037509
```
The first number is what I will call the welfare elasticity, i.e. how much welfare goes up for a given percent change in trade costs. This is the welfare number they are reporting in the Tables. So the value ``0.0759`` reported above is the same as the ``0.076`` they are reporting in Table 4, column (1), next to last row. It means that the model predicts a one percent decrease in trade costs gives a welfare gain of 0.076 percent. **Note** that their calibrated export share is 0.075, so this is nearly exactly the same as the formula as the "direct effect".

The next two numbers actually report the level of the welfare gains, not the elasticity. For the small trade costs change, the welfare gain is small. The key point to notice is that the direct effect is essentially the same. So all the second order stuff is not playing a large deal.

---

##### Larger change in trade costs

This is where second order stuff might start to matter. Claim is not so much. So go into ``Master_AB`` and comment line 72 and uncomment line 73....
```
%newDratio=0.9995;               % Ratio of new to old D , 0.9995 is the value we use when we consider a small change
newDratio = 0.90; %Mike's 10 percent change...
```
Then run it and let's see what happens
```
>> Master_AB
```
Below are three key outcomes.
```
welfare elasticity = 0.10292 , welfare = 1.0903 , welfare_direct = 0.7902
```
Here the welfare gains are much larger, a ten percent reduction in trade costs gives a 1.1 percent welfare gain. And there is a larger gap between the direct effect and the measured effect, about 0.30 percentage points of welfare (almost a third) is attributed to this. But the overall point remains that the welfare gains are largely pinned down by the direct effect.

**Note:** To replicate their large change, pick the ``newDratio`` to be 0.965 which will replicate the results in Table 5, column (2), next to last row with the 0.083 number. Compared to the result above suggest that the "large change" was not that large.

---

##### Alternative Calibration

One might speculate about different parameter schemes, etc. So what I did was recalibrate their model to mimic the calibration in [Perla, Tonetti, and Waugh](https://www.waugheconomics.com/uploads/2/2/5/6/22563786/ptw.pdf). So specifically, I set the discount factor, elasticity of substitution, the exit rate of firms, and the aggregate import share to be the same as PTW. The firm moments are left the same as in AB. This does require recalibrating the $n_x$ parameter which was done by hand in ``calibrate_nx.m``

Then simply run this...
```
>> Master_ptw
```
And these are the results
```
welfare elasticity = 0.12803 , welfare = 1.358 , welfare_direct = 1.1031
```
which says, ok...first the elasticity is not far from the export share of 0.105, then this calibration delivers a 1.3 percentage point gain from a 10 percentage point reduction in trade costs and most of it is from the direct effect of 1.1 percent. I think this is partly about the discount factor being lower. So even in a very differently calibrated economy, the importance of second-order effects is limited.
