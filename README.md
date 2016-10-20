xml-tools
=========

Scripts to ease working with XML schemas on OSX and Linux. Works out-of-the box on OSX 
with limxml2-utils from macports.

# Creating an XML Catalog using create_catalog.sh 

create_catalog.sh downloads a bunch of schema's and creates an local XML catalog from them.
It requires xmlcatalog and curl. xmlcatalog is typicially packaged in libxml2-utils.
The generated catalog is used by xmllib2 and xmllint will automatically
when it is stored in a well known location. For a Linux distro, you probrally need 
to update the `CATALOG_LOCATION` and `CATALOG_SHARE` in `create_catalog.sh` first.
You can use "xmllint --help" to find out what this location is on your system. Other
applications (like the Oxygen XML Editor on OSX) can use the catalog as well.

Schema's are downloaded once and stored locally. See create_catalog.sh for the list 
of downloaded schema's and paths.

To create the catalog or to update an existing catalog run: `create_catalog.sh`

## Using the created catalog in Oxygen XML Editor

In the "Oxygen XML Editor" preferences go to XML->XML Schema and under "catalogs" add: 
`file:/opt/local/etc/xml/catalog`

Now XML schema validation and "Show definition" works for XML files that use schema's
that are defined in the catalog.

# xsdvalidate

Validates an XML file against it's schema using the XML catalog to
lookup the schema's used in the XML file by namespace. Requires xmllint.

Use: `xsdvalidate <XML file>`
