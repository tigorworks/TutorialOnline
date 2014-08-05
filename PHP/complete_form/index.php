<!--TIGOR MANGATUR MANURUNG-->
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/styles.css">
<link rel="stylesheet" type="text/css" href="css/demos.css">
<link rel="stylesheet" type="text/css" href="css/start/jquery-ui-1.8.20.custom.css">

<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.20.custom.min.js"></script>

<title>Programming Learning - Complete Form</title>
</head>
<body>

<div id="main">

<!--Dibawah ini adalah dialog setiap aksi-->

<div id="dialog-add" title="Tambah Data Karyawan">
	<form>
    <table border="0">
    <tr>
		<td><label for="nip">NIP</label></td>
		<td><input type="text" name="nipadd" id="nipadd" class="text ui-widget-content ui-corner-all" /></td>
    </tr>
    <tr>
		<td><label for="nama">Nama</label></td>
		<td><input type="text" name="namaadd" id="namaadd" value="" class="text ui-widget-content ui-corner-all" /></td>
    </table>
	</form>
</div>

<div id="dialog-edit" title="Edit Data Karyawan">
	<form>
    <table border="0">
    <tr>
		<td><label for="nip">NIP</label></td>
		<td><div id="nipedit"></div></td>
    </tr>
    <tr>
		<td><label for="nama">Nama</label></td>
		<td><input type="text" name="namaedit" id="namaedit" value="" class="text ui-widget-content ui-corner-all" /></td>
    </table>
	</form>
</div>

<div id="dialog-delete" title="Yakin hapus data?">
	<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><div id="isi">isi</div></p>
</div>

<!--Akhir dari dialog setiap aksi-->

<!--Table penampilan data-->

<div id="tablenya">
<table id="mytable" cellspacing="0">
<caption>Data Karyawan</caption>
<tr>
  <th scope="col">NIP</th>
  <th scope="col">Nama</th>
  <th scope="col">Aksi</th>
</tr>

<?php
	include "db.php";
	$sql = 'SELECT * FROM karyawan ORDER BY nip ASC';
	$kueri = mysql_query($sql);
	while ($baris = mysql_fetch_array($kueri)){
		echo "<tr>
		<td class='nipCell'>".$baris['nip']."</td>
		<td class='namaCell'>".$baris['nama']."</td>
		<td align='right'><a href='#' onClick=AddNew()>Add</a> |
		<a class='edit' href='#' onClick='EditData($(this))'>Edit</a> |
		<a class='delete' href='#' onClick='DeleteData($(this))'>Delete</a></td>
		</tr>";
	}
	
	
?>
</table>
<a href="#" onClick="AddNew()">Insert new data</a>
<!--Akhir dari table-->
</div>
<div id="waiting">
<p><img src="img/ajax-loader.gif"/> Saving data...</p>
</div>

<script>	
var
  objRow, //variable row yg diisi pada saat dialog edit
  nipdelete; //variable nip yang diisi pada saat event delete

<!--Dibawah ini adalah inisialisasi dialog jQuery-->
$("#waiting").hide();
//inisialisasi dialog tambah data
$( "#dialog-add" ).dialog({
	autoOpen: false,
	resizable: false,
	height: 200,
	width: 350,
	modal: true,
	buttons: {
		"Proses": function() {
			var
				//isi variable dengan input data yang telah diisi oleh user
				anip = $("input#nipadd").val();
				anama = $("input#namaadd").val();
				//aksi
				aact= 'insert';
				
			//event untuk melakukan POST/GET pada postdata.php melalui jQuery
			$.ajax({
				type: "POST", //definisikan aksinya (POST/GET)
				url: "postdata.php", //definisikan urlnya
				data: {"nip":anip,"nama":anama,"act":aact}, //data yang akan dikirim
				timeout: 10000, //timeout dari request
				beforeSend: function(){}, //event yang akan dieksekusi sebelum pengiriman data
				complete: function(){}, //event yang akan dieksekusi setelah pengiriman data
				cache: false, //cache
				success: function(result){ //event yang akan dieksekusi setelah data berhasil dikirim
					if (result=='success'){ //apabila respon dari postdata.php success maka
						var
						//link button aksi
						sbutton = "<td align='right'><a href='#' onClick=AddNew()>Add</a> | <a class='edit' href='#' onClick='EditData($(this))'>Edit</a> | <a class='delete' href='#' onClick='DeleteData($(this))'>Delete</a></td>";
						
						//isi data row baru
						s = '<tr><td class="nipCell">'+anip+'</td><td class="namaCell">'+anama+'</td>'+sbutton+'</tr>'; 
						
						//tambahkan row baru pada baris terakhir
						$('#mytable > tbody:last').append(s);																					

					}else{alert(result);}
					//close waiting
					$("#waiting").hide();	
				},
				error: function(error){alert('request timeout, please try again.');$( this ).dialog( "close" );} //event yang akan diseksekusi pada saat error berlangsung
				}
			);
			$("#waiting").show();
			$( this ).dialog( "close" );			
			
		},
		Cancel: function() {
			$( this ).dialog( "close" );
		}
	}
});

//inisialisasi dialog edit data
//penjelasan dari code ini hampir sama dengan dialog tambah data
$( "#dialog-edit" ).dialog({
	autoOpen: false,
	resizable: false,
	height: 200,
	width: 350,
	modal: true,
	buttons: {
		"Update": function() {
			var
				anip = $("#nipedit").html();
				anama = $("input#namaedit").val();
				aact= 'edit';
				
			$.ajax({
				type: "POST",
				url: "postdata.php",
				data: {"nip":anip,"nama":anama,"act":aact},
				timeout: 10000,
				beforeSend: function(){},
				complete: function(){},
				cache: false,
				success: function(result){
					if (result=='success'){
						//ubah isi data table sesuai dengan perubahan yang terjadi
						objRow.find(".namaCell").html($("input#namaedit").val());
						$("#waiting").hide();										

					}else{alert(result);}
				},
				error: function(error){$("#waiting").hide();alert('request timeout, please try again.');}
				}
			);
			$("#waiting").show();	
			$( this ).dialog( "close" );
			
		},
		Cancel: function() {
			$( this ).dialog( "close" );
		}
	}
});

//inisialisasi dialog hapus data
//penjelasan dari code ini hampir sama dengan dialog tambah data
$( "#dialog-delete" ).dialog({
	autoOpen:false,
	resizable: false,
	height:150,
	modal: true,
	buttons: {
		"Proses": function() {
			var
				aact= 'delete';				
			$.ajax({
				type: "POST",
				url: "postdata.php",
				data: {"nip":nipdelete,"act":aact},
				timeout: 10000,
				beforeSend: function(){},
				complete: function(){},
				cache: false,
				success: function(result){
					if (result=='success'){
						//hapus baris table yang terpilih
						objRow.remove();										
						
					}else{
						alert(result);
					}
					$("#waiting").hide();
				},
				error: function(error){alert('request timeout, please try again.');$("#waiting").hide();}
				}
			);
			$( this ).dialog( "close" );
			$("#waiting").show();
			
		},
		"Batal": function() {
			$( this ).dialog( "close" );
		}
	}
});

<!--Akhir dari inisialisasi dialog jQuery-->
		


<!--Dibawah ini adalah event handler dari setiap aksi (add,edit,delete)-->
function AddNew(){
	//untuk data baru, kosongkan fieldnya terlebih dahulu
	$("input#nipadd").val('');
	$("input#namaadd").val('');
	
	//buka dialog
	$( "#dialog-add" ).dialog("open");
}


function EditData(obj){
	var nip = obj.parent().parent().find(".nipCell").html();
	nama = obj.parent().parent().find(".namaCell").html();
	

	$("#nipedit").empty().append(nip);
	$("input#namaedit").val(nama);
	objRow = obj.parent().parent();	//simpan object row
	$( "#dialog-edit" ).dialog("open");
	
}

function DeleteData(obj){
	nipdelete = obj.parent().parent().find(".nipCell").html();
	$("#isi").empty().append('Apakah anda yakin akan menghapus data dengan nip : ' + nipdelete + ' ?');
	$( "#dialog-delete" ).dialog( "open" );	
	objRow = obj.parent().parent();	//simpan object row
}
<!--Akhir dari Event Handler-->

</script>


</div>

</body>
</html>