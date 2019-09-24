var express = require('express');
var http = require('http');
var app = express();
var request = require('request');
var CronJob = require('cron').CronJob;
const rp = require('request-promise');
const fs = require('fs');


'use strict';

const
    { spawn } = require( 'child_process' );

app.get('/', function (req, res) { 
	res.send('¡Bitchecker webservice!');
});

var values = {
	"Value" : "0"
};

// Endpoint /getvalue returns de value of the bitcoin
// GET - http://localhost:60138/getvalue
app.get('/getvalue', function (req, res) { 
	res.json(values);
	console.log(values);
});
spawn( './gilfoyle.sh' );
//Checker Bitcoin
const BitJob = new CronJob('*/5 * * * *', function() {

console.log("Ejecutando BitChecker");

const requestOptions = {
  method: 'GET',
  uri: 'https://api.coinmarketcap.com/v1/ticker/bitcoin/',
  qs: {
    start: 1,
    limit: 5000,
    convert: 'USD'
  },
  headers: {
    'X-CMC_PRO_API_KEY': '4b317611-50aa-4412-8675-a778c818c413'
  },
  json: true,
  gzip: true
};

rp(requestOptions).then(response => {
  price=response[0].price_usd
  console.log('Value for bitcoin: ', price);
  console.log('Last Value: ',values.Value);
  
  if(response[0].price_usd<values.Value) {
	spawn( './gilfoyle.sh' );
	values.Value=price;
	fs.writeFileSync("/tmp/status_bitcoin", "0", function(err) {
	    if(err) {
	        return console.log(err);
	    }
	    console.log("The file was saved!");
	});
  } else {
	values.Value=price;
	fs.writeFileSync("/tmp/status_bitcoin", "1", function(err) {
	   if(err) {
        	return console.log(err);
    	   }
    	   console.log("The file was saved!");
       });
}

}).catch((err) => {
  console.log('API call error:', err.message);
});

});

BitJob.start();


// Arrancamos el servidor escuchando en el puerto 3000
app.listen(60138, function () { 
	console.log('Listening on port 60138!');
});


