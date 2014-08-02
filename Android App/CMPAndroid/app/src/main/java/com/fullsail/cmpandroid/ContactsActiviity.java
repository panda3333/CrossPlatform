package com.fullsail.cmpandroid;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

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

    static ArrayList<HashMap<String,String>> contactList;
    static ListView contacts;

    static CustomAdapter adapter;

    static Context mContext;

    static List<ParseObject> objectList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contacts_activiity);

        mContext = this;

        contactList = new ArrayList<HashMap<String, String>>();
        contacts = (ListView) findViewById(R.id.contactList);

        refreshData();

        adapter = new CustomAdapter(this, contactList);

        contacts.setClickable(true);

        contacts.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                HashMap<String,String> contact = (HashMap<String,String>) adapter.getItem(position);

                Intent intent = new Intent(mContext, DetailActivity.class);

                intent.putExtra("name", contact.get("name"));
                intent.putExtra("phone", contact.get("phone"));
                intent.putExtra("id", contact.get("id"));

                startActivity(intent);

            }
        });

        contacts.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {

                deleteItem(position);

                return true;
            }
        });

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
                startActivityForResult(new Intent(mContext, AddContactActivity.class), 1);
                return true;
            case R.id.action_refresh:
                refreshData();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public static void refreshData() {

        ParseQuery<ParseObject> query = ParseQuery.getQuery("Contact");
        query.whereEqualTo("user", ParseUser.getCurrentUser());

        ParseUser currentUser = ParseUser.getCurrentUser();
        Log.v("Current User", currentUser.getUsername());

        final ProgressDialog dlg = new ProgressDialog(mContext);
        dlg.setTitle("Loading.");
        dlg.setMessage("Loading contacts. Please Wait...");
        dlg.show();

        boolean connected = networkConnected();

        if (connected) {

            query.findInBackground(new FindCallback<ParseObject>() {
                @Override
                public void done(List<ParseObject> parseObjects, ParseException e) {
                    if (e == null) {

                        contactList.clear();

                        objectList = parseObjects;

                        ParseObject.pinAllInBackground(parseObjects);

                        for (ParseObject object : parseObjects) {

                            HashMap<String, String> contact = new HashMap<String, String>();

                            contact.put("name", object.getString("name"));
                            contact.put("phone", object.getNumber("phone").toString());
                            contact.put("id", object.getObjectId());

                            contactList.add(contact);

                        }

                        dlg.dismiss();

                        contacts.setAdapter(adapter);
                        contacts.deferNotifyDataSetChanged();

                    } else {

                        Log.e("query", "Error: " + e.getMessage());

                    }
                }
            });

        } else {

            query.fromLocalDatastore();

            query.findInBackground(new FindCallback<ParseObject>() {
                @Override
                public void done(List<ParseObject> parseObjects, ParseException e) {
                    if (e == null) {

                        contactList.clear();

                        for (ParseObject object : parseObjects) {

                            HashMap<String, String> contact = new HashMap<String, String>();

                            contact.put("name", object.getString("name"));
                            contact.put("phone", object.getNumber("phone").toString());
                            contact.put("id", object.getObjectId());

                            contactList.add(contact);

                        }

                        dlg.dismiss();

                        contacts.setAdapter(adapter);
                        contacts.deferNotifyDataSetChanged();

                    } else {

                        Log.e("query", "Error: " + e.getMessage());

                    }
                }
            });



        }



    }


    public void deleteItem(final int position) {

        AlertDialog.Builder alert = new AlertDialog.Builder(mContext);

        alert.setTitle("Delete Contact");
        alert.setMessage("Do you want to delete this contact?");
        alert.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                ParseObject object = objectList.get(position);

                if (ContactsActiviity.networkConnected()) {

                    object.deleteInBackground();

                } else {

                    object.deleteEventually();

                }

                Toast.makeText(mContext, "Contact deleted successfully.", Toast.LENGTH_SHORT).show();
                refreshData();

                dialog.dismiss();

            }
        }).setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                dialog.dismiss();

            }
        });

        alert.show();


    }

    public static boolean networkConnected() {

        ConnectivityManager manager = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = manager.getActiveNetworkInfo();

        if (info == null) {

            return false;

        } else {

            return true;

        }

    }
}
