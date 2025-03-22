#!/usr/bin/env bash

# Exit on error
set -e

# @copyright  Copyright 2013 SURFnet bv, The Netherlands
# @author     Pieter van der Meulen <Pieter.vanderMeulen@surfnet.nl>
# @license    http://www.apache.org/licenses/LICENSE-2.0

# Create a catalog (for use with libxml2) of downloaded schemas
# When the catalog file already exists new schemas are added to the catalog
# It is safe to run the script multiple times, or to abort it.

# Specify where to store the catalog using the CATALOG_LOCATION below
# xmllib2 and xmllint (from libxml2-utils) will use the catalog automatically
# when it is stored in a well known location. Use "xmllint --help" to see
# what this location is on your system.
# Other tools (e.g. Oxygen XML Editor) can use the catalog as well, but you
# typically have to configure the location of the catalog in the tool.

# Set CATALOG_SHARE below to the directory to store the downloaded schema's.
# The schemas are referenced in the catalog to that location.

# Requires xmlcatalog and xmllint. These are typically packaged in
# libxml2-utils

# Debian, Redhat, ...
#CATALOG_LOCATION=/etc/xml/catalog            # Location of the catalog file
#CATALOG_SHARE=/usr/local/share/xml           # Directory to store the (downloaded) XML schemas

# OSX macports.org
CATALOG_LOCATION=/opt/local/etc/xml/catalog   # Location of the catalog file
CATALOG_SHARE=/opt/local/share/xml            # Directory to store the (downloaded) XML schemas

#LOCAL_FILE_PREFIX=""
LOCAL_FILE_PREFIX="file://"

# Set the location of LOCAL_SCHEMA_DIR to the schemas directory relative to this script's location
CWD=$(pwd)
cd "$(dirname $0)"
LOCAL_SCHEMA_DIR="file://$(pwd)/schemas"
cd "${CWD}"

# Schemas to add to the catalog. Format:
# <directory in CATALOG_SHARE to store schema>;<Schema download URL>;<Filename for schema on disk>
# lines starting with # are ignored

SCHEMA_DB=$(cat <<EOF
# XML Schema
xml;http://www.w3.org/2001/xml.xsd;xml.xsd

# SAML 2.0 schema's from OASIS
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-assertion-2.0.xsd;saml-schema-assertion-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-2.0.xsd;saml-schema-authn-context-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-auth-telephony-2.0.xsd;saml-schema-authn-context-auth-telephony-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-ip-2.0.xsd;saml-schema-authn-context-ip-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-ippword-2.0.xsd;saml-schema-authn-context-ippword-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-kerberos-2.0.xsd;saml-schema-authn-context-kerberos-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-mobileonefactor-reg-2.0.xsd;saml-schema-authn-context-mobileonefactor-reg-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-mobileonefactor-unreg-2.0.xsd;saml-schema-authn-context-mobileonefactor-unreg-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-mobiletwofactor-reg-2.0.xsd;saml-schema-authn-context-mobiletwofactor-reg-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-mobiletwofactor-unreg-2.0.xsd;saml-schema-authn-context-mobiletwofactor-unreg-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-nomad-telephony-2.0.xsd;saml-schema-authn-context-nomad-telephony-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-personal-telephony-2.0.xsd;saml-schema-authn-context-personal-telephony-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-pgp-2.0.xsd;saml-schema-authn-context-pgp-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-ppt-2.0.xsd;saml-schema-authn-context-ppt-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-pword-2.0.xsd;saml-schema-authn-context-pword-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-session-2.0.xsd;saml-schema-authn-context-session-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-smartcard-2.0.xsd;saml-schema-authn-context-smartcard-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-smartcardpki-2.0.xsd;saml-schema-authn-context-smartcardpki-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-softwarepki-2.0.xsd;saml-schema-authn-context-softwarepki-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-spki-2.0.xsd;saml-schema-authn-context-spki-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-srp-2.0.xsd;saml-schema-authn-context-srp-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-sslcert-2.0.xsd;saml-schema-authn-context-sslcert-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-telephony-2.0.xsd;saml-schema-authn-context-telephony-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-timesync-2.0.xsd;saml-schema-authn-context-timesync-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-types-2.0.xsd;saml-schema-authn-context-types-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-x509-2.0.xsd;saml-schema-authn-context-x509-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-authn-context-xmldsig-2.0.xsd;saml-schema-authn-context-xmldsig-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-dce-2.0.xsd;saml-schema-dce-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-ecp-2.0.xsd;saml-schema-ecp-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-metadata-2.0.xsd;saml-schema-metadata-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-protocol-2.0.xsd;saml-schema-protocol-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-x500-2.0.xsd;saml-schema-x500-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/v2.0/saml-schema-xacml-2.0.xsd;saml-schema-xacml-2.0.xsd
saml;http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-metadata-ui/v1.0/cs01/xsd/sstc-saml-metadata-ui-v1.0.xsd;sstc-saml-metadata-ui-v1.0.xsd
saml;${LOCAL_SCHEMA_DIR}/shibmd-1.0.xsd;shibmd-1.0.xsd

# SOAP schema's
soap;http://schemas.xmlsoap.org/soap/envelope/;soap-envelope-1.1.xsd
soap;http://www.w3.org/2003/05/soap-envelope/;soap-envelope-1.2.xsd

# XML-security schema's
xmlsec;http://www.w3.org/TR/xmldsig-core/xmldsig-core-schema.xsd;xmldsig-core-schema.xsd
xmlsec;http://www.w3.org/TR/2002/REC-xmldsig-core-20020212/xmldsig-core-schema.xsd;xmldsig-core-schema.xsd
xmlsec;http://www.w3.org/TR/xmlenc-core/xenc-schema.xsd;xenc-schema.xsd
xmlsec;http://www.w3.org/TR/2002/REC-xmlenc-core-20021210/xenc-schema.xsd;xenc-schema.xsd

# XACML schema's
xacml;http://docs.oasis-open.org/xacml/2.0/access_control-xacml-2.0-context-schema-os.xsd;access_control-xacml-2.0-context-schema-os.xsd
xacml;http://docs.oasis-open.org/xacml/2.0/access_control-xacml-2.0-policy-schema-os.xsd;access_control-xacml-2.0-policy-schema-os.xsd
xacml;http://docs.oasis-open.org/xacml/2.0/access_control-xacml-2.0-saml-assertion-schema-os.xsd;access_control-xacml-2.0-saml-assertion-schema-os.xsd
xacml;http://docs.oasis-open.org/xacml/2.0/access_control-xacml-2.0-saml-protocol-schema-os.xsd;access_control-xacml-2.0-saml-protocol-schema-os.xsd
xacml;http://docs.oasis-open.org/xacml/3.0/xacml-core-v3-schema-wd-17.xsd;xacml-core-v3-schema-wd-17.xsd

# Garmin GPX schema
gpx;http://www.topografix.com/gpx/1/1/gpx.xsd;gpx-1.1.xsd

# Dutch eHerkenning schema's
eherkenning;${LOCAL_SCHEMA_DIR}/etoegang-1.10-service-catalog.xsd;etoegang-1.10-service-catalog.xsd
eherkenning;${LOCAL_SCHEMA_DIR}/etoegang-1.9-metadata-extension.xsd;etoegang-1.9-metadata-extension.xsd

# Add new schema's here
EOF
)


########################
# Main script starts here
# Check for required commands

for cmd in xmlcatalog xmllint curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found"
        exit 1
    fi
done

if [[ -d $CATALOG_SHARE ]]; then
    echo "$CATALOG_SHARE exists"
else
    echo "$CATALOG_SHARE does not exists or is not a directory"
    exit 1
fi

if [[ -f $CATALOG_LOCATION ]]; then
    echo "$CATALOG_LOCATION exists"
else
	echo "Creating catalog in $CATALOG_LOCATION"
	xmlcatalog --noout --create $CATALOG_LOCATION
fi

# Process SCHEMA_DB
while IFS= read -r line; do
    # Skip lines that start with a #
    if [[ $line == \#* ]]; then
        continue
    fi

    # Skip empty lines
    if [ -z "$line" ]; then
        continue
    fi

    dir=$(echo $line | cut -d';' -f1)
    url=$(echo $line | cut -d';' -f2)
    filename=$(echo $line | cut -d';' -f3)

    schema_location=$CATALOG_SHARE/$dir/$filename

    # When a schema file does not exist, download it
    if [[ ! -f $schema_location ]]
    then
        # Create subdir for schema when required
        if [[ ! -e $CATALOG_SHARE/$dir ]]
        then
            echo "Creating directory $CATALOG_SHARE/$dir"
            mkdir -p "$CATALOG_SHARE/$dir"
        fi

        # Download the schema to a temp file first
        echo "Downloading $url:"
        temp_basename=$(basename $0)
        tempfile=$(mktemp /tmp/${temp_basename}.XXXXXX)
        # Download schema
        # -L follow redirects
        # -# show progress
        curl -L -# "$url" > "$tempfile"

        # Then move schema in place
        mv "$tempfile" $CATALOG_SHARE/$dir/$filename
    fi

    # Add schema to the catalog using download uri
    echo "Adding schemaLocation: <uri name=\"$url\" uri=\"${LOCAL_FILE_PREFIX}$schema_location\"/>"
    echo "xmlcatalog --noout --add uri \"$url\" ${LOCAL_FILE_PREFIX}$schema_location $CATALOG_LOCATION"
    xmlcatalog --noout --add uri "$url" ${LOCAL_FILE_PREFIX}$schema_location $CATALOG_LOCATION

    # Get target namespace from the schema
    target_namespace=$(xmllint "$schema_location" --xpath "string(/child::node()/@targetNamespace)")

    if [[ ! -z "$target_namespace" ]]; then
        # Add schema to the catalog by target namespace
        echo "Adding targetNamespace: <uri name=\"$target_namespace\" uri=\"${LOCAL_FILE_PREFIX}$schema_location\"/>"
        xmlcatalog --noout --add uri "$target_namespace" ${LOCAL_FILE_PREFIX}"$schema_location" $CATALOG_LOCATION
    fi
done <<< "$SCHEMA_DB"

# Done
echo "Done"
echo "Catalog file is $CATALOG_LOCATION"
echo "Schemas are stored in $CATALOG_SHARE"

exit 0