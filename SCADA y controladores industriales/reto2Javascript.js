const query = msg.payload.content.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
var nombres = ["Bot_Start", "Bot_Stop", "Bot_Reset", "GD_IN_0", "GD_IN_1", "GD_IN_2", "GD_IN_3", "GD_IN_4", "GD_IN_5", "GD_IN_6", "GD_IN_7", "GD_IN_8", "GD_IN_9", "GD_IN_10", "GD_IN_11", "GD_IN_12", "GD_IN_13","GD_IN_14","GD_IN_15", "GD_OUT_0", "GD_OUT_1", "GD_OUT_2", "GD_OUT_3", "GD_OUT_4", "GD_OUT_5", "GD_OUT_6", "GD_OUT_7", "GD_OUT_8", "GD_OUT_9", "GD_OUT_10", "GD_OUT_11"];
const nombresEstados = ["Bot_Start", "Bot_Stop", "Bot_Reset","Moving X", "Moving Z", "Item detected", "Lid at place", "Lid clamped", "Pos. at limit (lids)", "Base at place", "Base clamped", "Pos. at limit (bases)", "Part leaving","Start", "Reset", "Stop","Emergency stop", "Auto","FACTORY I/O RUNNING","Move X", "Move Z", "Grab", "Lids conveyor", "Clamp lid", "Pos. raise (lids)", "Bases conveyor", "Clamp base", "Pos. raise (bases)", "Start light", "Reset light", "Stop light"]
const nombreSensores = ["Moving X", "Moving Z", "Item detected", "Lid at place", "Lid clamped", "Pos. at limit (lids)", "Base at place", "Base clamped", "Pos. at limit (bases)", "Part leaving","Start", "Reset", "Stop","Emergency stop", "Auto"]
const nombreActuadores =["Move X", "Move Z", "Grab", "Lids conveyor", "Clamp lid", "Pos. raise (lids)", "Bases conveyor", "Clamp base", "Pos. raise (bases)"]
const nombreIndicadores=["Start light", "Reset light", "Stop light"]
const nombreQR = ["qr", "compartir", "share"];
var valores = [];
var estados = {};
var estado = -1;
var msg2 = {payload: null};


function actualizarTodosLosEstados(){
    for (var i = 0; i < nombres.length; i++) {
        estados[nombresEstados[i]] = flow.get(nombres[i]);
    }
}

function actualizarEstados(ArrayStrings) {
    ArrayStrings.forEach((estado) => {
      const index = nombresEstados.indexOf(estado);
      if (index > -1) {
        estados[nombresEstados[index]] = flow.get(nombres[index]);
      }
    });
  }

function actualizarEstado(estado){
    estado =nombresEstados.indexOf(estado);
    if(estado > -1){estados[nombresEstados[estado]] = flow.get(nombres[estado]);}
}



function obtenerValorEstado(nombreEstado) {
    actualizarEstados();
    for (var i = 0; i < nombresEstados.length; i++) {
      if (nombresEstados[i] === nombreEstado) {
        return valores[i];
      }
    }
    return null; // Si el nombre de estado no se encuentra en la lista, retorna null
}
  


var valorAuto = 0;
//Palabras clave
const saludos = ["hola", "buen dia", "¿como estas?", "que tal", "saludos", "buenos dias", "buenas tardes", "buenas noches", "¿que onda?", "buenas", "que hubo", "hey", "hello", "hi", "¿como te va?"];
const despidos = ["adios", "hasta luego", "nos vemos", "chao", "bye", "adiós", "hasta la vista", "hasta pronto", "cuidate", "cuídate"];
const keywordsDatasheet = ["hoja tecnica","datos tecnicos","ficha tecnica","informacion tecnica","especificaciones tecnicas","caracteristicas tecnicas","datos del motor","ficha del motor","informacion del motor","especificaciones del motor"];
const autorKeywords = ["creditos", "equipo", "desarrolladores", "creadores", "autores", "quienes lo hicieron", "responsables"];
const arrancarKeywords = ["iniciar", "encender", "arrancar", "activar", "conectar", "encendido", "inicio", "comenzar", "poner en marcha", "prender","on"];
const detenerKeywords = ["detener", "apagar", "parar", "desactivar", "desconectar", "apagado", "fin", "terminar", "off"];
const resetKeywords = ["reset", "reiniciar", "restaurar", "borrar", "reestablecer", "volver a cero", "limpiar", "formatear", "inicializar", "poner en blanco"];
const estadosKeywords = ["estado", "condicion", "situacion", "posicion", "status", "contexto", "forma", "configuracion", "disposicion", "orden"];

const sensorKeywords = ["sensor", "medicion", "deteccion", "dispositivo", "instrumento", "monitorizacion", "captacion", "registro"]
const actuadorKeywords = ["actuador","mecanismo","actuacion","motor","movimiento","válvula"];
const preguntarModoKeywords = ["modo", "estado", "situacion", "condicion", "funcionamiento", "operativo", "actividad", "configuracion", "estatus", "status"];
const sinonimosPlanta = ["fabrica", "assembler","escena","planta","instalacion","de fabricacion","de produccion"];
var saludado = flow.get('saludado') || false;



//Saludo
if (saludos.some(opcion => query.includes(opcion))) {
    flow.set('Id',msg.payload.chatId);
    saludado = true;
    flow.set('saludado', saludado);
    msg.payload.content = "¡Hola! Soy tu ChatBot en Telegram diseñado par ayudarte con la banda IoT. Estoy aquí para ayudarte con todas tus necesidades en la automatización de la planta. Aquí está todo lo que puedes/debes hacer conmigo:\nEscanear un código QR para acceder al Bot.\n¡Estoy aquí para ayudarte en todo lo que necesites en la automatización de la planta! ¡Ponte en contacto conmigo para comenzar!";
    return [msg, msg2];
}

//Verificar saludo
if (!saludado) {
    msg.payload.content = "Por favor, saluda primero antes de enviar otro mensaje.";
    return [msg, msg2];
}

//Después de saludar se puede ejecutar el resto de acciones

//Ficha técnica motor
else if (msg.payload.chatId == flow.get('Id')&&keywordsDatasheet.some(keyword => query.includes(keyword))) {
    msg.payload.content = "Por supuesto, aquí está la hoja técnica del motor:";
    msg.payload.options = {
        "parse_mode": "HTML",
        "disable_web_page_preview": false
    };
    //msg.payload.content += " <a href='https://drive.google.com/uc?id=18QV1U9kbxzodBzeq39pgo4A5s0s-TIb1'>Descarga aquí</a>"; datasheet de otro motor
    msg.payload.content += " <a href='https://drive.google.com/file/d/1dH1IutBYw8Z17fCy_7HsJRAzqkKRZ5CT/view?usp=sharing'>Descarga aquí</a>";
    return [msg, msg2];
}

//Está prendida y en modo automático?
else if (msg.payload.chatId == flow.get('Id') &&preguntarModoKeywords.some(keyword => query.includes(keyword))&&sinonimosPlanta.some(keyword => query.includes(keyword))) {
    actualizarEstado("FACTORY I/O RUNNING");
    actualizarEstado("Auto");
    msg.payload.content=(estados[nombresEstados[nombresEstados.indexOf("FACTORY I/O RUNNING")]]? "Planta prendida 🟢 \n" :"Planta apagada 🔴\n" )+(estados[nombresEstados[nombresEstados.indexOf("Auto")]]? "Modo automático" :"Modo manual" );
    return [msg, msg2];
}

//Enviar commando de arrancar
else if (msg.payload.chatId == flow.get('Id') &&arrancarKeywords.some(keyword => query.includes(keyword))) {
    actualizarEstado("Auto");
    if(estados[nombresEstados[nombresEstados.indexOf("Auto")]]){
        msg.payload.content = "Comando de arranque recibido";
        msg2.payload = "ON";
        return [msg, msg2];
    }else{
        msg.payload.content = "La planta no está en modo automático";
        return [msg, msg2];
    }
}

//Enviar commando de parada
else if (msg.payload.chatId == flow.get('Id') &&detenerKeywords.some(keyword => query.includes(keyword))) {
    actualizarEstado("Auto");
    if(estados[nombresEstados[nombresEstados.indexOf("Auto")]]){
        msg.payload.content = "Comando de arranque recibido";
        msg2.payload = "OFF";
        return [msg, msg2];
    }else{
        msg.payload.content = "La planta no está en modo automático";
        return [msg, msg2];
    }
} 

//Enviar commando de reset
else if (msg.payload.chatId == flow.get('Id') &&resetKeywords.some(keyword => query.includes(keyword))) {
    actualizarEstado("Auto");
    if(estados[nombresEstados[nombresEstados.indexOf("Auto")]]){
        msg.payload.content = "Comando de arranque recibido";
        msg2.payload = "RESET";
        return [msg, msg2];
    }else{
        msg.payload.content = "La planta no está en modo automático";
        return [msg, msg2];
    }
}

//Enviar una foto de los autores
else if (msg.payload.chatId == flow.get('Id') &&autorKeywords.some(keyword => query.includes(keyword))) {
    msg.payload.type = "photo";
    msg.payload.content = "https://i.ibb.co/QD6hHsn/The-Last-Warriors.png";
    msg.payload.caption = "Los autores son:\nAndres Holguín\nSara Jimenez\nNicolas Apellido";
    return [msg, msg2];
} 


//Enviar una foto del QR
else if (msg.payload.chatId == flow.get('Id') &&nombreQR.some(keyword => query.includes(keyword))) {
    msg.payload.type = "photo";
    msg.payload.content = "https://drive.google.com/file/d/1W08YhoRDQg3QXaURkaVetjpLSA91Zd00/view";
    msg.payload.caption = "https://t.me/DreamTeamScada_bot";
    return [msg, msg2];
} 

//Enviar resument de estado sensores
else if (msg.payload.chatId == flow.get('Id') &&estadosKeywords.some(keyword => query.includes(keyword))&&sensorKeywords.some(keyword => query.includes(keyword))) {
    var contentMsg = "Claro, acá están los estados de los sensores:\n";
    actualizarEstados(nombreSensores);
    for (var i = 0; i < nombreSensores.length; i++) {
        (estados[nombreSensores[i]]? contentMsg += nombreSensores[i] + ": " + "🟢" + "\n":contentMsg += nombreSensores[i] + ": " + "🔴" + "\n")
    }
    msg.payload.content=contentMsg;
    return [msg, msg2];
}

//Enviar resument de estado actuadores
else if (msg.payload.chatId == flow.get('Id') &&estadosKeywords.some(keyword => query.includes(keyword))&&sensorKeywords.some(keyword => query.includes(keyword))) {
    var contentMsg = "Claro, acá están los estados de los actuadores:\n";
    actualizarEstados(nombreActuadores);
    for (var i = 0; i < nombreActuadores.length; i++) {
        (estados[nombreActuadores[i]]? contentMsg += nombreActuadores[i] + ": " + "🟢" + "\n":contentMsg += nombreActuadores[i] + ": " + "🔴" + "\n")
    }
    msg.payload.content=contentMsg;
    return [msg, msg2];

}



//Enviar un resumen de todos los estados
else if (msg.payload.chatId == flow.get('Id') &&estadosKeywords.some(keyword => query.includes(keyword))) {
    var contentMsg = "Claro, acá están los estados de todas las variables de entorno:\n";
    actualizarTodosLosEstados();
    for (var i = 0; i < nombresEstados.length; i++) {
        (estados[nombresEstados[i]]? contentMsg += nombresEstados[i] + ": " + "🟢" + "\n":contentMsg += nombresEstados[i] + ": " + "🔴" + "\n")   
    }
    msg.payload.content=contentMsg;
    return [msg, msg2];
}

//Despedirse
else if (msg.payload.chatId == flow.get('Id') &&despidos.some(opcion => query.includes(opcion))) {
    flow.set('Id', msg.payload.chatId);
    msg.payload.content = "Hasta luego!\nMuchas gracias por utilizar la banda IoT";
    saludado = false;
    flow.set('saludado', saludado);
    return [msg, msg2];
}
else {
}