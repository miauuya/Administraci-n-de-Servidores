#!/usr/bin/env bash

interfaces=$(ip link show)
echo "Interfaces de red disponibles: "
echo $interfaces

echo "Introduzca la interfaz: "
read int

echo "¿Qué desea hacer? 1: up, 0: down"
read answer

if [ $answer -eq 1 ]
then 
	ip link set $int up
	echo "interfaz activada exitosamente"
	echo "¿La interfaz es de tipo cableada o inalámbrica? 1: cableada, 0: inlámbrica" 
	read caboin
	if [ $caboin -eq 1 ]
	then
		"¿La configuración será estática o dinámica? 1: estática, 0: dinámica"
		read estodin
		if [ $estodin -eq 1 ]
		then
			echo "Introduzca la dirección ip con su prefijo: (Ej. x.x.x.x/x)"
			read ipman
			ip addr add $ipman dev $int
			echo "Introduzca la dirección ip del gateway: (Ej x.x.x.x)"
			read gw
			ip route add default via $gw
			/etc/init.d/networking restart
			echo "dirección configurada exitosamente"	
		elif [ $estodin -eq 0 ]
		then 
			sudo dhclient $int
			echo "dirección configurada exitosamente"
		fi
	elif [ $caboin -eq 0 ]
	then 
		echo "Redes disponibles: "
		net=$(iw dev $int scan | grep SSID)
		echo $net
		echo "Introduzca el nombre de la red tal como se muestra: "
		read red
		echo "Introduzca la contraseña: "
		read pswd
		wpa_passphrase $red $pswd | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
		wpa_supplicant -B -i $int -c /etc/wpa_supplicant/wpa_supplicant.conf
		dhclient $int
	fi


elif [ $answer -eq 0] 
then
	ip link set $int down
	echo "interfaz desactivada exitosamente. Para conectarse a la red actívela nuevamente."
fi


