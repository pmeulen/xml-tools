xml-tools
=========

Scripts to ease working with XML schemas on OSX and Linux. Should work
out-of-the box on OSX.

# create_catalog.sh

Downloads a bunch of schema's a creates an local XML catalog of them.
Schema's are downloaded once and stored locally.
The created XML catalog works xmllib2
See create_catalog.sh for the list of downloaded schema's and paths.

Use: `create_catalog.sh`

## Use the created catalog in Oxygen XML Editor

In options go to XML->XML Schema and add: `file:/opt/local/etc/xml/catalog`

Now schema validation and "Show definition" works for XML files that schema's
that are defined in the catalog.

# xsdvalidate

Validates an XML file against it's schema using the XML catalog to
lookup the schema's used in the XML file by namespace.

Use: `xsdvalidate <XML file>`
