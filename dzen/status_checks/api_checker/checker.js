var express = require('express');
var http = require('http');
var app = express();
var bodyParser = require('body-parser');
var request = require('request');
var CronJob = require('cron').CronJob;
// En las lÃ­neas anteriores importamos los paquetes necesarios
// y asignamos variables para manejarlos

'use strict';

const
    { spawn } = require( 'child_process' ),
    ls = spawn( 'ls', [ '-lh', '/usr' ] );

ls.stdout.on( 'data', data => {
    console.log( `stdout: ${data}` );
} );

ls.stderr.on( 'data', data => {
    console.log( `stderr: ${data}` );
} );

ls.on( 'close', code => {
    console.log( `child process exited with code ${code}` );
} );

var sampleJson = {
	"ciudades" : {
		"ciud01":
		{	
			"nombre": "Madrid",
			"habitantes": "3000000",
			"temperatura": "25"
		},
		"ciud02":
		{	
			"nombre": "León",
			"habitantes": "150000",
			"temperatura": "20"
		},
		"ciud03":
		{	
			"nombre": "Oviedo",
			"habitantes": "500000",
			"temperatura": "18"
		}
	}
};


// Endpoint â€œ/â€ mediante la operaciÃ³n GET - http://localhost:3000/
// aquÃ­ devolveremos un mensaje de bienvenida
// podrÃ­amos poner tambiÃ©n instrucciones de cÃ³mo acceder a otros datos con nuestra API
app.get('/', function (req, res) { 
	res.send('¡Bienvenido a mi web service!');
});

// Endpoint /getjson que devuelve como resultado el json completo
// al realizar una peticiÃ³n GET - http://localhost:3000/getjson
app.get('/getjson', function (req, res) { 
	res.json(sampleJson);
	console.log(sampleJson.ciudades.ciud02.habitantes);
});

app.get('/getjson/:idC', function (req, res) {
res.json(sampleJson.ciudades[req.params.idC]);
});

app.put('/cambiaHab/:idCiud', function (req, res) {
//Para comprobar lo que está llegando en el cuerpo del mensaje
//podemos utilizar la siguiente sentencia
console.log(req.body);
//Se recoge el valor del campo "numHabNuevo" que llega en el cuerpo (body)
//parseado como JSON (ver instrucción app.use más arriba)
hN = req.body.numHabNuevo;
//Cambiamos el valor del campo de la ciudad elegida
//Otra forma: sampleJson.ciudades[req.params.idCiud]['habitantes'] = hN;
sampleJson.ciudades[req.params.idCiud].habitantes = hN;
res.send('HECHO!');
});

app.delete('/borraciudad/:idC', function(req, res) {
delete sampleJson.ciudades[req.params.idCiud];
res.send('HECHO');
});

app.get('/consultaTemperatura/:idC', function (req, res) {
res.json(sampleJson.ciudades[req.params.idC].temperatura);
});


//Checker Bitcoin
const BitJob = new CronJob('* * * * *', function() {

console.log("Ejecutando BitChecker");
var btcOpt = { method: 'GET',
	url: '',
	qs: { 'api_key':
	'4b317611-50aa-4412-8675-a778c818c413'
	},
	headers: { 'cache-contro':'no-cache'}
	};
request(options, function (errorBtc,responseBtc,bodyBtc) {
if (errorBtc) throw new Error(errorBtc);
console.log(body);
bodyBtc = JSON.parse(bodyBtc);
urlBtcData = bodyBtc.datos;
console.log(urlBtcData);

//Segundo GET
var btcOpt2 = { method: 'GET',
	url:urlBtcData,
	headers: {'cache-control':'no-cache'}
	};
request(btcOpt2, function(errorBtc2, responseBtc2,bodyBtc2){
if (errorBtc2) throw new Error(errorBtc2);
bodyBtc2=JSON.parse(bodyBtc2);

//Parsing


//


////

for (var i = 0; i < body2B.length; i++){
 var temp;
 if (body2B[i].idema == '2661'){
console.log('Encontrado');
console.log(body2B[i].ta);
//temp irá tomando los valores de temperatura en las
// diferentes horas la última que tome será la más reciente
temp = body2B[i].ta
 }
 //Actualizamos la temperatura de León en nuestro objeto Json
 sampleJson.ciudades.ciud01.temperatura = temp;
}
//////// Lo mismo para las otras ciudades ///////////////
});
});
}, function() {
 // Código a ejecutar cuando la tarea cron termina.
}, true);
// Iniciamos la tarea cron directamente
job.start();
///

// Patrón de cron
// Se crea una tarea programada para que se realice cada cierto tiempo
// consultar la documentación para ver las opciones de intervalos que se pueden indicar
const job = new CronJob('* * * * *', function() {
// Código a ejecutar
console.log("Voy a solicitar temperaturas");
/**********************************************************************/
/************* Primero consultamos con la API de AEMET **************/
/**********************************************************************/
var options = { method: 'GET',
//Este es el endpoint que nos ha indicado la AEMET
url: 'https://opendata.aemet.es/opendata/api/observacion/convencional/todas',
//Aquí va la API Key que hemos obtenido en la página
qs: { 'api_key': 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqY3VyYnIwMEBlc3R1ZGlhbnRlcy51bmlsZW9uLmVzIiwianRpIjoiZmMwNjhmYjMtMzJlYi00NzI4LWI5YWItNjNjNzkxYmFhYWY4IiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE1NDQwMDAyOTQsInVzZXJJZCI6ImZjMDY4ZmIzLTMyZWItNDcyOC1iOWFiLTYzYzc5MWJhYWFmOCIsInJvbGUiOiIifQ.wYv-3PRn_sLHwqnCVf-YEowXWYR8qsrcKLzdGCiF93U' },
headers:
{ 'cache-control': 'no-cache' } };
//Hacemos la petición y obtenemos el resultado en el objeto body
request(options, function (error, response, body) {
if (error) throw new Error(error);
console.log(body);
//Procesamos el body como Json
bodyB = JSON.parse(body);
//Nos quedamos con el campo "datos", que será una URL
//Esta URL nos apunta al documento que tiene los datos meteorológicos
urlDatos = bodyB.datos;
console.log(urlDatos);
/**********************************************************************/
/*** Segunda petición GET para descargar el documento con los datos ***/
/***************************************/

//Ahora lanzamos una segunda petición para descargar estos datos
//Sólo necesitaremos lanzar un GET a la URL que nos han indicado
var options2 = { method: 'GET',
url: urlDatos,
headers:
{ 'cache-control': 'no-cache' } };
//Obtenemos la respuesta en el objeto body2
request(options2, function (error2, response2, body2) {
if (error2) throw new Error(error2);
//console.log(body2);
//Procesamos el cuerpo como Json
body2B = JSON.parse(body2);
//Buscamos la estación que nos interesa
//con el código y la temperatura del día de hoy a las 07:00 am
// Los datos se han recibido en una estructura tipo array
// por lo que recorremos cada elemento
/////////////////////////
/////// Para LEON ///////
/////////////////////////
for (var i = 0; i < body2B.length; i++){
 var temp;
 if (body2B[i].idema == '2661'){
console.log('Encontrado');
console.log(body2B[i].ta);
//temp irá tomando los valores de temperatura en las
// diferentes horas la última que tome será la más reciente
temp = body2B[i].ta
 }
 //Actualizamos la temperatura de León en nuestro objeto Json
 sampleJson.ciudades.ciud01.temperatura = temp;
}
//////// Lo mismo para las otras ciudades ///////////////
});
});
}, function() {
 // Código a ejecutar cuando la tarea cron termina.
}, true);
// Iniciamos la tarea cron directamente
job.start();


// Arrancamos el servidor escuchando en el puerto 3000
app.listen(60137, function () { 
	console.log('¡Aplicación escuchando en el puerto 3000!');
});


