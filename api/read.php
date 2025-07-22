<?php
include 'db.php';

$result = $conn->query("SELECT * FROM clientes");
$clientes = [];

while ($row = $result->fetch_assoc()) {
    $clientes[] = $row;
}

echo json_encode($clientes);
?>
