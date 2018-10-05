#!/bin/sh

if [ $# -gt 0 ];
then
        while getopts "p:k:m:O:o:" arg;
                do
                        case $arg in
                                p)
                                        sed -i "3,12s/^.*\"port\":.*$/        \"port\": ${OPTARG},/" mudb.json
                                ;;
                                k)
                                        sed -i "3,12s/^.*\"passwd\":.*$/        \"passwd\": \"${OPTARG}\",/" mudb.json
                                ;;
                                m)
                                        sed -i "3,12s/^.*\"method\":.*$/        \"method\": \"${OPTARG}\",/" mudb.json
                                ;;
                                O)
                                        sed -i "3,12s/^.*\"protocol\":.*$/        \"protocol\": \"${OPTARG}\",/" mudb.json
                                ;;
                                o)
                                        sed -i "3,12s/^.*\"obfs\":.*$/        \"obfs\": \"${OPTARG}\",/" mudb.json
                                ;;
                        esac
                done
fi
cat mudb.json | awk '$1=="\"port\":" {print $NF+0}' | awk '$NF<=65535' > /root/mudb_port.txt

echo -n "" > /rinetd.conf
while read line
do
        echo "0.0.0.0 $line 0.0.0.0 $line" >> /rinetd.conf
done < /mudb_port.txt

nohup /rinetd_bbr_powered -f -c /rinetd.conf raw venet0 > bbr.log 2>&1 &
nohup python /shadowsocksr-akkariiin-dev/shadowsocks/server.py -p 17520 -k Ssr123456 -m rc4 -O auth_chain_e -o plain > ssr.log 2>&1 &
