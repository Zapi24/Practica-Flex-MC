# Practica-Flex-MC
Aprendiendo flex


## Explicación:

Hemos construido un programa, que se encarga de analizar un texto
plano, con un total de 36 unidades distintas y en formatos diversos, dentro del sistema
de medida anglosajón. Dentro de este sistema, podemos encontrar unidades del tipo:
libras, galones, pies etc. El objetivo de este trabajo, es el realizar un programa que
identifique gracias a expresiones regulares, todos esos datos, y los convierta a otros
dentro del sistema internacional

## Distintos archivos: 

**1. plantilla.l:** Es el archivo principal y el que contiene todo el código de nuestro trabajo, el cual
explicaremos después

**2. FicheroFormatoAnglosajón:** Archivo plano de texto, generado con inteligencia artificial, el cual contiene explicaciones
sobre distintas áreas geográficas y geológicas. Lo importante de este texto, son las
unidades expresadas en anglosajón, las cuales nuestro código identifica y transforma al
sistema internacional. Este archivo tiene la forma: (Este texto contiene un total de 36
unidades)

**3. tabla_conversion.txt:** Fichero donde nuestro
programa, tras su ejecución, mostrará los datos recogidos con su respectiva conversión.
Inicialmente este se encuentra vacío.

**4. macho.sh:** Se encarga de realizar todos los
pasos de compilación y ejecución de nuestro programa. Ejecutando desde la terminal
“./macro.sh FicheroFomatoAnglosajon”, tras darle permisos de ejecución, y especificando el
fichero plano de formato anglosajón como argumento, se encarga primero de comprobar
que nuestro archivo “plantilla.l” existe, y si es así, pasamos a generar el archivo lex con
flex++, compilar el resultante con g++, y ejecutar el ejecutable prog



