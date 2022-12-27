<?php
    header("Access-Control-Allow-Origin: *");
    $arr = [];
    #$conn = new mysqli("localhost", "root", "", "flutter_movie");
    $conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
    if ($conn->connect_error) {
        $arr = ["result" => "error", "message" => "unable to connect"];
    }

    extract($_POST);

    $id = (int)$id;

    $sql="UPDATE memes set number_likes = number_likes + 1 WHERE meme_id=?";
    $stmt=$conn->prepare($sql);
    $stmt->bind_param("i",$id);
    $stmt->execute();
    if ($stmt->affected_rows > 0) {
        $arr=["result"=>"success","message"=>"post liked"];
    } else {
        $arr=["result"=>"fail","Error"=>$conn->error];
    }
    echo json_encode($arr);

    $stmt->close();
    $conn->close();
?>