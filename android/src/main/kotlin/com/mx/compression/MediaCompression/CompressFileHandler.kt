package com.mx.compression.MediaCompression

import android.content.Context
import com.mx.compression.MediaCompression.luban.Luban
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors



class CompressFileHandler(private val call: MethodCall, result: MethodChannel.Result) : ResultHandler(result)  {

    companion object {
        @JvmStatic
        private val executor = Executors.newFixedThreadPool(5)
    }


    fun handleGetFile(registrar: Context) {

executor.execute {
    @Suppress("UNCHECKED_CAST") val args: List<Any> = call.arguments as List<Any>
    val file = args[0] as String
    val targetDir = args[1]  as String

    val files: MutableList<String> = ArrayList()
    files.add(file)
    val results= Luban.with(registrar).setTargetDir(targetDir).load(files).get()
    if(results!=null){
        reply(results[0].absolutePath);
    }else{
        reply(null)
        return@execute
    }
}

    }
}