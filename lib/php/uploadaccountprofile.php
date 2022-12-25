<?php
header('Access-Control-Allow-Origin: *');
$username = $_POST['username'];
$img = base64_decode($_POST['image']);
if(file_put_contents("img/user/".$username.".jpg", $img))
{
    echo "User profile picture uploaded";
}
else
{
    echo "Profile picture failed to uploaded";
}
?>
