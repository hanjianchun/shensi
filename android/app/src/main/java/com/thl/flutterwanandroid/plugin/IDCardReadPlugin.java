package com.thl.flutterwanandroid.plugin;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.util.Base64;
import android.view.Gravity;
import android.widget.Toast;
import android.os.Message;
import com.identity.Shell;
import com.identity.globalEnum;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * 身份证读取设备
 */
public class IDCardReadPlugin implements MethodChannel.MethodCallHandler {

    public static final String CHANNEL = "idcard_plugin";
    private Context mContext;
    private Activity mActivity;

    Thread thread;

    private MethodChannel.Result result;

    private IDCardReadPlugin(Context context, Activity activity) {
        mContext = context;
        mActivity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new IDCardReadPlugin(registrar.context(),registrar.activity()));
    }

    private BluetoothAdapter mAdapter;
    private BluetoothDevice mDevice=null;
    private Shell shell=null;
    private boolean bInitial = false;
    private boolean bStop = false;
    private boolean bConnected = false;
    private String packageName;

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        this.result = result;
        switch (call.method) {
            case "init":
                if(bInitial) {
                    result.success(true);
                    return;
                }
                packageName = mActivity.getPackageName();
                mAdapter = BluetoothAdapter.getDefaultAdapter();
                Set<BluetoothDevice> pairedDevices = mAdapter.getBondedDevices();
                if (pairedDevices.size() > 0) {
                    for (BluetoothDevice device : pairedDevices) {
                        String str;
                        str = device.getName().substring(0, 3);
                        Log.i("pairedDevices", "device.getName().substring(0, 1) is:" + str);
                        if ((str.equalsIgnoreCase("SYN")) || (str.equalsIgnoreCase("SS-")) || (str.equalsIgnoreCase("PSB"))) {
                            Log.i("onCreate", "device.getName() is SYNTHESIS");
                            mDevice = device;
                        } else   //是否能进入Else
                        {
                            Log.i("onCreate", "device.getName() is not SYNTHESIS");
                            boolean bAllNum = false;
                            if (device.getName().length() > 9) {
                                str = device.getName().substring(0, 10);
                                bAllNum = str.matches("[0-9]+");
                                if (bAllNum == true) {
                                    mDevice = device;
                                }
                            }
                        }
                    }
                    try {
                        mAdapter.cancelDiscovery();
                        if (mDevice != null) {
                            shell = new Shell(mContext, mDevice);
                            bInitial = true;
                            result.success(true);
                        }
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                        Log.i("test", "Socket connect error！");
                    }
                }else{
                    result.success(false);
                }
                break;
            case "connect":
                if(bConnected) {
                    result.success(true);
                    return;
                }
                //链接
                globalEnum ge = globalEnum.NONE;
                if(shell == null){
                    Log.i("TestJarActivity","In ButtonInitOnClick shell is null");
                    try {
                        if(mDevice == null){
                            Log.i("TestJarActivity","In ButtonInitOnClick shell 212");
                            return ;
                        }
                        shell = new Shell(mContext, mDevice);
                        Log.i("TestJarActivity","In ButtonInitOnClick shell 11");
                    } catch (Exception e) {
                        Log.i("TestJarActivity","In ButtonInitOnClick shell 22");
                        e.printStackTrace();
                    }
                }

                try {
                    if (shell.Register())
                    {
                        //0316 btnRegist.setEnabled(false);
                        ge = shell.Init();
                        if (ge == globalEnum.INITIAL_SUCCESS) {
                            bConnected = true;
//                            new Thread(new GetDataThread(result)).start();

                            Toast toast= Toast.makeText(mContext,"链接成功",Toast.LENGTH_SHORT    );
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();
                        } else {
                            shell.EndCommunication();//0316
                            Toast toast= Toast.makeText(mContext,"0316 与机具建立连接失败，请检查蓝牙配置",Toast.LENGTH_SHORT    );
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();
                        }
                    }else
                    {
                        bInitial = false;
                        Toast toast= Toast.makeText(mContext,"与机具建立连接失败，请检查蓝牙配置",Toast.LENGTH_SHORT    );
                        toast.setGravity(Gravity.CENTER, 0, 0);
                        toast.show();

                    }
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                break;
            case "read":
                //读卡
                if(thread != null && thread.isAlive()){
                    try {
                        thread.stop();
                    }catch (Exception e){}
                }
                thread = new Thread(new GetDataThread());
                thread.start();
                break;
            case "unRegister":
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    //0316
    private class GetDataThread implements Runnable{
        private String data ;
        private byte[] cardInfo = new byte[256];
        private int count = 0 ;
        private Message msg;//主要改了这个地方，好像启作用了
        private String wltPath="";
        private String termBPath="";
        private boolean bRet = false;

        public GetDataThread(){
        }

        public void run() {
            globalEnum ge = globalEnum.GetIndentiyCardData_GetData_Failed;
            try {
                Thread.sleep(2000);

                globalEnum gFindCard = globalEnum.NONE;
                while (!bStop) {
                    data = null;//
                    msg = handler.obtainMessage(71, data);//发送消息
                    handler.sendMessage(msg);
                    bRet = shell.SearchCard();
                    if (bRet) {
                        data = null;//
                        msg = handler.obtainMessage(1, data);//发送消息
                        handler.sendMessage(msg);
                        bRet = shell.SelectCard();
                        if(bRet){
                            data = null;//
                            msg = handler.obtainMessage(2, data);//发送消息
                            handler.sendMessage(msg);
                            //Thread.sleep(100);

                            int nRet = shell.ReadCardWithFinger();//nRet 1:二代证无指纹 2：二代证包含指纹
                            if (nRet>0) {
                                data = null;//
                                byte[] fingerBuff = new byte[1024];
                                byte[] wltBuff = new byte[1024];
                                if(nRet == 2){
                                    bRet = shell.GetFingerData(fingerBuff);
                                    //	Log.i("ComShell","fingerData is:"+Util.toHexStringNoSpace(fingerBuff, 1024));
                                }

                                msg = handler.obtainMessage(3, data);//发送消息
                                handler.sendMessage(msg);

                                cardInfo = shell.GetCardInfoBytes();

                                JSONObject resultData = new JSONObject();
                                JSONObject idcardData = new JSONObject();
                                if(shell.GetCardTypeFlag(cardInfo)==0){//0时为二代证信息
                                    resultData.put("code","0");
                                    resultData.put("message","读取成功");

                                    idcardData.put("name",shell.GetName(cardInfo));
                                    idcardData.put("sex",shell.GetGender(cardInfo));
                                    idcardData.put("birthday",shell.GetBirthday(cardInfo));
                                    idcardData.put("national",shell.GetNational(cardInfo));
                                    idcardData.put("address",shell.GetAddress(cardInfo));
                                    idcardData.put("idcard",shell.GetIndentityCard(cardInfo));
                                    idcardData.put("issued",shell.GetIssued(cardInfo));
                                    idcardData.put("startDate",shell.GetStartDate(cardInfo));
                                    idcardData.put("endDate",shell.GetEndDate(cardInfo));
                                }else if(shell.GetCardTypeFlag(cardInfo)==1){//1时为外国人居住证信息
                                    data = String.format(
                                            "英文名字：%s 中文名字：%s 性别：%s 国籍代码：%s 国籍名称：%s 出生日期：%s 身份证号：%s 签发机关：%s 有效期：%s-%s",
                                            shell.GetFEName(cardInfo),shell.GetFCName(cardInfo), shell.GetFGender(cardInfo),  shell.GetFCountryCode(cardInfo),shell.GetFCountryName(cardInfo),
                                            shell.GetFBirthday(cardInfo),
                                            shell.GetFIndentityCard(cardInfo), shell.GetFIssued(cardInfo),
                                            shell.GetFStartDate(cardInfo), shell.GetFEndDate(cardInfo));
                                }else{
                                    resultData.put("code","6");
                                    resultData.put("message","读取失败");
                                    data = resultData.toString();
                                    msg = handler.obtainMessage(6, data);//读卡失败
                                    handler.sendMessage(msg);	//readC
                                    break;
                                }

                                byte[] bmpBuff = new byte[38862];
                                boolean bRet = shell.GetWltData(wltBuff);
                                if(bRet){
                                    Log.i("ComShell","packageName is :"+packageName);
                                    nRet = shell.GetPicByBuff(packageName,wltBuff,bmpBuff);
                                    Log.i("ComShell","GetPicByBuff nRet is:"+nRet);
                                    if(nRet == 1) {
                                        Bitmap bm = BitmapFactory.decodeByteArray(
                                                bmpBuff, 0, 38862);
                                        if (bm != null) {
                                            String base64 = bitmapToBase64(bm);
                                            idcardData.put("image",base64);
                                        }
                                    }
                                }

                                resultData.put("data",idcardData);
                                data = resultData.toString();

                                msg = handler.obtainMessage(0, data);//发送消息
                                handler.sendMessage(msg);	//readCard error
                                break;
                            }else{
                                msg = handler.obtainMessage(6, data);//发送消息
                                handler.sendMessage(msg);	//readCard error
                            }
                        }else{
                            msg = handler.obtainMessage(5, data);//发送消息
                            handler.sendMessage(msg);	//selectCard error
                        }
                    }else{
                        msg = handler.obtainMessage(4, data);//发送消息
                        handler.sendMessage(msg);	//searchCard error
                    }
                    Thread.sleep(100);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public Handler handler = new Handler(){//处理UI绘制
        private String data;
        private Bitmap bm;
        private int t_sec1,t_sec2;
        private int t_msec1,t_msec2;

        private Calendar t;
        @SuppressWarnings("unchecked")
        @Override
        public void handleMessage(Message msg) {//M_ERROR  M_VALIDATE_ERROR I_ERROR I_VALIDATE_ERROR
            switch (msg.what) {                    //C_ERROR  C_VALIDATE_ERROR D_ERROR D_VALIDATE_ERROR
                case 0:
                    result.success(msg.obj);
                    break;
                case 6:
                    result.error("读卡失败","","");
                    break;
            }
        }
    };

    /**
     * bitmap转base64
     * @param bitmap
     * @return
     */
    private static String bitmapToBase64(Bitmap bitmap) {
        String result = null;
        ByteArrayOutputStream baos = null;
        try {
            if (bitmap != null) {
                baos = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);

                baos.flush();
                baos.close();

                byte[] bitmapBytes = baos.toByteArray();
                result = Base64.encodeToString(bitmapBytes, Base64.DEFAULT);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (baos != null) {
                    baos.flush();
                    baos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

}
