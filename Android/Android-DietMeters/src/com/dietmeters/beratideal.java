package com.dietmeters;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class beratideal extends Activity{
	private EditText edBerat;
	private EditText edTinggi;
	private Button btnKalkulasi;
	private Button btnKembali;
	
	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.beratideal);
		
		edBerat = (EditText) findViewById(R.id.edBerat);
		edTinggi = (EditText) findViewById(R.id.edTinggi);
		btnKalkulasi = (Button) findViewById(R.id.btnKalkulasi);
		btnKembali = (Button) findViewById(R.id.btnKembali);
	}
	
	public void doKalkulasi(View view){
		float Berat = Float.parseFloat(edBerat.getText().toString());
		float Tinggi = Float.parseFloat(edTinggi.getText().toString());
		
		String rt = "Ideal";
		
		float ideal = (float)(Tinggi - 100) - ((float)0.1 * (Tinggi - 100)); 
		
		if (Berat > ideal)
		{			
			float Persen = ((float)Berat / ideal * 100)-100;
		
			if (Persen>9 && Persen<21)
			{
				rt = "Kelebihan Berat Badan / Overweight";
			}
			else if (Persen > 20)
			{
				rt = "Kegemukan / Obesitas / Obesity";
			}
		}
		else if (Berat < ideal)
		{
			float Persen = ((float)ideal/Berat*100) - 100;
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
