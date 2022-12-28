<?php
header("Access-Control-Allow-Origin: *");
$arr = null;
$conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
if ($conn->connect_error) {
    $arr = ["result" => "error", "message" => "unable to connect"];
}

$id = $_POST['meme_id'];
$sql = "SELECT * FROM memes where meme_id = ? ";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
    $r = mysqli_fetch_assoc($result);
    //nanti ditaruh movie genre dsb..
    $sql2 = "SELECT * FROM users inner join meme_comments
            on users.user_id=meme_comments.user_id
            where meme_id=$id ";
    $stmt2 = $conn->prepare($sql2);
    $stmt2->execute();
    $users = [];
    $result2 = $stmt2->get_result();
    if ($result2->num_rows > 0) {
        while ($r2 = mysqli_fetch_assoc($result2)) {
            array_push($users, $r2);
        }
    }
    $r["users"] = $users;

    $arr = ["result" => "success", "data" => $r];
} else {
    $arr = ["result" => "error", "message" => "sql error: $sql"];
}
echo json_encode($arr);
$stmt->close();
$conn->close();
