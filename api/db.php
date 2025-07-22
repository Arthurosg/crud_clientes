<?php
// Configurações do banco de dados
$host = "localhost";
$user = "root";
$pass = "123456";
$dbname = "crud_clientes";
$port = 3306; // porta padrão MariaDB

// Conexão com o banco de dados
$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Conexão falhou: " . $conn->connect_error);
}
?>

