Creador:
Carlos Loría Saenz
EIF400 loriacarlos@gmail.com

Colaboradores:
Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

Requerimientos:
	* Node.js +8
	* Swipl

Pasos a realizar:

1- Abrir una consola del sistema(cmd).
2- Ejecutar el programa de 'swipl'.
3- Instalar el paquete prosqlite.
	3.1 Escribir lo siguiente. ----> pack_install(prosqlite). <----
	3.2 Seleccionar la carpeta de instalación. (SELECCIONAR LA OPCIÓN 2 RECOMENDADO) ('c:/program files/swipl/pack')
	3.3 Seguir lo pedido hasta que la instalación sea exitosa.
4- Dirijirse a la carpeta Angular SPA.
	4.1 Abrir una consola del sistema(cmd).
	4.2 Escribir lo siguiente. ----> npm install <----
		4.2.1 Seguir lo pedido hasta que la instalación sea exitosa.
	4.3 Escribir lo siguiente. ----> npm run build <----
5- Dirijirse a la carpeta RS_Servers_2019/Server
6- Ejecutar el bat llamado 'run servers'
7- Abrir un navegador y dirijirse al website localhost:9000
8- Hay 2 usuarios
	8.1 Usuario chatter
		8.1.1 Usuario: user1
		8.1.2 Contraseña: pass1
		8.1.3 Puede conversar con un bot.
	8.2 Usuario administrador
		8.2.1 Usuario: user2
		8.2.2 Contraseña: pass2
		8.2.3 Puede subir archivos '.rive'.
