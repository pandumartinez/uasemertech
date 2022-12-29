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

$creator_id = "";

$sql1 = "SELECT * FROM users where username = ?";
$stmt1 = $conn->prepare($sql1);
$stmt1->bind_param("s", $user);
$stmt1->execute();
$result = $stmt1->get_result();
if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);
    $creator_id = $r["user_id"];
} else {
    $arr = ["result" => "error", "message" =>  "sql error:".$stmt->error];
}
$date = date("Y-m-d");

$sql = "INSERT INTO meme_comments (user_id, meme_id, comment_content, comment_date) VALUES (?,?,?,?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("iiss", $creator_id, $meme_id, $comment, $date);
$stmt->execute();
if ($stmt->affected_rows > 0) {
    $arr = ["result" => "success", "message" => "comment added"];
} else {
    $arr = ["result" => "error", "message" => "sql error:".$stmt->error];
}
echo json_encode($arr);
$stmt->close();
$conn->close();