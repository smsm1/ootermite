# Introduction #

Reports are essentially graphs of collected data.  This documents the current methodology of  creating and structure of the reports.  It is envisioned that the method of creation will be from some AJAXy web page in the future, but having this done by OOoCon is at risk to say the least.

# Details #

Firstly, know that Reports can only be created from the Ruby console at present (script/console from the application directory).  If one is to edit on a production system, one must set the environment variable RAILS\_ENV.

Reports have 3 attributes:
  * title
  * traph\_type
  * selectors

Title is the simple title of the graph, such as "SLOC for CWS vs Milestone."  Graph\_type is one of "Bar", "Line", or "Pie".

Selectors is an array of Selector objects.  This array is then serialized into the database.  Selectors can be thought of as generic data sources that input into graphs.

They have several attributes of their own:
  * key
  * label
  * conditions
  * dynamic\_input
  * dynamic\_output

Key is the index of DataItem.data that the selector will use to access numeric data.  For example, consider that you have data hashes as follows:
```
data => { :SLOC => 123456 }
```
The key for such a hash would be :SLOC, as it will yield something that is numeric.  Typical usage would be to use the units of the measurement as the key.

Conditions is a hash that has several conditions that are met that each Build/DataItem (they are joined and the join is abstracted) must meet in order to be in the result set.  This hash is formatted as:
```
  conditions => { :<attribute_name> => [:eq/ne/lt/gt,like, <value>],
                  :order => { :<attribute_name> => "asc"/"desc",
                  :limit => <integer>,
                  :group => :<attribute_name>

```
The order, limit, and group keys are optional.  The attribute names are one of the columns of the builds and data\_items tables.  Of course, multiple attribute names can be present as conditions.

Dynamic variables are a hash that is created at runtime (when the graph is viewed) to add additionally attribute conditions to the constraints.  These dynamic variables only use the equality operator at present.  At run time, dynamic variables can be instantiated either by the URL (reports/

<report\_id>

?variable0=value&variable1=value&...) or may be instantiated by selectors as they produce their result set.  Dynamic variables do not necessarily carry the name of the attribute.  This will be come more clear in the next few sections.

dynamic\_inputs is a hash of dynamic variables that will be added to the attributes condition hash at run time with the values interpolated.  These take the form of:
```
{ dynamic_variable_name => attribute_name }
```
The attributes conditions hash will have 

<attribute\_name>

 => [:eq, dynamic\_variables[dynamic\_variable\_name](dynamic_variable_name.md)

dynamic\_outputs is a hash in the reverse order, outputting the **first** result set item into the dynamic\_variables hash.  They take the reverse form as above:
```
{ attribute_name => dynamic_variable_name }
```

Care must be used to avoid making circular dependencies.  This dynamic variable system allows one to create graphs such as CWS vs Milestone type graphs.  Such graphs have two selectors, one which takes cws from the URL as a dynamic input and sets the milestone dynamic variable.  The second selector finds the milestone based on the dynamic variable outputted by the first one.

Labels are either string or dynamic variable names that are used to label the data source.    If the label is a dynamic variable name, it will be interpolated.

# Example #
This example documents the SLOC CWS vs Milestone report.  A dump of the Report object follows
```
Title: SLOC of CWS vs Milestone
Type: Bar
Selectors: [
  Selector 0:
    dynamic_inputs= { :cws => :cws }
    dynamic_outputs= { :pws => :milestone }
    conditions= {
                 attributes=>{ 
                              :data_type => [:eq, "sloccount"]
                             }
                 limit=>1
                 order=>{ :created_at => :desc },
                 } 
     label= :cws
     key="SLOC"
  Selector 1:
    dynamic_inputs={:milestone=>:cws}
    conditions = {
                  :attributes => { 
                                    :cws => [:eq, "SRC680_m217"], 
                                    :data_type=>[:eq, "sloccount"]}, 
                  :limit => 1
                  order => { :created_at => :desc }
                  } 
     label=:milestone
     key="SLOC"
]
```

