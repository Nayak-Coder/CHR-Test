# 2026-01-01 15:41:57 by RouterOS 7.20.6
# system id = Pq2VOJxxL/O
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether2
set [ find default-name=ether2 ] disable-running-check=no name=ether3
/ip hotspot profile
add dns-name=hotspot.local hotspot-address=192.168.10.1 name=hsprof1
/ip pool
add name=hs-pool ranges=192.168.10.10-192.168.10.100
/ip hotspot
add address-pool=hs-pool disabled=no interface=ether2 name=hotspot1 profile=\
    hsprof1
/ip settings
set max-neighbor-entries=16384
/ipv6 settings
set max-neighbor-entries=8192 min-neighbor-entries=2048 \
    soft-max-neighbor-entries=4096
/ip address
add address=192.168.56.2/24 interface=*2 network=192.168.56.0
add address=192.168.10.1/24 interface=ether2 network=192.168.10.0
/ip dhcp-client
# Interface not active
add interface=*2
/ip dhcp-server
add address-pool=hs-pool interface=ether2 name=dhcp1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8 gateway=192.168.10.1
/ip dns
set servers=8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=forward comment="Block HTTPS to 1.1.1.1" dst-address=\
    1.1.1.1 dst-port=443 protocol=tcp
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.10.0/24
/ip hotspot user
add name=admin
