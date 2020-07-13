package com.thl.flutterwanandroid.push;

import android.content.Context;

import com.xuexiang.xpush.core.receiver.impl.XPushReceiver;
import com.xuexiang.xpush.entity.XPushCommand;
import com.xuexiang.xpush.entity.XPushMsg;


public class CustomPushReceiver extends XPushReceiver {

    @Override
    public void onNotificationClick(Context context, XPushMsg msg) {
        super.onNotificationClick(context, msg);
        //打开自定义的Activity
//        Intent intent = IntentUtils.getIntent(context, TestActivity.class, null, true);
//        intent.putExtra(KEY_PARAM_STRING, msg.getContent());
//        intent.putExtra(KEY_PARAM_INT, msg.getId());
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
//        ActivityUtils.startActivity(intent);
    }

    @Override
    public void onCommandResult(Context context, XPushCommand command) {
        super.onCommandResult(context, command);
//        Log.d("result2",command.getDescription());
//        Log.i("result2",command.getDescription());

//        ToastUtils.toast(command.getDescription());
    }

    @Override
    public void onMessageReceived(Context context, XPushMsg msg) {
        super.onMessageReceived(context, msg);

//        NotificationUtils.buildSimple(1000, R.mipmap.ic_launcher, msg.getTitle(), msg.getContent(), null)
//                .setHeadUp(true)
//                .addAction(R.mipmap.ic_launcher, "确定", PendingIntentUtils.buildBroadcastIntent(NotifyBroadCastReceiver.class, NotifyBroadCastReceiver.ACTION_SUBMIT, 0))
//                .addAction(R.mipmap.ic_launcher, "取消", PendingIntentUtils.buildBroadcastIntent(NotifyBroadCastReceiver.class, NotifyBroadCastReceiver.ACTION_CANCEL, 0))
//                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
//                .setIsPolling(true)
//                .show();

    }

    @Override
    public void onNotification(Context context, XPushMsg msg) {
        super.onNotification(context, msg);
//        Log.i("result3",msg.toString());
//        NotificationUtils.buildSimple(1000, R.mipmap.ic_launcher, msg.getTitle(), msg.getContent(), null)
//                .setHeadUp(true)
//                .addAction(R.mipmap.ic_launcher, "确定", PendingIntentUtils.buildBroadcastIntent(NotifyBroadCastReceiver.class, NotifyBroadCastReceiver.ACTION_SUBMIT, 0))
//                .addAction(R.mipmap.ic_launcher, "取消", PendingIntentUtils.buildBroadcastIntent(NotifyBroadCastReceiver.class, NotifyBroadCastReceiver.ACTION_CANCEL, 0))
//                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
//                .setIsPolling(true)
//                .show();

    }
}
