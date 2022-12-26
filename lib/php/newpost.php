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
$stmt1->bind_param("s", $username);
$stmt1->execute();
$result = $stmt1->get_result();
if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);
    $creator_id = $r["user_id"];
} else {
    $arr = ["result" => "error", "message" =>  "sql error:".$stmt->error];
}

$sql = "INSERT INTO memes (url_image_meme, top_text, bottom_text, creator_id, number_likes) VALUES (?,?,?,?,?)";

$stmt = $conn->prepare($sql);
$number_likes = 0;
$stmt->bind_param("sssii", $url_image_meme, $top_text, $bottom_text, $creator_id,$number_likes);
$stmt->execute();
if ($stmt->affected_rows > 0) {
    $arr = ["result" => "success", "message" => "post have been posted"];
} else {
    $arr = ["result" => "error", "message" => "sql error:".$stmt->error];
}
echo json_encode($arr);
$stmt->close();
$conn->close();