package com.helloworld;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Button;

public class TampilkanHelloWorld extends Activity {
    /** Called when the activity is first created. */
	private EditText edHello;
	private Button btnTampil;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        edHello = (EditText) findViewById(R.id.edHello);
        btnTampil = (Button) findViewById(R.id.btnTampil);
    }
    
    public void TampilTulisan(View view){
    	edHello.setText("Hello World, This is my first application using Android");
    }
}