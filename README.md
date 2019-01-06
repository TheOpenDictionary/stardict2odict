stardict2odict
==============

This tiny utility converts StarDict dictionaries to ODict XML (ODXML), which can then be compiled to a binary ODict dictionary using [the ODict compiler](https://github.com/odict/odict). 

The StarDict file format is rather convoluted and requires *multiple*, that's right, ***multiple*** files in order to run. It's also pretty poorly documented. The only documentation you'll find about it is scattered across the internet, but [here](https://code.google.com/p/babiloo/wiki/StarDict_format) is a pretty good explanation linked to from the [repo this code was based on](https://github.com/wyage/star-dict-parser) (pfff like we'd really write a StarDict parser ourselves... *please*). 

How to Use
----------
> Before you begin, be sure to download and install [Bazel](https://bazel.build)

Running the program is very simple. There's two ways you can use it:

### 1. With a Single Argument
By simply providing the path to a StarDict archive, the CLI will return an example HTML entry stored in that file that will help you in crafting the regex for conversion. Here's an example:

```
$ bazel run ./babylon-korean-english.tar.bz2
Processing dictionary file...
Found example entry HTML: <font color="blue">adj.</font> aspen
```

As you can see, the definitions for this dictionary generally contain the part of speech abbreviation inside a `<font>` 
tag, while the actual definitions are listed after the `<font>` tag is closed. This may result in the following regex:

`<font color="blue">([a-z]+?)\.</font>\s*(.*?)$`

This will match the lowercase part of speech abbreviation within the font tag, as well as the definition list. 

### 2. With Two Arguments
By providing two arguments to the CLI, you can convert a StarDict archive into ODXML. This conversion requires a 
configuration YAML file in order to work. The configuration consists of four primary keys: `name` (the name of the 
output dictionary), `delimiter` (the delimiter between definitions... usually either a comma or semicolon), `regex` (
the regex string used to match groups in entries), and `match` (a set of rules for matching attributes to groups, 
see below). 

Currently, the `match` rules support the `pos` (part of speech), `definition`, `alt` (alternative form), and
`romanization` keys.

An example configuration file might look like:

```yaml
# config.yml
name: Babylon Chinese - English
delimiter: ,
regex: <font color="blue">([a-z]+?)\.</font>\s*\(<I>\w+?</I>=(.*?)<I>,\s*Pinyin</I>=(.*?)\)\s*(.*?)
match: # Each number corresponds to a 1-based group number in the above regex
  pos: 1 
  alt: 2
  romanization: 3
  definition: 4
```  

Now, to convert the file to ODXML using the following command:

```bash
$ bazel run ./zh_en.tar.bz2 ./zh_en.xml --config config.yml 
```