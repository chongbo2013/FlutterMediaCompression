package com.mx.compression.MediaCompression

import android.content.Context
import android.media.MediaMetadataRetriever
import com.hw.videoprocessor.VideoProcessor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*
import java.util.concurrent.Executors


class CompressVideoFileHandler(private val call: MethodCall, result: MethodChannel.Result) : ResultHandler(result)  {

    companion object {
        @JvmStatic
        private val executor = Executors.newFixedThreadPool(5)
    }

    val FRAME_RATE = 25
    private val BPP = 0.05
    var isEnableHD = false
    // 高清录制时的帧率倍数
    private val HDValue = 4
    private fun calcBitRate(w: Int, h: Int): Int {
        var bitrate = (BPP * FRAME_RATE * w * h)
//        if (isEnableHD) {
//            bitrate*=HDValue
//        } else {
//            bitrate*= 2;
//        }
        return bitrate.toInt()
    }


    fun handleGetFile(registrar: Context) {

executor.execute {
    @Suppress("UNCHECKED_CAST") val args: List<Any> = call.arguments as List<Any>
    val file = args[0] as String
    val targetDir = args[1]  as String
    val files: MutableList<String> = ArrayList()
    files.add(file)
    val retriever = MediaMetadataRetriever()
    retriever.setDataSource(file)
    val originWidth: Int = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH).toInt()
    val originHeight: Int = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT).toInt()

    val bitrate=this.calcBitRate(originWidth,originHeight)
    VideoProcessor.processor(registrar)
            .input(file)
            .output(targetDir)
            .bitrate(bitrate)
            .process()
    if(targetDir!=null){
        reply(targetDir)
    }else{
        reply(null)
        return@execute
    }
}

    }
}