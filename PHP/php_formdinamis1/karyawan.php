<html>
<head>
<title>Form Input Karyawan</title>
<link rel="stylesheet" type="text/css" href="css/content.css" >
<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
</head>
<body>
<h2>INPUT DATA KARYAWAN</h2>
<form id="frminputkary" method="POST" action="postkary.php">
<table>
	<tr>
		<td>NIP</td><td><input type="text" id="txtnip" name="txtnip"/><div id="cnip"></td>
	</tr>
	<tr>
		<td>Nama</td><td><input type="text" id="txtnama" name="txtnama"/><div id="cnama"></td>
	</tr>
	<tr>
		<td></td><td><input type="submit" value="Proses"/></td>
	</tr>
</table>
</form>
<div id="result"></div>

<script>
  $("#frminputkary").submit(function(event) { //handle untuk form submit
    $( "#result" ).empty().append("Processing.. <img src='img/ajax-loader.gif'/>");
    //stop form untuk submit manual
    event.preventDefault(); 
      
    var $form = $( this ),
        url = $form.attr( "action" );
		//ambil value dari form (berdasarkan id)
		inpnip = $("input#txtnip").val();
		inpnama = $("input#txtnama").val();
    
    $.post( url,{    nip:inpnip,nama:inpnama },
        function(result){                 
            $( "#result" ).empty().html(result); //tampilkan hasil pada div "result"
        }       
    );
  });
</script>
</body>
</html>