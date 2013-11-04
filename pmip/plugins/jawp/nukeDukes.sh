#!/bin/bash
echo Nuking Dukes ...

./pmip/plugins/jawp/pv.exe -f -k java.exe > /dev/null 2>&1
taskkill /F /IM java.exe > /dev/null 2>&1

echo ... All Dukes are dead baby