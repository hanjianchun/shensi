package com.thl.flutterwanandroid.plugin;

import android.app.Activity;
import android.content.Context;

import com.xuexiang.xpush.XPush;
import com.xuexiang.xpush._XPush;
import com.xuexiang.xpush.huawei.HuaweiPushClient;
import com.xuexiang.xpush.xiaomi.XiaoMiPushClient;
import com.xuexiang.xutil.system.RomUtils;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.xuexiang.xutil.system.RomUtils.SYS_EMUI;
import static com.xuexiang.xutil.system.RomUtils.SYS_MIUI;

/**
 * FluttertoastPlugin
 */
public class XPushPlugin implements MethodCallHandler {

    public static final String CHANNEL = "xpush_plugin";

    private Context mContext;

    private Activity mActivity;

    private XPushPlugin(Context context, Activity activity) {
        mContext = context;
        mActivity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new XPushPlugin(registrar.context(),registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        String romName = RomUtils.getRom().getRomName();
        switch (call.method) {
            case "getInfo":
                String pushToken = "";
                String platformName = "";
                if (romName.equals(SYS_EMUI) || romName.equals(SYS_MIUI)) {
                    try {
                        pushToken = XPush.getPushToken();
                        platformName = XPush.getPlatformName();
                    }catch (Exception e){

                    }
                }
                Map<String,String> map = new HashMap<>();
                map.put("token",pushToken);
                map.put("platform",platformName);
                map.put("romName",romName);
                result.success(map);
                break;
            case "unRegister":
                if (romName.equals(SYS_EMUI) || romName.equals(SYS_MIUI)) {
                    XPush.unRegister();
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}