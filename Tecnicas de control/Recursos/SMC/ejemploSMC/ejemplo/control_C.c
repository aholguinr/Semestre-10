/******************************************************************************
 * FILE: control_manager_SIL.c
 * DESCRIPTION:
 * Software in the loop simulation (SILS) environment for V&V of onboard flight program (OFP).
 *
 *
 * University of Minnesota 
 * Aerospace Engineering and Mechanics 
 * Copyright 2011 Regents of the University of Minnesota. All rights reserved.
 *
 * $Id$
 ******************************************************************************/

#define S_FUNCTION_NAME control_C
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include "mex.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <time.h>


#define dt        		*mxGetPr(ssGetSFcnParam(S,0))		// Software sample time, as an input parameter
#define time			ssGetT(S)							// Current simulation time		


// Data Structures 
double p;
static double h;

/// Definition of local variables: ****************************************************
static double integrator = 0;

// Composite controller
static double p_gain[2]  ={0.6, 0.008}; //group 1, v1
static double p_control(double pos_err, double delta_t); // Control Function

/*========================================================================*
 *                          Initialization                                *
 *========================================================================*/
static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 1);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch reported by the Simulink engine*/
    }

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDirectFeedThrough(S, 0, 1);

    if (!ssSetNumOutputPorts(S,1)) return;
    ssSetOutputPortWidth(S, 0, DYNAMICALLY_SIZED);

    ssSetNumSampleTimes(S, 1);

    }
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, dt);
    ssSetOffsetTime(S, 0, 0.0);
}

static void mdlStart(SimStruct *S) {
    integrator = 0;
    //v = 0;
}

/*========================================================================*
 *                              Output                                    *
 *========================================================================*/
static void mdlOutputs(SimStruct *S, int_T tid) {
    // local variables
    real_T  *y0 = ssGetOutputPortRealSignal(S, 0);
       
    // Assign sensor data to feedback vector. 
    InputRealPtrsType p_ptrs = ssGetInputPortRealSignalPtrs(S, 0); // position
    //**** CONTROL ***********************************************************
    // *****************
    // Para este Ejemplo se utilizo un controlador PI
    *y0 =  p_control(*p_ptrs[0], time);
    //**********************************************************************
    
}

/*========================================================================*
 *                              Termination                               *
 *========================================================================*/

static void mdlTerminate(SimStruct *S) {
    integrator = 0;
    //v = 0;
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
// ========================================================================================================
/*
Esta es la funcion de control que se implementa en el Micro, y es directamente el codigo que funcionara en el sitema
*/
static double p_control(double p_err, double delta_t) {
    double v;
	integrator += (p_err) * delta_t ; //pitch error integral
	v = p_gain[0]*(p_err) + p_gain[1] * integrator; 

	return v;
}

