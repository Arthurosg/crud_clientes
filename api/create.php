<?php
include 'db.php';

$data = json_decode(file_get_contents("php://input"));

$nome = $data->nome;
$email = $data->email;
$telefone = $data->telefone;
$endereco = $data->endereco;

$sql = "INSERT INTO clientes (nome, email, telefone, endereco) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $nome, $email, $telefone, $endereco);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false]);
}
?>



