

%option noyywrap

/*----- Sección de Declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <utility>
#include <cmath>
#include <algorithm>

using namespace std;

ifstream fichero;


vector<pair<float, string>> datos;
vector<pair<float, string>> datos_internacional;

int n_masa=0, n_distancia=0,n_presion=0,n_volumen=0, n_temperatura=0, n_area=0;

vector<vector<string>> unidades = {
    {"lb", "libras", " libras", "Lb", " Lb", "lbs", " lbs", "lb,", "libras,", "lbs,", "Lb,"}, // Masa (libras a kilogramos)
    {"mi", " millas", "mi,", "millas,"}, // Distancia (millas a kilómetros)
    {" pies de largo", " pies de altura.", "ft"}, // Distancia (pies a metros)
    {"libras/ft²,", " libras/ft²"}, // Presión (libras/ft² a pascal)
    {"ft³", " pies cúbicos"}, // Volumen (ft³ a m³)
    {"°F", " °F"," grados Fahrenheit","°F,","grados Fahrenheit,"}, // Temperatura (°F a °C)
    {" gal","gal,"}, // Volumen (galones a litros)
    {"tn","tn,"," tn"," toneladas","toneladas,"}, // Masa (toneladas a kilogramos)
    {"acres", "acres,", " acres", " acres,"} //Área (acres a m²)	
};

void escribir_datos(int dato1, int dato2, int dato3);
void mostrar_datos();
void buscar(string &unidad);
void convertir(vector<pair<float, string>> datos_anglosajon);
void redondear_decimales();
void generar_tabla(const string& archivo_salida);
%}

%%

	/*----- Sección de Reglas ----------------*/

[0-9]{1,3}(,[0-9]{3})*(\.[0-9]+)?[ \t]*(lb|libras|Lb|lbs|lb,|libras,|Lb,|lbs,|mi|millas|mi,|millas,|"pies de largo"|"pies de altura."|ft|"libras/ft²,"|ft³|"°F"|"grados Fahrenheit"|"°F,"|"grados Fahrenheit,"|gal|gal,|tn|tn,|toneladas|toneladas,|"pies cúbicos"|acres|acres,) { 
    	
        string entrada(yytext);

        // Limpia las comas en el número
        entrada.erase(remove(entrada.begin(), entrada.end(), ','), entrada.end());

        // Encuentra la posición donde comienza la unidad
        size_t pos = entrada.find_first_not_of("0123456789.");

        // Convierte la parte numérica a un valor entero
        int valor = stoi(entrada.substr(0, pos));

        // Extrae la unidad
        string tipo = entrada.substr(pos);

        // Normaliza y busca la unidad
        buscar(tipo);

        // Almacena el valor y la unidad
        datos.push_back({valor, tipo});

}

%%
	
	/*----- Sección de Procedimientos --------*/
int main(int argc, char *argv[]) {
    if (argc == 2) {
        fichero.open(argv[1]);
        if (!fichero) {
            cerr << "Error de lectura del archivo: " << argv[1] << endl;
            exit(1);
        } else {
            cout << "Procesando archivo: " << argv[1] << endl;
        }
    } else {
        cerr << "Uso: ./prog <archivo>" << endl;
        exit(1);
    }


    yyFlexLexer flujo(&fichero, 0);
    flujo.yylex();

    convertir(datos);
    redondear_decimales();
    mostrar_datos();

    // Generamos tabal con los datos obtenidos y sus respectivas conversiones
    generar_tabla("tabla_conversion.txt");

    return 0;
}

void generar_tabla(const string& archivo_salida) {
    ofstream salida(archivo_salida);

    if (!salida) {
        cerr << "Error al abrir el archivo de salida." << endl;
        return;
    }

    // Escribir encabezados
    salida << "Valor Original\tUnidad Original\tValor Convertido\tUnidad Convertida" << endl;
    salida << "-------------------------------------------------------------" << endl;

    // Escribir cada par de datos
    for (size_t i = 0; i < datos.size(); ++i) {
        salida << datos[i].first << "\t\t" 
               << datos[i].second << "\t\t" 
               << datos_internacional[i].first << "\t\t" 
               << datos_internacional[i].second << endl;
    }

    salida.close();
    cout << "La tabla se ha generado en: " << archivo_salida << endl;
}


void buscar(string &unidad){
   
    for(int i = 0; i < unidades.size(); i++){
        for(int j = 0; j < unidades[i].size(); j++){
            if(unidades[i][j] == unidad){
                switch(i){
                    case 0: unidad = "libras"; n_masa++; break;
                    case 1: unidad = "millas"; n_distancia++; break;
                    case 2: unidad = "pies"; n_distancia++; break;
                    case 3: unidad = "libras/ft²"; n_presion++;break;
                    case 4: unidad = "ft³"; n_volumen++;break;
                    case 5: unidad = "°F"; n_temperatura++; break;
                    case 6: unidad = "gal"; n_volumen++; break;
                    case 7: unidad = "tn"; n_masa++; break;
                    case 8: unidad = "acres"; n_area++; break;
                }
                return; // Finaliza una vez que encuentra la unidad
            }
        }
    }
    return;
}

void convertir(vector<pair<float, string>> datos_anglosajon){
    float num = 0;
    for(int i = 0; i < datos_anglosajon.size(); i++){
    
        pair<float, string> aux;
        
        if(datos_anglosajon[i].second == "libras"){
        
            aux.first = datos_anglosajon[i].first * 0.4536;
            aux.second = "kilogramos";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "millas"){
        
            aux.first = datos_anglosajon[i].first * 1.609;
            aux.second = "kilómetros";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "pies"){
        
            aux.first = datos_anglosajon[i].first * 0.3048;
            aux.second = "metros";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "libras/ft²"){
        
            aux.first = datos_anglosajon[i].first * 47.88;
            aux.second = "pascals";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "ft³"){
        
            aux.first = datos_anglosajon[i].first * 0.0283168;
            aux.second = "m³";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "°F"){
        
            aux.first = (datos_anglosajon[i].first - 32)/1.8;
            aux.second = "°C";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "gal"){
        
            aux.first = datos_anglosajon[i].first * 3.78541;
            aux.second = "L";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "tn"){
        
            aux.first = datos_anglosajon[i].first * 907.184;
            aux.second = "kilogramos";
            datos_internacional.push_back(aux);
        }else if(datos_anglosajon[i].second == "acres"){
        
            aux.first = datos_anglosajon[i].first * 4046.856;
            aux.second = "m²";
            datos_internacional.push_back(aux);
        }
        num = 0;
    }
}

void redondear_decimales(){
	
	int decimales = pow(10,2); 	//Vamos a redondear a dos decimales
	
	for(int i=0 ; i<datos_internacional.size() ; i++){
	
		datos_internacional[i].first = round(datos_internacional[i].first * decimales) / decimales;
	}
}

void mostrar_datos() {
    cout << "Unidades detectadas" << endl;
    cout << "-----------------------------------" << endl;
    for (int i = 0; i < datos.size(); i++) {
        cout << "[" << i + 1 << "] Valor: " << datos[i].first 
             << ", Unidad: " << datos[i].second << endl;
    }
    cout << endl<<"Hemos almacenado: " << datos.size() << " valores." << endl;
    cout << "Unidades cambiadas a sistema internacional" << endl;
    cout << "-----------------------------------" << endl;
    for (int i = 0; i < datos_internacional.size(); i++) {
        cout << "[" << i + 1 << "] Valor: " << datos_internacional[i].first 
             << ", Unidad: " << datos_internacional[i].second << endl;
    }
    cout << endl<<"Hemos almacenado: " << datos_internacional.size() << " valores y detectado y convertido un total de:" << endl;
    cout << n_masa << " unidades de masa (en kilogramos) en todo el texto. " << endl;
    cout << n_distancia << " unidades de distancia (en metros y kilometros) en todo el texto. " << endl;
    cout << n_presion << " unidades de presion (en pascales) en todo el texto. "<< endl;
    cout << n_volumen << " unidades de volumen (en metros cubicos) en todo el texto. " << endl;
    cout << n_temperatura << " unidades de temperatura (en grados centigrados) en todo el texto. "<< endl;
    cout << n_area << " unidades de area (en metros cuadrados) en todo el texto. " << endl << endl;
}











