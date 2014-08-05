package com.dietmeters;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;
import android.content.Intent;

public class ActivityDietMeters extends ListActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        String[] DietMeter = new String[] { "Normal Meter", "Ideal Meter"};
        this.setListAdapter(new ArrayAdapter<String>(this,android.R.layout.simple_list_item_1, DietMeter));
    }
    
    @Override
    protected void onListItemClick(ListView l,View v,int Position,long id){
    	super.onListItemClick(l, v, Position, id);
    	
    	Object o = this.getListAdapter().getItem(Position);
    	String Teks = o.toString();
    	ShowThis(Teks);
    }
    
    public void ShowThis(String Teks)
    {
    	Intent i = null;
    	if (Teks.equals("Normal Meter")){
    		i = new Intent(this,beratnormal.class);
    	}
    	else if (Teks.equals("Ideal Meter")){
    		i = new Intent(this,beratideal.class);
    	}
    	
    	if (i != null)
    	{
    		startActivity(i);
    	}
    	
    }
}