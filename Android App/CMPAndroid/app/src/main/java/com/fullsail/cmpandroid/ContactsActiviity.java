package com.fullsail.cmpandroid;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ListView;

import com.fullsail.cmpandroid.R;
import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ContactsActiviity extends Activity {

    ArrayList<HashMap<String,String>> contactList;
    ListView contacts;

    CustomAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contacts_activiity);

        contactList = new ArrayList<HashMap<String, String>>();
        contacts = (ListView) findViewById(R.id.contactList);

        refreshData();

        adapter = new CustomAdapter(this, contactList);
        contacts.setAdapter(adapter);

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.contacts_activiity, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        switch (id) {
            case R.id.action_add:

                return true;
            case R.id.action_refresh:
                refreshData();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void refreshData() {

        ParseQuery<ParseObject> query = ParseQuery.getQuery("Contact");
        query.whereEqualTo("user", ParseUser.getCurrentUser());

        ParseUser currentUser = ParseUser.getCurrentUser();
        Log.v("Current User", currentUser.getUsername());

        query.findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> parseObjects, ParseException e) {
                if (e == null) {

                    for (ParseObject object : parseObjects) {

                        HashMap<String,String> contact = new HashMap<String, String>();

                        contact.put("name", object.getString("name"));
                        contact.put("phone", object.getString("phone"));
                        contact.put("id", object.getObjectId());

                        contactList.add(contact);

                    }

                } else {

                    Log.e("query", "Error: " + e.getMessage());

                }
            }
        });

    }
}
