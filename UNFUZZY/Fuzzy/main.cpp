
#include <iostream>
#include <iostream>
#include <string>
using namespace std;


#include "fuzzy.cpp"


class miSLD:public SistemaLogicaDifusa
{
public:
    miSLD();
    ~miSLD();
protected:
};

miSLD::miSLD()
{
    ConjuntoDifuso *cd;
    Difusor *dif;
    Variable *var;
    Norma *And;
    Norma *Composicion;
    Norma *Conjuncion;
    Implicacion *Implica;
    Concresor *conc;

    entradas=new Universo(3);
    salidas=new Universo(1);
    var=new Variable(3);
    var->rangoMinimo(3078);
    var->rangoMaximo(4522);
    cd=new ConjuntoL(3078,3439,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoTriangulo(3439,3800,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoGamma(3439,4161,4522);
    var->adicionarConjuntos(cd);
    dif=new DifusorSinglenton(3078,7.22);
    dif->numeroPuntos(1);
    var->difusorEntrada(dif);
    var->nombreVariable("hoy");
    var->numeroIntervalos(20);
    entradas->adicionarVariable(var);
    var=new Variable(3);
    var->rangoMinimo(3078);
    var->rangoMaximo(4522);
    cd=new ConjuntoL(3078,3439,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoTriangulo(3439,3800,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoGamma(3439,4161,4522);
    var->adicionarConjuntos(cd);
    dif=new DifusorSinglenton(3078,7.22);
    dif->numeroPuntos(1);
    var->difusorEntrada(dif);
    var->nombreVariable("ayer");
    var->numeroIntervalos(20);
    entradas->adicionarVariable(var);
    var=new Variable(3);
    var->rangoMinimo(3078);
    var->rangoMaximo(4522);
    cd=new ConjuntoL(3078,3439,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoTriangulo(3439,3800,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoGamma(3439,4161,4522);
    var->adicionarConjuntos(cd);
    dif=new DifusorSinglenton(0,7.22);
    dif->numeroPuntos(1);
    var->difusorEntrada(dif);
    var->nombreVariable("antier");
    var->numeroIntervalos(20);
    entradas->adicionarVariable(var);
    var=new Variable(3);
    var->rangoMinimo(3078);
    var->rangoMaximo(4522);
    cd=new ConjuntoL(3078,3439,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoTriangulo(3439,3800,4161);
    var->adicionarConjuntos(cd);
    cd=new ConjuntoGamma(3439,4161,4522);
    var->adicionarConjuntos(cd);
    var->nombreVariable("manana");
    var->numeroIntervalos(20);
    salidas->adicionarVariable(var);
    motor=new MaquinaInferencia(entradas,salidas,14);
    And=new Minimo();
    Composicion=new Minimo();
    Implica=new ImplicacionMinimo();
    motor->and_(And);
    motor->composicion(Composicion);
    motor->implicacion(Implica);
    motor->conjuntoEntrada(0,0,0);
    motor->conjuntoEntrada(0,1,0);
    motor->conjuntoEntrada(0,2,0);
    motor->conjuntoSalida(0,0,0);
    motor->conjuntoEntrada(1,0,1);
    motor->conjuntoEntrada(1,1,0);
    motor->conjuntoEntrada(1,2,0);
    motor->conjuntoSalida(1,0,1);
    motor->conjuntoEntrada(2,0,1);
    motor->conjuntoEntrada(2,1,0);
    motor->conjuntoEntrada(2,2,1);
    motor->conjuntoSalida(2,0,1);
    motor->conjuntoEntrada(3,0,1);
    motor->conjuntoEntrada(3,1,1);
    motor->conjuntoEntrada(3,2,0);
    motor->conjuntoSalida(3,0,1);
    motor->conjuntoEntrada(4,0,0);
    motor->conjuntoEntrada(4,1,1);
    motor->conjuntoEntrada(4,2,1);
    motor->conjuntoSalida(4,0,0);
    motor->conjuntoEntrada(5,0,0);
    motor->conjuntoEntrada(5,1,0);
    motor->conjuntoEntrada(5,2,1);
    motor->conjuntoSalida(5,0,0);
    motor->conjuntoEntrada(6,0,1);
    motor->conjuntoEntrada(6,1,1);
    motor->conjuntoEntrada(6,2,1);
    motor->conjuntoSalida(6,0,1);
    motor->conjuntoEntrada(7,0,1);
    motor->conjuntoEntrada(7,1,2);
    motor->conjuntoEntrada(7,2,2);
    motor->conjuntoSalida(7,0,1);
    motor->conjuntoEntrada(8,0,1);
    motor->conjuntoEntrada(8,1,1);
    motor->conjuntoEntrada(8,2,2);
    motor->conjuntoSalida(8,0,1);
    motor->conjuntoEntrada(9,0,2);
    motor->conjuntoEntrada(9,1,1);
    motor->conjuntoEntrada(9,2,2);
    motor->conjuntoSalida(9,0,2);
    motor->conjuntoEntrada(10,0,1);
    motor->conjuntoEntrada(10,1,2);
    motor->conjuntoEntrada(10,2,1);
    motor->conjuntoSalida(10,0,1);
    motor->conjuntoEntrada(11,0,2);
    motor->conjuntoEntrada(11,1,1);
    motor->conjuntoEntrada(11,2,1);
    motor->conjuntoSalida(11,0,2);
    motor->conjuntoEntrada(12,0,2);
    motor->conjuntoEntrada(12,1,2);
    motor->conjuntoEntrada(12,2,1);
    motor->conjuntoSalida(12,0,2);
    motor->conjuntoEntrada(13,0,2);
    motor->conjuntoEntrada(13,1,2);
    motor->conjuntoEntrada(13,2,2);
    motor->conjuntoSalida(13,0,2);
    motor->modificador(0,0,1);
    motor->modificador(0,1,1);
    motor->modificador(0,2,1);
    motor->modificador(1,0,1);
    motor->modificador(1,1,1);
    motor->modificador(1,2,1);
    motor->modificador(2,0,1);
    motor->modificador(2,1,1);
    motor->modificador(2,2,1);
    motor->modificador(3,0,1);
    motor->modificador(3,1,1);
    motor->modificador(3,2,1);
    motor->modificador(4,0,1);
    motor->modificador(4,1,1);
    motor->modificador(4,2,1);
    motor->modificador(5,0,1);
    motor->modificador(5,1,1);
    motor->modificador(5,2,1);
    motor->modificador(6,0,1);
    motor->modificador(6,1,1);
    motor->modificador(6,2,1);
    motor->modificador(7,0,1);
    motor->modificador(7,1,1);
    motor->modificador(7,2,1);
    motor->modificador(8,0,1);
    motor->modificador(8,1,1);
    motor->modificador(8,2,1);
    motor->modificador(9,0,1);
    motor->modificador(9,1,1);
    motor->modificador(9,2,1);
    motor->modificador(10,0,1);
    motor->modificador(10,1,1);
    motor->modificador(10,2,1);
    motor->modificador(11,0,1);
    motor->modificador(11,1,1);
    motor->modificador(11,2,1);
    motor->modificador(12,0,1);
    motor->modificador(12,1,1);
    motor->modificador(12,2,1);
    motor->modificador(13,0,1);
    motor->modificador(13,1,1);
    motor->modificador(13,2,1);
    concreto=new BloqueConcrecion(motor);
    Conjuncion=new Maximo();
    conc=new CentroDeGravedad(motor,0,Conjuncion);
    concreto->adicionarConcresor(conc);
    concreto->motor(motor);
    concreto->conjuncion(Conjuncion);
}

miSLD::~miSLD()
{
}

int main()
{
    double *entra;
    double *sale;
    miSLD *sistema;
    int NumeroEntradas;
    int NumeroSalidas;
    sistema=new miSLD();
    NumeroEntradas=sistema->numeroEntradas();
    NumeroSalidas=sistema->numeroSalidas();
    entra=new double[NumeroEntradas];
    sale=new double[NumeroSalidas];
    int i;
    char q='s';
    while(q=='s')
    {
        for(i=0;i<NumeroEntradas;i++)
        {
            cout << sistema->nombreVariableEntrada(i) << " : ";
            cin >> entra[i];
        }
        sistema->calcular(entra,sale);
        for(i=0;i<NumeroSalidas;i++)
        {
            cout << sistema->nombreVariableSalida(i) << " : ";
            cout << sale[i] << "\n";
        }
        cout << "Desea otro cálculo ?(s/n)";
        cin >> q;
    }
    delete[] entra;
    delete[] sale;
    return 0;
}

