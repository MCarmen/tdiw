<?php
include_once __DIR__ . "/connectaBD.php";
$con = connectaBD() or die("DB Error");
/* if(isset($_REQUEST['grau'])){
  $grau = $_REQUEST['grau'];
}else{
  $grau = 1;
} */
//ternary operator
$grau = (isset($_REQUEST['grau'])) ? $_REQUEST['grau'] : 1;
$result = pg_query($con, "select * from mencions where grau=$grau") or die("SQL Error");
$rows = pg_fetch_all($result);
foreach ($rows as $row) {
  echo "<option value='{$row['id']}'>{$row['nom']}</option>";
}
pg_close($con);
?>