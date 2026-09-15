package com.flutterzero;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.util.HashMap;
import java.util.Map;

public class FlutterZeroNative {
    private final Context context;
    private final Map<Long, View> views = new HashMap<>();
    private long handleCounter = 20000;

    public FlutterZeroNative(Context context) {
        this.context = context;
    }

    public long createView(String type, String propsJson) {
        long handle = ++handleCounter;
        View view;
        if ("Button".equalsIgnoreCase(type)) {
            Button btn = new Button(context);
            btn.setText("Native Button");
            view = btn;
        } else if ("Text".equalsIgnoreCase(type)) {
            TextView tv = new TextView(context);
            tv.setText("Native Text");
            view = tv;
        } else {
            view = new FrameLayout(context);
        }
        views.put(handle, view);
        return handle;
    }

    public void appendChild(long parentHandle, long childHandle) {
        View parent = views.get(parentHandle);
        View child = views.get(childHandle);
        if (parent instanceof ViewGroup && child != null) {
            ((ViewGroup) parent).addView(child);
        }
    }

    public void updateLayout(long handle, double x, double y, double width, double height) {
        View view = views.get(handle);
        if (view != null) {
            view.setX((float) x);
            view.setY((float) y);
            ViewGroup.LayoutParams lp = view.getLayoutParams();
            if (lp != null) {
                lp.width = (int) width;
                lp.height = (int) height;
                view.setLayoutParams(lp);
            }
        }
    }

    public View getView(long handle) {
        return views.get(handle);
    }
}
