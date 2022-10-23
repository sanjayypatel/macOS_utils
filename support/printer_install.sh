#!/bin/bash

# Examples. Provide script paramters with NO QUOTES and NOT ESCAPED.
#printerName=Printer-01
#printerLocation=Building-Room
#printerURI=lpd://1.1.1.1
#printerPPD=/Library/Printers/PPDs/Contents/Resources/CNPZUIRAC3530ZU.ppd.gz
# ^ example location of a Canon Print Driver

echo "Provide printer info with NO QUOTE and NOT ESCAPED."
echo "===== ===== ===== ====="
echo "Provide printer name. Example: Canon_iR-ADV_C3530"
echo "Printer Name:"
read printerName
echo "===== ===== ===== ====="
echo "Provide printer location. Example: 79NM_311"
echo "Printer Location:"
read printerLocation
echo "===== ===== ===== ====="
echo "Provide Printer URI. Example: lpd://10.1.30.49"
echo "PrinterURI:"
read printerURI
echo "===== ===== ===== ====="
echo "Provide printer PPD path. Example: /Library/Printers/PPDs/Contents/Resources/CNPZUIRAC3530ZU.ppd.gz"
echo "Printer PPD:"
read printerPPD
echo ""
echo "===== ===== ===== ====="
echo "Installing printer:"
echo $printerName
echo $printerLocation
echo $printerURI
echo $printerPPD

# add specified printer
/usr/sbin/lpadmin -p "${printerName}" -v "${printerURI}" -P "${printerPPD}" -L "${printerLocation}" -o printer-is-shared=false -E

echo "Finished adding printer: " $printerName