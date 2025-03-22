xml-tools
=========

Scripts to make working with XML schemas simpler on OSX and Linux by generating an XML Catalog. 
The scripts works out-of-the box on OSX with `limxml2-utils` from [macports](https://www.macports.org/).
It should be easy to adapt to other systems by changing the paths in `create_catalog.sh`.

# Creating an XML Catalog using create_catalog.sh 

`create_catalog.sh` downloads a bunch of schema's and creates an local XML catalog from them.
It requires `xmlcatalog` and `curl`. `xmlcatalog` is typically packaged in `libxml2-utils`.
The generated catalog is used by `xmllib2` and `xmllint` will automatically be used
if it is stored in a well known location. 

Schema's are downloaded once and stored locally. See `create_catalog.sh` for the list
of downloaded schema's and paths, and update it to your needs.

## Installation on other systems
For a Linux distro, you probably need to update the `CATALOG_LOCATION` and `CATALOG_SHARE` 
in `create_catalog.sh` first so the catalog is stored in a location that is used by `xmllint`.
You can use `xmllint --help` to find out what this location is on your system. 

To create the catalog or to update an existing catalog run: `create_catalog.sh`

# Using the created catalog in Oxygen XML Editor

In the "Oxygen XML Editor" preferences go to XML->XML Schema and under "catalogs" add: 
`file:/opt/local/etc/xml/catalog`

Now XML schema validation and "Show definition" works for XML files that use schema's
that are defined in the catalog.

# Using the included `xsdvalidate` script

`xsdvalidate` validates an XML file against it's schema using the XML catalog to
lookup the schema's used in the XML file by namespace. Requires `xmllint`.

Use: `xsdvalidate <XML file>`
