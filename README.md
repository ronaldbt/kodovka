# kodovka
Kodovka - Encriptador y Desencriptador de Archivos en PowerShell

Kodovka es un script desarrollado en PowerShell que permite encriptar y desencriptar archivos de texto utilizando una contraseña proporcionada por el usuario. Este script está diseñado para ser sencillo y efectivo, proporcionando una capa adicional de seguridad para proteger información sensible.

Características

Encriptación y desencriptación AES: Utiliza el algoritmo de cifrado AES para asegurar la información del archivo. La clave se genera a partir de una contraseña usando SHA-256.

Interfaz de usuario amigable: Solicita la contraseña mediante un cuadro de diálogo emergente, lo cual hace que la interacción con el usuario sea más intuitiva y sencilla.

Extensión personalizada: Los archivos encriptados se guardan con la extensión ".enc" para diferenciarlos de los archivos desencriptados.

Verificación del estado del archivo: El script verifica si un archivo ya está encriptado o no, ofreciendo al usuario la opción de desencriptar o encriptar según corresponda.

Manejo seguro de contraseñas: La contraseña se solicita de manera segura a través de una ventana emergente, evitando que se muestre en la línea de comandos.

Uso

El script permite tanto la encriptación como la desencriptación de archivos de texto de forma interactiva. Se debe especificar la ruta del archivo como argumento al ejecutar el script.

Encriptar un archivo: Si el archivo no está encriptado, el script pregunta si deseas encriptarlo, luego solicita una contraseña y genera un archivo ".enc" encriptado.

Desencriptar un archivo: Si el archivo tiene la extensión ".enc", el script preguntará si deseas desencriptarlo, y solicitará la contraseña correspondiente para realizar la desencriptación.

Ejecución

Para ejecutar el script, usa el siguiente comando en PowerShell, proporcionando la ruta del archivo que deseas encriptar o desencriptar:

powershell -ExecutionPolicy Bypass -File .\Kodovka.ps1 "ruta\del\archivo.txt"

o simplemente prueba .\Kodovka.ps1

Si el archivo ya está encriptado (tiene la extensión ".enc"), el script ofrecerá la opción de desencriptarlo ingresando la contraseña correcta.

Requisitos

PowerShell 5.0 o superior

Windows Forms: Se utiliza para las ventanas emergentes que solicitan la contraseña.

Notas de Seguridad

Contraseña: Asegúrate de utilizar una contraseña segura y compleja para encriptar los archivos.

Archivo encriptado: El archivo original se elimina después de la encriptación para garantizar la seguridad. El archivo encriptado es el único que se conserva.

Licencia

Este proyecto está bajo la licencia MIT, lo que significa que puedes usar, modificar y distribuir el software según los términos de dicha licencia.
