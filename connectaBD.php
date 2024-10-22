<?php
function connectaBD(){
	$servidor = "localhost";
	$port = "5432";
	$DBnom = "myDB";
	$usuari = "david";
	$clau = "password";

	return  pg_connect("host=$servidor port=$port dbname=$DBnom user=$usuari password=$clau");
}
?>
