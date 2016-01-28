#!/bin/bash

echo -e "-------------------------------------------"
echo -e "	VPN Spoke config"
echo -e "-------------------------------------------\n"

echo -e "Provide Customer ID: "
read cus_id
echo -e "Provide spoke-ID: "
read spoke_id
echo -e "Provide GW IP: "
read gw_ip
echo -e "Provide Customer Subnet: "
read cust_subnet
echo -e "Provide Customer Subnet Mask: "
read cust_subnet_mask
echo -e "Provide VPN IP: "
read vpn_ip
echo -e "Provide Tunnel 30.20 IP:"
read tun_20
echo -e "Provide Tunell 30.30 IP: "
read tun_30


echo -e "\n-------------------------------------------"
echo -e "	You gave me :"
echo -e "-------------------------------------------\n"
echo -e "Hostname: " $cus_id-spoke-$spoke_id
echo -e "GW IP:" $gw_ip
echo -e "Customer Subnet IP: " $cust_subnet
echo -e "Customer Subnet Mask: " $cust_subnet_mask
echo -e "VPN IP : " $vpn_ip
echo -e "Tunnel 30.20 IP: " $tun_20
echo -e "Tunnel 30.30 IP: "$tun_30


echo -e "-------------------------------------------"
echo -e "	Is that correct ?"
echo -e "-------------------------------------------\n"
select yn in "Yes" "No"; do
	case $yn in
		Yes ) cp template $cus_id-spoke-$spoke_id; 
			sed -i 's/hostname XXXXX-spoke-XX/hostname '$cus_id'-spoke-'$spoke_id'/g' ./$cus_id-spoke-$spoke_id
			sed -i 's/ip address 10.0.23x.x 255.255.255.255/ip address '$vpn_ip' 255.255.255.255/g' $cus_id-spoke-$spoke_id
			sed -i 's/ip address 172.30.2x.x 255.255.254.0/ip address '$tun_20' 255.255.254.0/g' $cus_id-spoke-$spoke_id
			sed -i 's/ip address 172.30.3x.x 255.255.254.0/ip address '$tun_30' 255.255.254.0/g' $cus_id-spoke-$spoke_id
			B=`ipcalc $cust_subnet/$cust_subnet_mask | awk 'NR==2 {print $2}'`
			sed -i 's/ip address 10.230.x.x 255.255.255.2x/ip address '$gw_ip' '$B'/g' $cus_id-spoke-$spoke_id
			sed -i 's/network 10.0.23X.X 0.0.0.0/network '$vpn_ip' 0.0.0.0/g' $cus_id-spoke-$spoke_id
			A=`ipcalc $cust_subnet/$cust_subnet_mask | awk 'NR==3 {print $2}'`
			sed -i 's/network 10.230.X.X 0.0.0.X/network '$cust_subnet' '$A'/g' $cus_id-spoke-$spoke_id
		break;;
		No ) exit;;
	esac
done
