var gen_fake = require('faker');
// connnect to MySQL server
var mysql = require('mysql');
var connection = mysql.createConnection({
	host : 'localhost',
	user : 'root',
	database : 'project_db'
});

/*
// example of connecting to SQL server frm node.js
var query = 'SELECT CURTIME() AS time, CURDATE() AS date, NOW() AS now'; // quries to run in SQL
connection.query(query, function(error, results, fields){
	if (error) throw error;
	console.log(results[0].time);
	console.log(results[0].data);
	conmsole.log(results[0].now);
}); // output results

// example of selecting rows from the SQL table
var query = 'SELECT * FROM users'; // quries to run in SQL
connection.query(query, function(error, results, fields){
	if (error) throw error;
	console.log(results);
});
connection.end();

//inserting data from node to SQl using FAKER package
var person = {
	email:faker.internet.email(),
	created_at:faker.date.past()
};

var end_result = connection.query('INSERT INTO users SET ?', person, function(err, result) {
  if (err) throw err;
  console.log(result);
});
*/

//inserting 500 ransom users into db
var data = [];
for(var i=0; i<500; i++){
	data.push([
		gen_fake.internet.email(),
		gen_fake.date.past()
	]);
}

var query = 'INSERT INTO users (email, created_at) VALUES ?';

connection.query(query,[data],function(err, result){
		console.log(err);
		console.log(result);
});
connection.end();

