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

You will need [Docker](http://docker.io/), a container management tool.
All tools for the IATI Engine are packaged in a container that you can run as a command.

For now, you can build your own local version of the container using the
Dockerfile provided:

`docker build -t iati-engine:latest docker/iati-engine`

Next, you can put the `iati-engine` script in your path,
for instance as a symlink:

`ln -s iati-engine ~/bin/iati-engine`

Then, verify everything is running:

`iati-engine -p`

The engine will run Ant by default, but it is also possible to access a shell:

* `iati-engine` without parameters will start a bash shell as the current user on the host system.
* `iati-engine root [command]` will run the shell or the given command in a shell as root.
* `iati-engine bash [command]` will run the shell or the given command in a shell as the current user.
* `iati-engine <target/option>*` will run Ant with the given target or option(s).

## Recommended

### Bash command line autocompletion

If you want to use Bash command line autocompletion, include `iati-engine_completion`,
for instance in your `~/.bashrc` file. If you upgrade the IATI Engine, you may need
to re-run `iati-engine_completion` to have new build targets available for autocompletion.

### Named volume `iati-data` for BaseX database

The engine contains BaseX, an XML database platform. The Docker container will
bind a named volume called `iati-data` to the container. If this volume contains
a folder `IATI` with the BaseX database files, you can use the engine to run
queries against that database.

### Editing graphs with yEd

[yEd](http://www.yworks.com/products/yed): Graph editor, available as free
download, and also available as
[web application](http://www.yworks.com/products/yed-live). This editor is
used to layout the graphs, and finetune them.

## The engine

Some background: the engine uses Ant, a software build manager, and every
task is written as an Ant target, depending on internal targets for
intermediary steps. Since several intermediary steps are used for multiple
tasks, and intermediary results are kept, the engine can use these to
speed up its operation.

Basically, when you run the engine, it runs Ant: all your command line
parameters are passed to Ant. If you run `iati-engine -?` you will get
the Ant help information.

Core tools:

*  [Ant](http://ant.apache.org/): a build process manager.
*  [BaseX](http://basex.org): an XML database, and XQuery and XPath processor.
*  [Saxon HE](http://www.saxonica.com/download/opensource.xml):
 XLST 2.0 processing library.


## Workspaces

You run the engine in a folder that will function as the 'workspace'.
You specify the task you want performed, and the engine will take all steps
needed to transform the source data into the desired output formats.

Once you run any of the tasks, it will create the necessary folders
for the source of your data, the intermediary files, and the output
files generated.

You can run `iati-engine init` to create those folders yourself.

The `workspace` folder contains example data files to illustrate various tasks.

# Operation

Typing `iati-engine -p` will show information about the main tasks you can do.

Typing `iati-engine yed` will perform all the steps needed to transform
the source data in your project into GraphML files that you can edit in yEd.

## Acknowledgements

First inspiration came from [Kit Wallace's Aidview DB (working with eXist)](https://github.com/KitWallace/AIDVIEW-DB)
