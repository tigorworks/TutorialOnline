package com.dietmeters;

import org.xml.sax.Parser;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class beratnormal extends Activity{
	private EditText edBerat;
	private EditText edTinggi;
	private Button btnKalkulasi;
	private Button btnKembali;
	
	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.beratnormal);
		
		edBerat = (EditText) findViewById(R.id.edBerat);
		edTinggi = (EditText) findViewById(R.id.edTinggi);
		btnKalkulasi = (Button) findViewById(R.id.btnKalkulasi);
		btnKembali = (Button) findViewById(R.id.btnKembali);
	}
	
	public void doKalkulasi(View view){
		
		float Berat = Float.parseFloat(edBerat.getText().toString());
		float Tinggi = Float.parseFloat(edTinggi.getText().toString());
		
		float Hasil = (float) Tinggi - 100;
		
		String rt = "Normal";
		
		//kelebihan berat badan		
		if (Berat > Hasil)
		{			
			float Persen = ((float)Berat / Hasil * 100)-100;
		
			if (Persen>9 && Persen<21)
			{
				rt = "Kelebihan Berat Badan / Overweight";
			}
			else if (Persen > 20)
			{
				rt = "Kegemukan / Obesitas / Obesity";
			}
		}
		else if (Berat < Hasil)
		{
			float Persen = ((float)Hasil/Berat*100) - 100;
			if (Persen>9)
			{
				rt = "Kurus";
			}
		}
		Toast.makeText(this, "Anda : " + rt, Toast.LENGTH_LONG).show();
	}
	
	public void BackMainMenu(View view){
		finish();
	}
}
