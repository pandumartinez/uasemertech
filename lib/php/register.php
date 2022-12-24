<?php
date_default_timezone_set("Asia/Jakarta");
header("Access-Control-Allow-Origin: *");
$arr = null;
#$conn = new mysqli("localhost", "root", "", "flutter_movie");
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
    $arr = ["result" => "error", "message" => "unable to connect"];
}

extract($_POST);

$lname = null;
$regis_date = date("Y-m-d");
$url = null;
$sql = "INSERT INTO users (username, first_name, last_name, password, registration_date, url_image) VALUES (?,?,?,?,?,?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssss", $username, $username, $lname, $password, $regis_date, $url);
$stmt->execute();
if ($stmt->affected_rows > 0) {
    $arr = ["result" => "success", "message" => "account created"];
} else {
    $arr = ["result" => "error", "message" => "sql error:".$stmt->error];
}
echo json_encode($arr);
$stmt->close();
$conn->close();