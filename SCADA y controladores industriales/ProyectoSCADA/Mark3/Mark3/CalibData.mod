MODULE CalibData
    !rut A
    PERS tooldata ToolAJATCP:=[TRUE,[[71.4,0,67.85],[0.819152044,0,0.573576436,0]],[0.1,[0,0,1],[1,0,0,0],0,0,0]];
    !rut balde
    PERS tooldata TD_Hook:=[TRUE,[[68.38,0,60],[0.707106781,0.707106781,0,0]],[0.2,[28.798,-0.092,56.062],[1,0,0,0],0,0,0]];
	PERS tooldata TD_SuctionPad:=[TRUE,[[93.75,0,168.37],[0.970295726,0,0.241921896,0]],[0.2,[28.798,-0.092,56.062],[1,0,0,0],0,0,0]];
    PERS tooldata TD_SuctionPad2:=[TRUE,[[93.75,0,168.37],[0.970295726,0,0.241921896,0]],[0.2,[28.798,-0.092,56.062],[1,0,0,0],0,0,0]];
	
    !rut balde
    TASK PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[-200,-850,260],[1,0,0,0]],[[475,140,0],[1,0,0,0]]];
	TASK PERS wobjdata Workobject_Balde_Piso:=[FALSE,TRUE,"",[[600,0,30],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    !rut A
    TASK PERS wobjdata WOAJA:=[FALSE,TRUE,"",[[500,204.716,213.45],[0,0,-0.374478973,0.927235406]],[[0,0,0],[1,0,0,0]]];
    !rut corazon
    TASK PERS wobjdata MiMarcoDeCorazon:=[FALSE,TRUE,"",[[-120,100,70],[0.923879533,0,0,0.382683432]],[[0,0,93],[1,0,0,0]]];
ENDMODULE