##### Wildbit Java

Responsible for installing and configuring Java. 

Conforming to application and library standard this cookbook augments the [upstream cookbook](https://github.com/socrata-cookbooks/java).

###### Requirements

* Chef (>= 0.11.0)

###### Dependencies

* ark
* java

###### Usage


##### Deprecated

__JMX module__

This module was deprecated as of 0.9.0, suggested to leverage the statistics API as an alternative.

##### Suggestions

__Swapiness__

Currently swapiness is set to 60, this setting will often elect to swap memory to disk even in the case where there is ample (virtual) memory. Recommend to set this setting to "1", allowing the process to be killed instead of swapping.x