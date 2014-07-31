package com.fullsail.cmpandroid;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by brandonshega on 7/31/14.
 */
public class CustomAdapter extends BaseAdapter {

    Activity mActivity;
    ArrayList<HashMap<String,String>> contactList;
    LayoutInflater inflater;

    public CustomAdapter(Activity activity, ArrayList<HashMap<String,String>> list) {

        mActivity = activity;
        contactList = list;
        inflater = activity.getLayoutInflater();

    }

    @Override
    public int getCount() {
        return contactList.size();
    }

    @Override
    public Object getItem(int position) {

        return contactList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View v = convertView;

        if (v == null) {

            v = inflater.inflate(R.layout.list_row, null);

            TextView name = (TextView) v.findViewById(R.id.contactText);
            TextView phone = (TextView) v.findViewById(R.id.phoneText);

            HashMap<String, String> contact;
            contact = contactList.get(position);

            name.setText(contact.get("name"));
            phone.setText(contact.get("phone"));

        }

        return v;

    }

}
