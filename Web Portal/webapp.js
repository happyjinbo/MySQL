var express = require('express');
var webapp = express();
var mysql = require('mysql');
var bodyparser = require('body-parser');
var connection = mysql.createConnection({
	host : 'localhost',
	user : 'root',
	database : 'project_db'
});

webapp.set("view engine","ejs"); //setting up HTML file called ejs
webapp.use(bodyparser.urlencoded({extended: true})); // used for parsing what the user input to the JS to manipulate
webapp.use(express.static(__dirname + "/styling")); //connects the webapp to the styling CSS file
/*
// quick example for responding from the web page
webapp.get("/random_number", function(req, res){
		var num = Math.floor((Math.random() * 10)+1);
		res.send("The random number is " + num);
		});

webapp.listen(process.env.PORT || 3000, process.env.IP, () => {
	console.log('Web Page Works @ port 3000.')
});
*/

//count total users so far when user opens the website
webapp.get("/", function(req,res){
	var count_total = "SELECT COUNT(*) AS headcount FROM users";
	connection.query(count_total, function(err,results){
		if(err) throw err;
		var headcount = results[0].headcount; //define a variable named headcount to show total users
		//res.send("We have  " + headcount + " users in our DB.");
		res.render("homepage",{totaluser: headcount}); //send results to the HTML file 
	});
});

//collect user email into the SQL db and returns to homepage when finished input
webapp.post("/register", function(req,res){
	var newguy = {email: req.body.email}; //requested the user input by body-parser
	connection.query('INSERT INTO users SET ?', newguy, function(err,result){
	if (err) throw err;
	res.redirect("/");		
	});
});

webapp.listen(process.env.PORT || 3000, process.env.IP, () => {
	console.log('Web Page Works @ port 3000.')
});


