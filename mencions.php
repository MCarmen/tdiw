<?php
include_once __DIR__ . "/connectaBD.php";
$connexio = connectaBD();
$sql_mencions = "SELECT id,nom FROM mencions WHERE grau=" . $_GET['grau'];
$consulta_mencions = pg_query($connexio, $sql_mencions) or die("Error sql");
$resultat_mencions = pg_fetch_all($consulta_mencions);
foreach($resultat_mencions as $fila){
	echo "<option value='" . $fila['id'] . "'>" . $fila['nom'] . "</option>\n";
}
pg_close($connexio);
?>
