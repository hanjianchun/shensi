package com.thl.flutterwanandroid.application;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.widget.Toast;

import com.huawei.android.hms.agent.HMSAgent;
import com.xuexiang.keeplive.KeepLive;
import com.xuexiang.keeplive.config.ForegroundNotification;
import com.xuexiang.keeplive.config.ForegroundNotificationClickListener;
import com.xuexiang.keeplive.config.KeepLiveService;
import com.xuexiang.xpush.XPush;
import com.xuexiang.xpush.core.IPushInitCallback;
import com.xuexiang.xpush.core.dispatcher.impl.Android26PushDispatcherImpl;
import com.xuexiang.xpush.huawei.HuaweiPushClient;
import com.xuexiang.xpush.logs.PushLog;
import com.xuexiang.xpush.xiaomi.XiaoMiPushClient;
import com.xuexiang.xutil.system.RomUtils;
import com.xuexiang.xutil.tip.ToastUtils;

import com.thl.flutterwanandroid.R;
import com.thl.flutterwanandroid.push.CustomPushReceiver;
import com.thl.flutterwanandroid.utils.RomUtil;
import io.flutter.Log;
import io.flutter.app.FlutterApplication;

import static com.xuexiang.xutil.system.RomUtils.SYS_EMUI;
import static com.xuexiang.xutil.system.RomUtils.SYS_MIUI;

/**
 * 我自己的application
 */
public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        initKeepLive();

        PushLog.setDebug(true);

        initPush();
    }

    /**
     * 初始化保活
     */
    private void initKeepLive() {
        //定义前台服务的默认样式。即标题、描述和图标
//        ForegroundNotification notification = new ForegroundNotification("推送服务", "推送服务正在运行中...", R.mipmap.ic_launcher,
//                //定义前台服务的通知点击事件
//                new ForegroundNotificationClickListener() {
//                    @Override
//                    public void onNotificationClick(Context context, Intent intent) {
//                        ToastUtils.toast("点击了通知");
////                        AppUtils.launchApp(getPackageName());
//                    }
//                })
//                //要想不显示通知，可以设置为false，默认是false
//                .setIsShow(false);
        //启动保活服务
//        KeepLive.startWork(this, KeepLive.RunMode.ENERGY, notification,
//                //你需要保活的服务，如socket连接、定时任务等，建议不用匿名内部类的方式在这里写
//                new KeepLiveService() {
//                    /**
//                     * 运行中
//                     * 由于服务可能会多次自动启动，该方法可能重复调用
//                     */
//                    @Override
//                    public void onWorking() {
//                        Log.e("xuexiang", "onWorking");
//                    }
//                    /**
//                     * 服务终止
//                     * 由于服务可能会被多次终止，该方法可能重复调用，需同onWorking配套使用，如注册和注销broadcast
//                     */
//                    @Override
//                    public void onStop() {
//                        Log.e("xuexiang", "onStop");
//                    }
//                }
//        );
    }

    /**
     * 动态注册初始化推送
     */
    private void initPush() {
        //动态注册，根据平台名或者平台码动态注册推送客户端
        String romName = RomUtils.getRom().getRomName();
        if (!romName.equals(SYS_EMUI) && !romName.equals(SYS_MIUI)) {
            return;
        }
        try {
            XPush.debug(true);
            XPush.init(this, new IPushInitCallback() {
                @Override
                public boolean onInitPush(int platformCode, String platformName) {
                    if (romName.equals(SYS_EMUI)) {
                        return platformCode == HuaweiPushClient.HUAWEI_PUSH_PLATFORM_CODE && platformName.equals(HuaweiPushClient.HUAWEI_PUSH_PLATFORM_NAME);
                    } else if (romName.equals(SYS_MIUI)) {
                        return platformCode == XiaoMiPushClient.MIPUSH_PLATFORM_CODE && platformName.equals(XiaoMiPushClient.MIPUSH_PLATFORM_NAME);
                    } else {
                        return false;//platformCode == JPushClient.JPUSH_PLATFORM_CODE && platformName.equals(JPushClient.JPUSH_PLATFORM_NAME);
                    }
                }
            });

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                XPush.setIPushDispatcher(new Android26PushDispatcherImpl(CustomPushReceiver.class));
            }
            XPush.register();
        }catch (Exception e){

        }
    }

}
