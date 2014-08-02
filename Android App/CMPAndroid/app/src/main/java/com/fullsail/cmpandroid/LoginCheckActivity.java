package com.fullsail.cmpandroid;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.parse.Parse;
import com.parse.ParseUser;

public class LoginCheckActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_check);

        Parse.enableLocalDatastore(this);
        Parse.initialize(this, "g8RjRSmxpeLg7W00hFFB1BfrlQNdwEJHiVzrN8s3", "xnRpFrD4ik083GScDy9FHRMQpaRgIdKLdBuReK1Z");
        //ParseUser.logOut();
        //ParseUser currentUser = ParseUser.getCurrentUser();

        if (ParseUser.getCurrentUser() != null) {

            startActivity(new Intent(this, MainActivity.class));

        } else {

            startActivity(new Intent(this, LoginActivity.class));

        }

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.login_check, menu);
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
