package com.fullsail.cmpandroid;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.TextView;

import com.fullsail.cmpandroid.R;

public class DetailActivity extends Activity {

    Context mContext;

    TextView nameText;
    TextView phoneText;

    String name;
    String phone;
    String objectid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        mContext = this;

        nameText = (TextView) findViewById(R.id.detailName);
        phoneText = (TextView) findViewById(R.id.detailPhone);

        Bundle extras = getIntent().getExtras();

        if (extras != null) {

            name = extras.getString("name");
            phone = extras.getString("phone");
            objectid = extras.getString("id");

        }

        nameText.setText(name);
        phoneText.setText(phone);

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.detail, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        switch (id) {
            case R.id.action_edit:
                Intent intent = new Intent(mContext, EditContactActivity.class);
                intent.putExtra("name", name);
                intent.putExtra("phone", phone);
                intent.putExtra("id", objectid);
                startActivityForResult(intent, 1);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1) {

            if (resultCode == RESULT_OK) {

                String name = data.getStringExtra("name");
                String phone = data.getStringExtra("phone");

                nameText.setText(name);
                phoneText.setText(phone);

            }

        }
    }
}
