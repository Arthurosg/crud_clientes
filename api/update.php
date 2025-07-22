<?php
include 'db.php';

$data = json_decode(file_get_contents("php://input"));

$id = $data->id;
$nome = $data->nome;
$email = $data->email;
$telefone = $data->telefone;
$endereco = $data->endereco;

$sql = "UPDATE clientes SET nome=?, email=?, telefone=?, endereco=? WHERE id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssi", $nome, $email, $telefone, $endereco, $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false]);
}
?>
