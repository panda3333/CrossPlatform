package com.fullsail.cmpandroid;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

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

                query.getInBackground(id, new GetCallback<ParseObject>() {
                    @Override
                    public void done(ParseObject parseObject, ParseException e) {
                        if (e == null) {

                            parseObject.put("name", editName.getText().toString());
                            parseObject.put("phone", editPhone.getText().toString());

                            parseObject.saveInBackground();

                        }
                    }
                });

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
