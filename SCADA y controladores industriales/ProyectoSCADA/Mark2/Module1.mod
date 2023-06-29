MODULE Module1
    PERS string strOPC:= "timestamp";
    VAR bool bOPC :=TRUE;
    PERS bool bOPC2 :=TRUE;
    PERS num Cont :=90;
    
    PERS num IOTJ1 :=0;
    PERS num IOTJ2 :=1027;
    PERS num IOTJ3 :=926;
    PERS num IOTJ4 :=1018;
    PERS num IOTJ5 :=1021;
    PERS num IOTJ6 :=1025;
    
    PERS num POSX:=568.766;
    PERS num POSY:=-5.92079E-5;
    PERS num POSZ:=647.226;
    
    PERS num MOVEPOSX:=5;
    PERS num MOVEPOSY:=1;
    PERS num MOVEPOSZ:=2;
    
    
    VAR robtarget posMoveL;
    VAR pos pos1;

    
    
    CONST jointtarget JointTarget_2:=[[0,50,-40,70,-50,-50],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget JointTarget_1:=[[0,20,-20,40,-20,-20],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget HomeP:=[[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget HomeR:=[[0,0,0,0,30,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget JointTarget_TL:=[[90,40,-45,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget JointTarget_TR:=[[-90,40,-45,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !Init Vars cortadp
    CONST robtarget Home:=[[689.268487273,0,537.14730631],[0.190808996,0,0.981627183,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_10:=[[800,100,300],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_20:=[[500,100,300],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS intnum veces;
    CONST robtarget Target_30:=[[500,400,300],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_40:=[[800,400,300],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_50:=[[800,-250,300],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_70:=[[500,-250,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Centro:=[[650,-250,403.186020656],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_80:=[[650,-100,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_60:=[[650,-400,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_120:=[[800,-100,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_100:=[[500,-400,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_90:=[[800,-400,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_110:=[[500,-100,300],[0,0,1,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !Fin Vars cortadp
    
    
    VAR jointtarget myJointTarget;
    PROC main()
        ActualizarDatoPos;
        WaitDI DI_IOT_02,1;
        WaitDI DI_IOT_01,1;
        WaitDI DI_IOT_02,1;
        TEST DI_INT_IOT_01
        
            CASE 1:
                ToHomeP;
            CASE 2:
                ToHomeR;
            CASE 3:
                ToolQL;
            CASE 4:
                ToolQR;
            CASE 5:
                Security;
            CASE 6:
                MoveProcJInt;
            CASE 7:
                MovePosLInt;
            CASE 8:
                CortadoFull;
            
        ENDTEST
        

    ENDPROC
    PROC ToHomeP()
        ActualizarDatoPos;
        MoveAbsJ HomeP,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    
    PROC ToHomeR()
        ActualizarDatoPos;
        MoveAbsJ HomeR,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    
    
    PROC Security()
        ActualizarDatoPos;
        MoveAbsJ HomeP,v100,z10,ToolAJATCP\WObj:=WOAJA;
        ActualizarDatoPos;
        MoveAbsJ JointTarget_1,v100,z10,ToolAJATCP\WObj:=WOAJA;
        ActualizarDatoPos;
        MoveAbsJ JointTarget_2,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    PROC ToolQL()
        MoveAbsJ HomeP,v100,z10,ToolAJATCP\WObj:=WOAJA;
        ActualizarDatoPos;
        MoveAbsJ JointTarget_TL,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    
    PROC ToolQR()
        ActualizarDatoPos;
        MoveAbsJ HomeP,v100,z10,ToolAJATCP\WObj:=WOAJA;
        ActualizarDatoPos;
        MoveAbsJ JointTarget_TR,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    !PROC Path_40()
    !    MoveL Target_180,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_190,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_200,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_210,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_220,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_230,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_240,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_250,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_260,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_270,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_280,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_290,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_300,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !    MoveL Target_310,v100,z10,ToolAJATCP\WObj:=WOAJA;
    !ENDPROC
    
    
    
    PROC ActualizarDatoPos()
        pos1 := CPos(\Tool:=tool0 \WObj:=wobj0);
        POSX:=pos1.x;
        POSY:=pos1.y;
        POSZ:=pos1.z;
    ENDPROC
    
    
    PROC MoveProcJ()
        myJointTarget := [[IOTJ1,IOTJ2,IOTJ3,IOTJ4,IOTJ5,IOTJ6],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        MoveAbsJ myJointTarget,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    
    PROC MoveProcJInt()
        !IOTJ1:=DINT_J1-1000;
        myJointTarget := [[DINT_J1-1000,DINT_J2-1000,DINT_J3-1000,DINT_J4-1000,DINT_J5-1000,DINT_J6-1000],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        MoveAbsJ myJointTarget,v100,z10,ToolAJATCP\WObj:=WOAJA;
    ENDPROC
    
    
    PROC MovePosL()
        posMoveL:=CRobT(\Tool:=tool0 \WObj:=wobj0);
        posMoveL.trans.x:=posMoveL.trans.x+MOVEPOSX;
        posMoveL.trans.y:=posMoveL.trans.y+MOVEPOSY;
        posMoveL.trans.z:=posMoveL.trans.z+MOVEPOSZ;
        MoveL posMoveL,v50,z5,tool0\WObj:=wobj0;
    ENDPROC
    
    PROC MovePosLInt()
        posMoveL:=CRobT(\Tool:=tool0 \WObj:=wobj0);
        posMoveL.trans.x:=posMoveL.trans.x+DINT_MX-1000;
        posMoveL.trans.y:=posMoveL.trans.y+DINT_MY-1000;
        posMoveL.trans.z:=posMoveL.trans.z+DINT_MZ-1000;
        MoveL posMoveL,v50,z5,tool0\WObj:=wobj0;
    ENDPROC
    
    PROC CortadoFull()
        Pegado;
        ToHomeR;   
        ToHomeR;
        Cortado;
    ENDPROC
    
    PROC Pegado()
        !MoveJ Target_10,v200,fine,MyTool\WObj:=Workobject_1;
        !MoveJ Target_20,v200,fine,MyTool\WObj:=Workobject_1;
        !MoveJ Target_30,v200,fine,MyTool\WObj:=Workobject_1;
        !MoveJ Target_40,v200,fine,MyTool\WObj:=Workobject_1;
        !MoveJ Target_10,v200,fine,MyTool\WObj:=Workobject_1;
    ENDPROC
    PROC Cortado()
        !MoveJ Target_50,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_70,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Centro,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_80,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_60,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Centro,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_120,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_100,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Centro,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_90,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Target_110,v200,fine,MyTool\WObj:=Workobject_2;
        !MoveJ Centro,v200,fine,MyTool\WObj:=Workobject_2;
    ENDPROC
    

ENDMODULE