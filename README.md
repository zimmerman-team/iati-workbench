# IATI Workbench

_Scripts and tools to investigate IATI data, provide feedback on data quality,
etc._

The [IATI standard](http://iatistandard.org) offers an XML-based standard format
to exchange information on activities in international development cooperation
and humanitarian aid.

IATI data is published by a variety of actors in this field. The most complete
list of available IATI data sets is held in the [IATI Registry](http://iatiregistry.org).

Working with IATI files poses a couple of challenges:

 *  Multiple versions of the IATI Standard.
 *  Various levels of coverage of the many possible elements.
 *  Plenty of errors and inconsistencies in the data.

There are several tools and platforms that ingest IATI data and make it
available in formats other than XML. There are few tools that will help in
processing IATI data in its original XML format.

This repository intends to collect scripts and applications following the unix
philosophy: do one thing, as part of a processing pipeline.

# Starting

## Required

You will need a couple of tools to make things work:

 *  [Ant](http://ant.apache.org/): a build process manager to perform the steps
    for various tasks.

 *  [BaseX](http://basex.org): an XML database, and XQuery and XPath processor
    (version 8 or higher, with Xquery 3.1 support)

 *  [Saxon HE](https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/):
    XLST 2.0 processing library, to be added to BaseX and used in Ant.
    Put `saxon9he.jar` for instance in `~/.ant/lib`.

## Recommended

Additionally, some tools are useful to have:

 *  [yEd](http://www.yworks.com/products/yed): Graph editor, available as free
    download, and also available as
    [web application](http://www.yworks.com/products/yed-live). This editor is
    used to layout the graphs, and finetune them.

## Directories

In `workspace` you can make folders for each data project.

Once you run any of the tasks for a project, it will create the necessary
folders for the source of your data, the intermediary files, and the output
files generated.

You can also run `ant init -Dproject=my-project` to create those folders (if
needed) for a project in `workspace/my-project`.

The `demo` project contains example data files to illustrate various tasks.

# Operation

Basically, everything is driven by _buid files_ for Ant.

Typing `ant -p` will show information about the main tasks you can do.

Typing something like `ant yed` will perform all the steps needed to transform
the source data in your project into GraphML files that you can edit in yEd.

If it doesn't exist, a file `build.properties` will be created, with the default
project `demo` as active project. To run on another project, you have two
options:

 *  Change the line `project` in `build.properties`
 *  Specify the project on the command line: `ant -Dproject=myproject task`

## Acknowledgements

This product includes:

*  A modified version of [DOTML developed by Martin Loetzsch](http://www.martin-loetzsch.de/DOTML).
*  A modified version of [xquerydoc](https://github.com/xquery/xquerydoc):
    using an adapted version of the xlst stylesheet to transfor xqDoc into HTML

Inspiration from [Kit Wallace's Aidview DB (working with eXist)](https://github.com/KitWallace/AIDVIEW-DB)
