package com.fullsail.cmpandroid;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.fullsail.cmpandroid.R;
import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;

public class EditContactActivity extends Activity {

    Context mContext;

    EditText editName;
    EditText editPhone;

    Button saveButton;

    String name;
    String phone;
    String id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_contact);

        Bundle extras = getIntent().getExtras();

        if (extras != null) {

            name = extras.getString("name");
            phone = extras.getString("phone");
            id = extras.getString("id");

        }

        mContext = this;

        editName = (EditText) findViewById(R.id.editContactName);
        editPhone = (EditText) findViewById(R.id.editContactPhone);

        saveButton = (Button) findViewById(R.id.saveEditButton);

        saveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ParseQuery<ParseObject> query = ParseQuery.getQuery("Contact");

                if (ContactsActiviity.networkConnected()) {

                    query.getInBackground(id, new GetCallback<ParseObject>() {
                        @Override
                        public void done(ParseObject parseObject, ParseException e) {
                            if (e == null) {

                                Number phoneNumber = Integer.valueOf(editPhone.getText().toString());

                                parseObject.put("name", editName.getText().toString());
                                parseObject.put("phone", phoneNumber);

                                parseObject.saveInBackground();

                                Toast.makeText(mContext, "Contact updated successfully.", Toast.LENGTH_SHORT).show();
                                ContactsActiviity.refreshData();

                                Intent returnIntent = new Intent();

                                returnIntent.putExtra("name", editName.getText().toString());
                                returnIntent.putExtra("phone", editPhone.getText().toString());
                                setResult(RESULT_OK, returnIntent);

                                finish();

                            }
                        }
                    });

                } else {

                    query.fromLocalDatastore();

                    query.getInBackground(id, new GetCallback<ParseObject>() {
                        @Override
                        public void done(ParseObject parseObject, ParseException e) {
                            if (e == null) {

                                Number phoneNumber = Integer.valueOf(editPhone.getText().toString());

                                parseObject.put("name", editName.getText().toString());
                                parseObject.put("phone", phoneNumber);

                                parseObject.saveEventually();

                                Toast.makeText(mContext, "Contact updated successfully.", Toast.LENGTH_SHORT).show();
                                ContactsActiviity.refreshData();

                                Intent returnIntent = new Intent();

                                returnIntent.putExtra("name", editName.getText().toString());
                                returnIntent.putExtra("phone", editPhone.getText().toString());
                                setResult(RESULT_OK, returnIntent);

                                finish();

                            }
                        }
                    });

                }



            }
        });

        editName.setText(name);
        editPhone.setText(phone);

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.edit_contact, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
