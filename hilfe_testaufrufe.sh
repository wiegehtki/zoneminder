#!/usr/bin/env bash

echo "Testszenarien:"
echo "=============="
echo "Api-Test"
echo "https://zm.wiegehtki.de/zm/api/host/getVersion.json"
echo "Erkennung-Tests"
echo "https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=snapshot"
echo "https://zm.wiegehtki.de/zm/?view=image&eid=<EVENTID_EINSETZEN>&fid=alarm"
echo "sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid <EVENTID_EINSETZEN> --monitorid <EVENTID_EINSETZEN> --debug"
