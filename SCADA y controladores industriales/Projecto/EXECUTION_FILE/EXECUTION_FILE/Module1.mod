MODULE Module1
    CONST jointtarget HomeHerramienta:=[[0,0,0,0,45,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1_Alto:=[[-77.3,389.019,55],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1_Porta:=[[-77.3,389.019,5],[0,0,1,0],[0,-2,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1_BAlto:=[[-77.1,169.1,55],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P1_Base:=[[-77.1,169.1,5],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget HomeLaboratorio:=[[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2_Alto:=[[-199.7,161,55],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2_Porta:=[[-199.7,161,5],[0,0,1,0],[-1,1,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2_BAlto:=[[-186.7,124.4,55],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P2_Base:=[[-186.7,124.4,5],[0,0,1,0],[0,-1,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3_Alto:=[[-129.3,139.3,55],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3_Porta:=[[-129.3,139.3,5],[0,0,1,0],[-1,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3_BAlto:=[[-134.3,139.3,60],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P3_Base:=[[-134.3,139.3,10],[0,0,1,0],[0,-1,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4_Alto:=[[-54.5,99.1,55],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4_Porta:=[[-54.5,99.1,5],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4_BAlto:=[[-59.5,99.1,60],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P4_Base:=[[-59.5,99.1,10],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P5_Alto:=[[-222,389.1,55],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P5_Porta:=[[-222,389.1,5],[0,0,1,0],[0,-2,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P5_BAlto:=[[-77.1,169.1,65],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P5_Base:=[[-77.1,169.1,15],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P6_Alto:=[[-199.5,41.5,55],[0,0,1,0],[-1,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P6_Porta:=[[-199.5,41.5,5],[0,0,1,0],[-1,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P6_BAlto:=[[-186.6,74.6,65],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget P6_Base:=[[-186.6,74.6,15],[0,0,1,0],[0,-1,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PROC ToHome()
        MoveAbsJ HomeLaboratorio,v150,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC    
    PROC Path_P1()
        MoveAbsJ HomeHerramienta,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P1_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P1_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P1_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P1_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P1_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P1_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC Path_P2()
        MoveL P2_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P2_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P2_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P2_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P2_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P2_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC Path_P3()
        MoveL P3_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P3_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P3_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P3_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P3_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P3_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC Path_P4()
        MoveL P4_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P4_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P4_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P4_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P4_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P4_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC Path_P5()
        MoveL P5_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P5_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P5_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P5_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P5_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P5_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC Path_P6()
        MoveL P6_Alto,v150,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P6_Porta,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        WaitDI DI_01,1;
        SetDO DO_01,1;
        WaitTime 0.05;
        SetDO DO_01,0;
        MoveL P6_Alto,v50,z10,Tool_AJDJ\WObj:=Portapiezas;
        MoveL P6_BAlto,v150,z10,Tool_AJDJ\WObj:=BaseG;
        MoveL P6_Base,v50,z10,Tool_AJDJ\WObj:=BaseG;
        WaitDI DI_01,1;
        SetDO DO_02,1;
        WaitTime 0.05;
        SetDO DO_02,0;
        MoveL P6_BAlto,v50,z10,Tool_AJDJ\WObj:=BaseG;
        MoveAbsJ HomeHerramienta,v150,z10,Tool_AJDJ\WObj:=BaseG;
    ENDPROC
    PROC main()
        SpyStart "HOME:/spy.log";
        SetDO DO_03,0;
        WaitDI DI_01,1;
        ToHome;
        WaitDI DI_01,1;
        Path_P1;
        Path_P2;
        Path_P3;
        Path_P4;
        Path_P5;
        Path_P6;
        ToHome;
        SetDO DO_03,1;
        SpyStop;
        Break;
    ENDPROC
ENDMODULE