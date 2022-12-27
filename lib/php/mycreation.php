<?php
header("Access-Control-Allow-Origin: *");
$arr = null;
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
    $arr = ["result" => "error", "message" => "unable to connect"];
}

extract($_POST);

$sql = "SELECT * FROM memes INNER JOIN users 
ON memes.creator_id = users.user_id where username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();
$data = [];
if ($result->num_rows > 0) {
    while ($r = $result->fetch_assoc()) {
        array_push($data, $r);
    }
    $arr = ["result" => "success", "data" => $data];
} else {
    $arr = ["result" => "error", "message" => "sql error: $sql"];
}
echo json_encode($arr);
$stmt->close();
$conn->close();
