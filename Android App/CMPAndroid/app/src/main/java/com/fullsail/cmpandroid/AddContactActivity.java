package com.fullsail.cmpandroid;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.fullsail.cmpandroid.R;
import com.parse.ParseObject;
import com.parse.ParseUser;

public class AddContactActivity extends Activity {

    Context mContext;

    EditText editName;
    EditText editPhone;

    Button addButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_contact);

        mContext = this;

        editName = (EditText) findViewById(R.id.editName);
        editPhone = (EditText) findViewById(R.id.editPhone);

        addButton = (Button) findViewById(R.id.addButton);

        addButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String name = editName.getText().toString();
                String phone = editPhone.getText().toString();
                Number phoneNumber = Integer.valueOf(phone);

                ParseObject contact = new ParseObject("Contact");

                contact.put("name", name);
                contact.put("phone", phoneNumber);
                contact.put("user", ParseUser.getCurrentUser());

                contact.saveInBackground();

                ContactsActiviity.refreshData();

                Toast.makeText(mContext, "Contact saved successfully!", Toast.LENGTH_SHORT).show();

                finish();

            }
        });

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.add_contact, menu);
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
