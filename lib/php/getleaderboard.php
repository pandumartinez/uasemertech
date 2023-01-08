<?php
header("Access-Control-Allow-Origin: *");
$arr = null;
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
  $arr = ["result" => "error", "message" => "unable to connect"];
}
$sql = "SELECT user_id, url_image, first_name, last_name, creator_id, SUM(number_likes) as number_likes, url_image, is_private from users left join memes on users.user_id=memes.creator_id GROUP by user_id order by number_likes desc";
$stmt = $conn->prepare($sql);
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
