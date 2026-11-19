#!/bin/bash -xv

vms=($(incus list -f csv -c n))

for vm in "${vms[@]}"; do
    mkdir -p "${vm}"
    incus start "${vm}"
    incus exec "${vm}" cat /etc/os-release
    incus exec "${vm}" "ss -tnl" > "${vm}/ss-tnl.txt"
    incus exec "${vm}" "ss -unl" > "${vm}/ss-unl.txt"
    incus exec "${vm}" "df -h"   > "${vm}/df-h.txt"
    incus exec "${vm}" "free-h"  > "${vm}/free-h.txt"
    incus exec "${vm}" "ip -br -c -4 address" > "${vm}/ip-br-c-4-address.txt"
done

