<?php
//konek ke db
  $dbhost = 'localhost';
  $dbuser = 'root';
  $dbpass = '';
  
  $conn = mysql_connect($dbhost, $dbuser, $dbpass);
  if (!$conn) {
    die('Could not connect: ' . mysql_error());
}

  $dbname = 'plearning';
  mysql_select_db($dbname);
  
  
  $sql='INSERT INTO karyawan(nip,nama)VALUES("'.$_POST['nip'].'","'.$_POST['nama'].'")';
  $kueri = mysql_query($sql) or die('<font color="red">input data error!</font>');
  
  echo '<font color="blue">Input data berhasil!</font>';
?>