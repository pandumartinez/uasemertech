<?php
    header("Access-Control-Allow-Origin: *");
    $arr = [];
    #$conn = new mysqli("localhost", "root", "", "flutter_movie");
    $conn = new mysqli("localhost", "flutter_160419096", "ubaya", "flutter_160419096");
    if ($conn->connect_error) {
        $arr = ["result" => "error", "message" => "unable to connect"];
    }

    extract($_POST);

    $sql="UPDATE users set first_name=? , last_name=?, url_image=? where username=?";
    $stmt=$conn->prepare($sql);
    $stmt->bind_param("ssss",$first_name,$last_name,$url_image,$username);
    $stmt->execute();
    if ($stmt->affected_rows > 0) {
        $arr=["result"=>"success","id"=>$conn->insert_id];
    } else {
        $arr=["result"=>"fail","Error"=>$conn->error];
    }
    echo json_encode($arr);

    $stmt->close();
    $conn->close();
?>