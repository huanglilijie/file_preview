package com.gstory.file_preview

import android.app.Activity
import android.opengl.ETC1.getWidth
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import android.view.MotionEvent
import android.view.View
import com.tencent.smtt.sdk.*


/**
 * @Author: gstory
 * @CreateDate: 2022/10/19 16:13
 * @Description: 描述
 */

class X5WebviewActivity : Activity() {

    lateinit var webX5 : WebView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_x5)
        initX5()
        webX5.loadUrl("http://debugtbs.qq.com")
    }

    private fun initX5(){
        webX5 = findViewById(R.id.web_x5)
        //开启js脚本支持
        val settings = webX5.settings
        settings.javaScriptEnabled = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.mixedContentMode = android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW;
        }
        //适配手机大小
        settings.useWideViewPort = true
        settings.layoutAlgorithm = WebSettings.LayoutAlgorithm.NARROW_COLUMNS
        settings.loadWithOverviewMode = true
        settings.setSupportZoom(true)
        settings.builtInZoomControls = true
        settings.displayZoomControls = false
        settings.setGeolocationEnabled(true)
        settings.domStorageEnabled = true
        // 触摸焦点起作用
        webX5.requestFocus()
        webX5.webChromeClient = MyChromeClient()
        webX5.webViewClient = MyClient()
    }

    //进度显示
    private inner class MyChromeClient : WebChromeClient() {
        override fun onProgressChanged(p0: WebView?, p1: Int) {
            Log.d("安卓进度",p1.toString());
            super.onProgressChanged(p0, p1)
            if(p1>=100){
                val x = webX5.width * 2.5f / 3
                val y = 100f
//                simulateTouchEvent(webX5, x, y)
            }
        }
    }

    private class MyClient : WebViewClient() {

    }

    private fun simulateTouchEvent(view: View, x: Float, y: Float) {
        val downTime = SystemClock.currentThreadTimeMillis()
        val eventTime = downTime + 50
        val metaState = 0
        val motionEvent = MotionEvent.obtain(
            downTime, eventTime,
            MotionEvent.ACTION_DOWN, x, y, metaState
        )
        view.dispatchTouchEvent(motionEvent)
        val upEvent = MotionEvent.obtain(
            downTime + 100, eventTime + 100,
            MotionEvent.ACTION_UP, x, y, metaState
        )
        view.dispatchTouchEvent(upEvent)
    }
    override fun onDestroy() {
        super.onDestroy()
        //清除cookie
        CookieManager.getInstance().removeAllCookies(null)
        //清除storage相关缓存
        WebStorage.getInstance().deleteAllData()
        //清除httpauth信息
        WebViewDatabase.getInstance(this).clearHttpAuthUsernamePassword()
        //清除表单数据
        WebViewDatabase.getInstance(this).clearFormData()
        //删除地理位置授权，也可以删除某个域名的授权（参考接口类）
        GeolocationPermissions.getInstance().clearAll()
    }
}