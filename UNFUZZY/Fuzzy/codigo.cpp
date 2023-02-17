// Código C++ del Sistema de Lógica Difusa

// Generado automáticamente por UNFUZZY V 3.0
// Autor: Oscar Duarte (ogduartev@unal.edu.co)
// Universidad Nacional de Colombia
// Descargo de responsabilidad:
// El código generado se usa bajo responsabilidad del usuario.
// En ninguna forma genera responsabilidad para el autor de UNFUZZY
// ni para la Universidad Nacional de Colombia.
//
// para compilar el archivo xxx.cpp:
//   g++ xxx.cpp fuzzy.cpp

#include <iostream>
#include <iostream>
#include <string>
using namespace std;


#ifndef __FUZZY_H
#include "fuzzy.h"
#endif

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


    double Valores[504]={3432.50,
                    3432.50,
                    3432.50,
                    3432.50,
                    3432.50,
                    3420.78,
                    3450.74,
                    3428.04,
                    3459.39,
                    3478.11,
                    3478.11,
                    3478.11,
                    3478.11,
                    3487.65,
                    3478.36,
                    3469.76,
                    3466.80,
                    3466.80,
                    3466.80,
                    3466.80,
                    3482.03,
                    3476.19,
                    3477.48,
                    3525.25,
                    3525.25,
                    3525.25,
                    3582.41,
                    3591.48,
                    3636.91,
                    3585.44,
                    3559.46,
                    3559.46,
                    3559.46,
                    3561.37,
                    3534.99,
                    3522.57,
                    3558.63,
                    3543.28,
                    3543.28,
                    3543.28,
                    3554.65,
                    3583.23,
                    3557.16,
                    3525.45,
                    3515.65,
                    3515.65,
                    3515.65,
                    3515.65,
                    3518.19,
                    3545.84,
                    3537.86,
                    3555.40,
                    3555.40,
                    3555.40,
                    3602.41,
                    3590.37,
                    3578.29,
                    3588.23,
                    3624.39,
                    3624.39,
                    3624.39,
                    3622.36,
                    3646.61,
                    3676.94,
                    3647.99,
                    3640.20,
                    3640.20,
                    3640.20,
                    3623.61,
                    3598.77,
                    3561.91,
                    3534.62,
                    3575.30,
                    3575.30,
                    3575.30,
                    3575.63,
                    3553.51,
                    3578.02,
                    3569.45,
                    3553.34,
                    3553.34,
                    3553.34,
                    3553.34,
                    3589.82,
                    3635.12,
                    3658.22,
                    3665.41,
                    3665.41,
                    3665.41,
                    3705.85,
                    3736.91,
                    3678.62,
                    3678.62,
                    3678.62,
                    3678.62,
                    3678.62,
                    3645.79,
                    3645.14,
                    3639.62,
                    3634.07,
                    3650.23,
                    3650.23,
                    3650.23,
                    3653.57,
                    3666.17,
                    3665.49,
                    3620.40,
                    3595.57,
                    3595.57,
                    3595.57,
                    3606.42,
                    3636.26,
                    3639.12,
                    3630.81,
                    3640.07,
                    3640.07,
                    3640.07,
                    3659.62,
                    3717.46,
                    3699.74,
                    3712.89,
                    3740.14,
                    3740.14,
                    3740.14,
                    3816.65,
                    3831.35,
                    3846.28,
                    3800.33,
                    3765.33,
                    3765.33,
                    3765.33,
                    3714.94,
                    3703.20,
                    3734.09,
                    3728.09,
                    3682.84,
                    3682.84,
                    3682.84,
                    3682.84,
                    3655.74,
                    3682.66,
                    3721.57,
                    3738.19,
                    3738.19,
                    3738.19,
                    3750.66,
                    3735.41,
                    3747.48,
                    3729.02,
                    3715.28,
                    3715.28,
                    3715.28,
                    3715.28,
                    3671.38,
                    3642.29,
                    3657.41,
                    3609.20,
                    3609.20,
                    3609.20,
                    3609.20,
                    3597.18,
                    3588.41,
                    3589.86,
                    3626.02,
                    3626.02,
                    3626.02,
                    3626.02,
                    3693.35,
                    3690.56,
                    3730.45,
                    3753.77,
                    3753.77,
                    3753.77,
                    3758.08,
                    3784.45,
                    3773.11,
                    3770.35,
                    3739.03,
                    3739.03,
                    3739.03,
                    3713.17,
                    3756.67,
                    3748.50,
                    3775.53,
                    3777.17,
                    3777.17,
                    3777.17,
                    3777.17,
                    3782.27,
                    3815.22,
                    3850.46,
                    3829.46,
                    3829.46,
                    3829.46,
                    3824.08,
                    3826.85,
                    3796.07,
                    3809.07,
                    3808.46,
                    3808.46,
                    3808.46,
                    3842.97,
                    3842.97,
                    3855.68,
                    3866.86,
                    3874.44,
                    3874.44,
                    3874.44,
                    3904.17,
                    3904.17,
                    3902.18,
                    3836.95,
                    3867.88,
                    3867.88,
                    3867.88,
                    3865.46,
                    3913.59,
                    3911.36,
                    3910.81,
                    3949.33,
                    3949.33,
                    3949.33,
                    3988.27,
                    3979.80,
                    3950.43,
                    3887.07,
                    3830.25,
                    3830.25,
                    3830.25,
                    3830.25,
                    3868.41,
                    3861.33,
                    3876.08,
                    3874.95,
                    3874.95,
                    3874.95,
                    3867.73,
                    3861.88,
                    3865.04,
                    3870.57,
                    3834.13,
                    3834.13,
                    3834.13,
                    3806.87,
                    3774.00,
                    3753.30,
                    3780.85,
                    3790.04,
                    3790.04,
                    3790.04,
                    3790.04,
                    3812.76,
                    3816.14,
                    3829.72,
                    3836.85,
                    3836.85,
                    3836.85,
                    3835.27,
                    3830.83,
                    3825.36,
                    3818.16,
                    3828.18,
                    3828.18,
                    3828.18,
                    3851.22,
                    3843.77,
                    3834.66,
                    3835.67,
                    3844.88,
                    3844.88,
                    3844.88,
                    3837.91,
                    3841.94,
                    3834.68,
                    3812.77,
                    3781.35,
                    3781.35,
                    3781.35,
                    3786.05,
                    3796.30,
                    3788.03,
                    3772.44,
                    3765.80,
                    3765.80,
                    3765.80,
                    3765.80,
                    3738.48,
                    3725.75,
                    3755.29,
                    3772.49,
                    3772.49,
                    3772.49,
                    3772.49,
                    3766.94,
                    3770.58,
                    3783.30,
                    3780.38,
                    3780.38,
                    3780.38,
                    3769.98,
                    3774.46,
                    3761.21,
                    3766.10,
                    3784.44,
                    3784.44,
                    3784.44,
                    3784.44,
                    3778.69,
                    3837.84,
                    3847.40,
                    3881.76,
                    3881.76,
                    3881.76,
                    3874.41,
                    3876.86,
                    3875.38,
                    3875.38,
                    3888.53,
                    3888.53,
                    3888.53,
                    3888.53,
                    3898.84,
                    3907.95,
                    3943.43,
                    3923.53,
                    3923.53,
                    3923.53,
                    3913.26,
                    3944.37,
                    3969.49,
                    3969.49,
                    4008.13,
                    4008.13,
                    4008.13,
                    4010.98,
                    4004.54,
                    3953.26,
                    3945.18,
                    3948.33,
                    3948.33,
                    3948.33,
                    3948.00,
                    3906.10,
                    3906.10,
                    3899.87,
                    3887.71,
                    3887.71,
                    3887.71,
                    3886.87,
                    3936.41,
                    3990.27,
                    4002.97,
                    3999.85,
                    3999.85,
                    3999.85,
                    4002.12,
                    3996.28,
                    3997.71,
                    3997.09,
                    3994.15,
                    3994.15,
                    3994.15,
                    3989.41,
                    4004.00,
                    4023.68,
                    3981.16,
                    3981.16,
                    3981.16,
                    3981.16,
                    4082.75,
                    4084.11,
                    4042.36,
                    4039.31,
                    4043.46,
                    4043.46,
                    4043.46,
                    4043.46,
                    4011.65,
                    3970.08,
                    3950.40,
                    3993.65,
                    3993.65,
                    3993.65,
                    3993.65,
                    4033.37,
                    4003.95,
                    3980.80,
                    3964.30,
                    3964.30,
                    3964.30,
                    3977.51,
                    3987.32,
                    3947.83,
                    3944.04,
                    3982.60,
                    3982.60,
                    3982.60,
                    3942.73,
                    3923.61,
                    3928.05,
                    3951.96,
                    3962.68,
                    3962.68,
                    3962.68,
                    3963.84,
                    3965.41,
                    3939.31,
                    3917.75,
                    3917.52,
                    3917.52,
                    3917.52,
                    3938.97,
                    3946.88,
                    3963.72,
                    3953.26,
                    3927.25,
                    3927.25,
                    3927.25,
                    3927.25,
                    3932.40,
                    3913.79,
                    3940.20,
                    3910.64,
                    3910.64,
                    3910.64,
                    3910.28,
                    3901.62,
                    3862.95,
                    3771.77,
                    3806.11,
                    3806.11,
                    3806.11,
                    3813.41,
                    3787.18,
                    3746.43,
                    3786.00,
                    3827.64,
                    3827.64,
                    3827.64,
                    3800.85,
                    3836.56,
                    3826.89,
                    3816.43,
                    3820.67,
                    3820.67,
                    3820.67,
                    3820.67,
                    3765.67,
                    3756.64,
                    3798.90,
                    3785.66,
                    3785.66,
                    3785.66,
                    3785.70,
                    3765.96,
                    3748.15,
                    3756.03,
                    3774.79,
                    3774.79,
                    3774.79,
                    3706.95,
                    3723.79,
                    3746.51,
                    3771.83,
                    3777.41,
                    3777.41,
                    3777.41,
                    3744.16,
                    3736.70,
                    3737.32,
                    3737.32,
                    3737.32,
                    3737.32,
                    3737.32,
                    3731.31,
                    3755.85,
                    3758.65,
                    3759.54,
                    3819.07,
                    3819.07,
                    3819.07,
                    3931.74,
                    3947.63,
                    3967.32,
                    3984.77,
                    3966.27,
                    3966.27,
                    3966.27,
                    4004.07,
                    4016.34,
                    4056.41,
                    4086.08,
                    4053.93,
                    4053.93,
                    4053.93,
                    4085.76,
                    4086.71,
                    4080.32,
                    4109.71,
                    4110.53,
                    4110.53,
                    4110.53,
                    4070.25,
                    4033.85};

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


    for(i=0;i<501;i++){


        entra[0]=Valores[i+2];
        entra[1]=Valores[i+1];
        entra[2]=Valores[i];

        sistema->calcular(entra,sale);

        cout << sale[0] << "\n";

    }

    /*
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
    }*/
    delete[] entra;
    delete[] sale;
    return 0;
}

