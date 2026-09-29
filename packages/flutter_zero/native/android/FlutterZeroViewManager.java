package com.flutterzero;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import java.util.HashMap;
import java.util.Map;

public class FlutterZeroViewManager {
    private final Context context;
    private final Map<Long, View> views = new HashMap<>();
    private long handleCounter = 30000;

    public FlutterZeroViewManager(Context context) {
        this.context = context;
    }

    public long createView(String widgetType, String propsJson) {
        long handle = ++handleCounter;
        View view;

        if ("Button".equalsIgnoreCase(widgetType)) {
            Button btn = new Button(context);
            btn.setText("Native Button");
            view = btn;
        } else if ("Text".equalsIgnoreCase(widgetType)) {
            TextView tv = new TextView(context);
            tv.setText("Native Text");
            view = tv;
        } else if ("TextField".equalsIgnoreCase(widgetType)) {
            EditText et = new EditText(context);
            view = et;
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

    public void updateLayout(long handle, float x, float y, float width, float height) {
        View view = views.get(handle);
        if (view != null) {
            view.setX(x);
            view.setY(y);
            ViewGroup.LayoutParams lp = view.getLayoutParams();
            if (lp == null) {
                lp = new ViewGroup.LayoutParams((int) width, (int) height);
            } else {
                lp.width = (int) width;
                lp.height = (int) height;
            }
            view.setLayoutParams(lp);
        }
    }

    public void removeView(long handle) {
        View view = views.remove(handle);
        if (view != null && view.getParent() instanceof ViewGroup) {
            ((ViewGroup) view.getParent()).removeView(view);
        }
    }
}
