#!/bin/bash

# wrapper_fqdns.sh - v0.2.1
# Can be called from CLI or from EdgeOS scheduler. See README.md for more infos.

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
# Absolute path to this script's directory
SCRIPTPATH=$(dirname "$SCRIPT")

# Declaring wrappers variables fromn Vyatta
vop=/opt/vyatta/bin/vyatta-op-cmd-wrapper
vcfg=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper

IN_DESC_V4=$($vop show configuration commands | grep -i "^set firewall group address-group FQDN-.* description .*$")
IN_ADDR_V4=$($vop show configuration commands | grep -i "^set firewall group address-group FQDN-.* address .*$")

# Load the python code in the wrapper
PYTHON_CODE=$(cat ${SCRIPTPATH}/fqdns_v4.py)

# Run the Python code and capture output. Output will contain EdgeOS configuration lines.
OUTPUT_V4="$(python -c "$PYTHON_CODE" "$IN_DESC_V4" "$IN_ADDR_V4")"

IN_DESC_V6=$($vop show configuration commands | grep -i "^set firewall group ipv6-address-group FQDN-.* description .*$")
IN_ADDR_V6=$($vop show configuration commands | grep -i "^set firewall group ipv6-address-group FQDN-.* ipv6-address .*$")

# Load the python code in the wrapper
PYTHON_CODE=$(cat ${SCRIPTPATH}/fqdns_v6.py)

# Run the Python code and capture output. Output will contain EdgeOS configuration lines.
OUTPUT_V6="$(python -c "$PYTHON_CODE" "$IN_DESC_V6" "$IN_ADDR_V6")"

# Run each configuration line in EdgeOS shell.
echo "V4:"
echo "$OUTPUT_V4"
echo "V6:"
echo "$OUTPUT_V6"

echo "$OUTPUT_V4" |
{
  # Enter in configuration mode
  $vcfg begin
  while IFS= read -r line ; do logger $line ; $vcfg $line ; done ;
  # Commit then exit
  $vcfg commit
  $vcfg end
}

echo "$OUTPUT_V6" |
{
  # Enter in configuration mode
  $vcfg begin
  while IFS= read -r line ; do logger $line ; $vcfg $line ; done ;
  # Commit then exit
  $vcfg commit
  $vcfg end
}
[edit]
admin@NL-GR-RT-01# exit
exit
admin@NL-GR-RT-01:/config/user-data/scripts$ ls
config-backup           fqdns_v4.py             fqdns_v6.py             wrapper_fqdns_v4_v6.sh
admin@NL-GR-RT-01:/config/user-data/scripts$ cat wrapper_fqdns_v4_v6.sh
#!/bin/bash

# wrapper_fqdns.sh - v0.2.1
# Can be called from CLI or from EdgeOS scheduler. See README.md for more infos.

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
# Absolute path to this script's directory
SCRIPTPATH=$(dirname "$SCRIPT")

# Declaring wrappers variables fromn Vyatta
vop=/opt/vyatta/bin/vyatta-op-cmd-wrapper
vcfg=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper

IN_DESC_V4=$($vop show configuration commands | grep -i "^set firewall group address-group FQDN-.* description .*$")
IN_ADDR_V4=$($vop show configuration commands | grep -i "^set firewall group address-group FQDN-.* address .*$")

# Load the python code in the wrapper
PYTHON_CODE=$(cat ${SCRIPTPATH}/fqdns_v4.py)

# Run the Python code and capture output. Output will contain EdgeOS configuration lines.
OUTPUT_V4="$(python -c "$PYTHON_CODE" "$IN_DESC_V4" "$IN_ADDR_V4")"

IN_DESC_V6=$($vop show configuration commands | grep -i "^set firewall group ipv6-address-group FQDN-.* description .*$")
IN_ADDR_V6=$($vop show configuration commands | grep -i "^set firewall group ipv6-address-group FQDN-.* ipv6-address .*$")

# Load the python code in the wrapper
PYTHON_CODE=$(cat ${SCRIPTPATH}/fqdns_v6.py)

# Run the Python code and capture output. Output will contain EdgeOS configuration lines.
OUTPUT_V6="$(python -c "$PYTHON_CODE" "$IN_DESC_V6" "$IN_ADDR_V6")"

# Run each configuration line in EdgeOS shell.
echo "V4:"
echo "$OUTPUT_V4"
echo "V6:"
echo "$OUTPUT_V6"

echo "$OUTPUT_V4" |
{
  # Enter in configuration mode
  $vcfg begin
  while IFS= read -r line ; do logger $line ; $vcfg $line ; done ;
  # Commit then exit
  $vcfg commit
  $vcfg end
}

echo "$OUTPUT_V6" |
{
  # Enter in configuration mode
  $vcfg begin
  while IFS= read -r line ; do logger $line ; $vcfg $line ; done ;
  # Commit then exit
  $vcfg commit
  $vcfg end
}