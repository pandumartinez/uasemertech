<?php
header("Access-Control-Allow-Origin: *");
$arr = [];
#$conn = new mysqli("localhost", "root", "", "flutter_movie");
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
    $arr = ["result" => "error", "message" => "unable to connect"];
}

extract($_POST);
if(isset($user_password)){
  $sql = "SELECT * FROM users where username = ? and password = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("ss", $user_id, $user_password);
  $stmt->execute();
  $result = $stmt->get_result();
  if ($result->num_rows > 0) {
      $r = mysqli_fetch_assoc($result);
      $arr = ["result" => "success", "data" => $r];
  } else {
      $arr = ["result" => "error", "message" =>  "sql error:".$stmt->error];
  }
}else{
  $sql = "SELECT * FROM users where username = ?";
  $stmt = $conn->prepare($sql);
  $stmt->bind_param("s", $user_id);
  $stmt->execute();
  $result = $stmt->get_result();
  if ($result->num_rows > 0) {
      $r = mysqli_fetch_assoc($result);
      $arr = ["result" => "success", "data" => $r];
  } else {
      $arr = ["result" => "error", "message" =>  "sql error:".$stmt->error];
  }
}

echo json_encode($arr);
$stmt->close();
$conn->close();