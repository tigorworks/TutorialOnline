<?php
/*
	CREATED BY TIGOR MANURUNG
*/
	//setup koneksi db
	$conn=mysql_connect('localhost','root','');
	mysql_select_db('plearning',$conn);
	
	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
		$tipedata=$_POST['tipe'];
		$id=$_POST['id'];
		
		switch($tipedata){
			case 'model':
				$sql='SELECT id,nama FROM '.$tipedata.' WHERE kendaraan_id = "'.$id.'" ORDER BY nama ASC';break;
			case 'merk':
				$sql='SELECT id,nama FROM '.$tipedata.' WHERE model_id = "'.$id.'" ORDER BY nama ASC';break;
			case 'kendaraan':
				$sql='SELECT id,nama FROM '.$tipedata.' ORDER BY nama ASC';break;
		}
		
		$res = array(); //reson variable yang akan digunakan
		/*if ($tipedata != 'kendaraan'){
			$res['error']='error : '.$sql;	
			die(json_encode($res));
		}*/
		
		$kueri=mysql_query($sql);
		if($kueri){
			if(mysql_num_rows($kueri) > 0){
				while($row=mysql_fetch_object($kueri)){
					$res[]=$row;
				}
			}else{
			$res['error']='Data tidak ditemukan';	
			}
		}else{
		$res['error']='error server : '.mysql_error();	
		}
	}
	die(json_encode($res));
?>