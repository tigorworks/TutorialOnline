package com.listmenu;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class ActivityListMenu extends ListActivity {
    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        
        String[] DietMeter = new String[] { "Normal Meter", "Ideal Meter"};
        this.setListAdapter(new ArrayAdapter<String>(this,R.layout.baris,R.id.label, DietMeter));
        //setContentView(R.layout.main);
    }
    
    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
    	super.onListItemClick(l, v, position, id);
    	Object o = this.getListAdapter().getItem(position);
    	String keyword = o.toString();
    	Toast.makeText(this, "Menu Diet : " + keyword, Toast.LENGTH_LONG).show();
    	
    }
}