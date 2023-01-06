<?php
header('Access-Control-Allow-Origin: *');
$name = $_POST['name'];
$img = base64_decode($_POST['image']);
if(file_put_contents("img/meme/".$name.".jpg", $img))
{
    echo "Meme uploaded";
}
else
{
    echo "Meme failed to uploaded";
}
?>