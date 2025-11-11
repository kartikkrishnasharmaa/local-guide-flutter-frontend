package com.localguider.localguider

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.Random

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val importance = NotificationManager.IMPORTANCE_HIGH
    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.e("TAG_TOKEN_FCM", "Refreshed token: $token")
//        User.setFcmToken(token)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        if (remoteMessage.data.isNotEmpty()) {

            val model = NotificationModel()
            model.title = remoteMessage.data["title"].toString()
            model.body = remoteMessage.data["body"].toString()
            model.type = remoteMessage.data["type"].toString()
            showSmallNotification(model)

        } else if (remoteMessage.notification != null) {
            val model = NotificationModel()
            model.title = getString(R.string.app_name)
            model.body = remoteMessage.notification?.body.toString()
            showSmallNotification(model)
        }
    }

    private fun showSmallNotification(model: NotificationModel) {
        val mNotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "channel-01"
        val channelName = "General Notifications"
        createGeneralNotificationChannel(channelId, channelName, mNotificationManager)
        val mBuilder = NotificationCompat.Builder(applicationContext, channelId)
            .setSmallIcon(R.mipmap.logo)
            .setColor(ContextCompat.getColor(this, R.color.blue))
            .setContentTitle(model.title)
            .setContentText(model.body)
            .setAutoCancel(true)
            .setChannelId(channelId)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setDefaults(Notification.DEFAULT_ALL)

        val intent = Intent(applicationContext, MainActivity::class.java)
//        intent.putExtra(Const.Args.NOTIFICATION_TYPE, model.type)
//        intent.putExtra(Const.Args.NOTIFICATION_ID, model.id)
        val pi = PendingIntent.getActivity(
            this,
            getRequestCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        mBuilder.setContentIntent(pi)
        mNotificationManager.notify(getRequestCode(), mBuilder.build())
    }

    private fun createGeneralNotificationChannel(
        channelId: String,
        channelName: String,
        mNotificationManager: NotificationManager
    ) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val mChannel = NotificationChannel(channelId, channelName, importance)
            mNotificationManager.createNotificationChannel(mChannel)
        }
    }

    private fun getRequestCode(): Int {
        val rnd = Random()
        return 100 + rnd.nextInt(900000)
    }

}