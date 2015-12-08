<?php
$result=mail("Deltar28@gmail.com","Письмо","С сайта было получено письмо с такими данными : \nИмя: $_POST[name] \nИмеил: $_POST[mail] \nСообщение: $_POST[mesage]");
if($result){ echo "<p>Сообщение было успешно отправлено!</p>";}
else{echo "<p>Сообщение НЕ было отправлено!</p>";}
?>