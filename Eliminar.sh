#!/bin/bash
echo "Introduzca la ruta absoluta del archivo a eliminar"
read archivo

echo "¿Está seguro que quiere eliminar este archivo? 1/0"
read answer

if (($answer == 1))
then 
	mv $archivo ~/Documentos/Eliminado
	echo "Eliminado exitosamente"
fi
