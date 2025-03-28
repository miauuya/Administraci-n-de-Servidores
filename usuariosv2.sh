#!/usr/bin/env bash

crearUser() {
	read -p "Nombre de usuario: "  user
	
	if ! id "$user" &> /dev/null; then
		read -p "Comentario: " comment
		read -p "Directorio del usuario: " dir
		read -p "Nombre del directorio del usuario: " userdir
		
		while true; do
		read -s -p "Contraseña: " psswd
		echo ""
		if [[ ${#psswd} -ge 10 && "${psswd}" == *[A-Z]* && "${psswd}" == *[a-z]* && "${psswd}" == *[0-9]* ]]; then
			read -s -p "Vuelva a escribir la contraseña: " passwd2
			if test "$psswd" == "$passwd2"; then
				break
			else
				echo "Las contraseñas no coinciden"
			fi
		else
			echo "Contraseña inválida: debe contener al menos 10 caracteres, una mayúscula, una minúscula y un número"
		fi
		done

		useradd "$user" -c "$comment" -m -d "$dir/$userdir" -s /bin/bash
		echo "$user:$psswd" | chpasswd
		chown "$user" "$dir/$userdir"
		echo "Usuario creado con éxito. Los valores del usuario fueron asignados por defecto, para más modificaciones consulte man usermod"
		asignarCuota "$user"
	else
		echo "Usuario existente"
	fi
}

asignarCuota() {
	local user="$1"
	echo "¿Desea asignarle cuota al usuario? [y/n]"
	read opCuota
	case $opCuota in
		'y' )
			read -p "Cantidad de cuota soft: " soft
			read -p "Cantidad de cuota hard: " hard
			setquota -u "$user" $soft $hard 0 0 / 
			agregarSudo "$user"
		;;
		'n' )
			agregarSudo "$user"
		;; 
		* )
			echo "Opción inválida"
			exit 1
	esac
}


agregarSudo() {
	local user="$1"
	echo "¿Desea agregarle al usuarios permisos de ejecución? [y/n]"
	read opSudo
	case $opSudo in
		'y' )
			read -p "¿Desea asignar permisos especiales? [y/n]" perm

			if [[ "$perm" == 'y' ]]; then
				echo "Introduzca los comando a los que se van a otorgar permisos? [separador con comas y espacio]"
				read "comandos"

    				echo "$user ALL=(ALL) $comandos" > /tmp/permisos_"$user"
				cp /tmp/permisos_"$user" /etc/sudoers.d/.
			else
				echo "$user ALL = (ALL) ALL" > /tmp/permiso_"$user" 
				cp   /tmp/permiso_"$user" /etc/sudoers.d/.
			fi
		;;
		'n' )
			return 0
		;;
	esac
}



borrarUser() {
	read -p "Usuario que desea eliminar: " user
	if ! id "$user" &> /dev/null; then
		echo "El usuario no existe"
	else
		deluser "$user"
		rm /etc/sudoers.d/permisos_"$user"
		read -p "¿Desea eliminar la carpeta del usuario? [y/n] " opcion
		if test "$opcion" == "y"; then
			read -p "Introduzca la ruta a la carpeta del usuario: " dir
			rm -r "$dir"
		fi
	fi	
}		

select op in "crear" "borrar" "salir"; do
	if [ "$op" = "crear" ] ; then
		crearUser; exit
	elif [ "$op" = "borrar" ]; then
		borrarUser; exit
	elif [ "$op" = "salir" ]; then
		exit
	fi
done
