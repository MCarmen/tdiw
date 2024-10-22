<?php
include_once __DIR__ . "/connectaBD.php";
$con = connectaBD() or die("DB Error");
$result = pg_query($con, "select * from graus") or die("SQL Error");
$rows = pg_fetch_all($result);
foreach ($rows as $row) {
  echo "<option value='{$row['id']}'>{$row['nom']}</option>";
}
pg_close($con);
?>