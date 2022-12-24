<?php
header("Access-Control-Allow-Origin: *");
$arr = [];
#$conn = new mysqli("localhost", "root", "", "flutter_movie");
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
    $arr = ["result" => "error", "message" => "unable to connect"];
}

extract($_POST);
$sql = "SELECT * FROM users where username = ? and password = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $user_id, $user_password);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);
    $arr = ["result" => "success", "user_name" => $r['username']];
} else {
    $arr = ["result" => "error", "message" =>  "sql error:".$stmt->error];
}
echo json_encode($arr);
$stmt->close();
$conn->close();
