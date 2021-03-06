#!/bin/sh
[ $$ -eq 1 ] && exec tini -g -- sh "$0" "$@"

HOSTNAME=$(hostname -s)

NVRAM=${NVRAM:-64}
MEM=${MEM:-256}

cd /iou || exit

# disable IPv6 and set MTU to 9000, count interfaces
eth_ifs=0
for if_eth in $(sed -n 's/^ *\(eth[0-9]*\):.*/\1/p' /proc/net/dev); do
	ifconfig "$if_eth" down
	sysctl -q -w "net.ipv6.conf.${if_eth}.disable_ipv6=1"
	ifconfig "$if_eth" mtu 9000 up
	eth_ifs=$((eth_ifs + 1))
done

# update /etc/hosts
if ! grep -q -w -F "gns3vm" /etc/hosts; then
	printf '127.0.1.2\tgns3vm\n' >> /etc/hosts
	printf '127.0.0.127\txml.cisco.com\n' >> /etc/hosts
fi

# create router ID
ID=$(echo "$ID" | grep -o '[0-9-]*$')
[ -z "$ID" ] && ID=0x$(echo "$HOSTNAME" | md5sum | grep -o '^................')
ID=$((ID % 997))
[ $ID -le 0 ] && ID=$((ID + 997))
nvram_file=$(printf "nvram_%05d" $ID)
find nvram_* ! -name "$nvram_file" -print0 2>/dev/null | xargs -0 -r rm

# create NETMAP and iouyap.ini
printf '' > NETMAP
printf "[default]\nbase_port = 49000\nnetmap = NETMAP\n\n" > iouyap.ini

ser_ifs=$((SERIAL + 0))
[ $ser_ifs -gt $eth_ifs ] && ser_ifs=$eth_ifs
eth_ifs=$((eth_ifs - ser_ifs))
eth_cntr=$(( (eth_ifs + 3) / 4))
ser_cntr=$(( (ser_ifs + 3) / 4))

if=0
while [ $if -lt $eth_ifs ]; do
	if_iou=$((if / 4))/$((if % 4))
	printf "%d:%s %d:%s\n" 1000 "$if_iou" $ID "$if_iou" >> NETMAP
	printf "[%d:%s]\neth_dev = eth%d\n\n" 1000 "$if_iou" $if >> iouyap.ini
	if=$((if + 1))
done

if=0
while [ $if -lt $ser_ifs ]; do
	if_iou=$((eth_cntr + (if / 4) ))/$((if % 4))
	printf "%d:%s %d:%s\n" 1000 "$if_iou" $ID "$if_iou" >> NETMAP
	printf "[%d:%s]\neth_dev = eth%d\n\n" 1000 "$if_iou" $((eth_ifs+if)) >> iouyap.ini
	if=$((if + 1))
done

# first run: replace %h by hostname in config files
if [ ! -f "$nvram_file" ]; then
	[ -f startup-config ] && sed -i "s/%h/$HOSTNAME/g" startup-config
	[ -f private-config ] && sed -i "s/%h/$HOSTNAME/g" private-config
fi

# update NVRAM
if [ -f startup-config ]; then
	[ -f private-config ] && private="private-config" || private=""
	nv_size=0
	[ -f "$nvram_file" ] && nv_size=$(($(stat -c %s "$nvram_file") / 1024))
	if [ "$NVRAM" -eq $nv_size ]; then
		iou_import "$nvram_file" startup-config $private
	else
		iou_import -c "$NVRAM" "$nvram_file" startup-config $private
	fi
fi

# start IOU
hostname gns3vm
stty intr undef quit undef susp undef
sig_term=
trap "sig_term=1" TERM
iouyap 1000 > iouyap.log 2>&1 &
iou.bin -e $eth_cntr -s $ser_cntr -n "$NVRAM" -m "$MEM" $ID

# export configs from NVRAM
iou_export "$nvram_file" startup-config private-config
[ -f private-config ] && [ "$(stat -c "%s" private-config)" -le 5 ] && \
	rm private-config

# don't close, if IOU is not terminated by SIGTERM (docker stop)
if [ -z "$sig_term" ]; then
	printf "\nQuit... "
	read -r
fi
