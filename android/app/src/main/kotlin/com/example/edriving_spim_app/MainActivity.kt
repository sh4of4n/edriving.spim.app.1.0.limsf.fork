package com.example.edriving_spim_app

import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import com.intellego.morphosmart.driver.CTException
import com.intellego.morphosmart.driver.DeviceException
import com.intellego.morphosmart.driver.DeviceProbe
import com.intellego.morphosmart.driver.MorphoSmart
import com.intellego.morphosmart.ilv.ILVErrorCode
import com.intellego.morphosmart.ilv.ILVResultCode
import com.intellego.mykad.CardHolderInfo
import com.intellego.mykad.MyKad
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private var morphoSmart: MorphoSmart? = null
    private var deviceProbe: DeviceProbe? = null
    private var mykad: MyKad? = null
    private lateinit var fp: ByteArray
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "onCreate") {
                    try {
                        deviceProbe = DeviceProbe(this.baseContext)
                        result.success("Connect success")
                    } catch (e: DeviceException) {
                        result.error("UNAVAILABLE", e.message, null)
                    }
                } else if (call.method == "onReadMyKad") {
                    if (morphoSmart == null) {
                        val usbManager = this.baseContext
                            .getSystemService(USB_SERVICE) as UsbManager
                        if (deviceProbe == null) {
                            result.error(
                                "UNAVAILABLE",
                                "No smart card reader attached to the system",
                                null
                            )
                        }
                        if (deviceProbe!!.usbDevice == null) {
                            result.error(
                                "UNAVAILABLE",
                                "No smart card reader attached to the system",
                                null
                            )
                        }
                        morphoSmart = MorphoSmart(
                            usbManager,
                            deviceProbe!!.usbDevice, this
                        )
                    }
                    try {
                        morphoSmart!!.open()
                        mykad = MyKad(morphoSmart)
                        val lStartTime = Date().time
                        var cardHolderInfo = CardHolderInfo()
                        var showInfo = cardHolderInfo.name + cardHolderInfo.nric + cardHolderInfo.dateOfBirth + cardHolderInfo.placeOfBirth
                        try {
                            mykad!!.powerUp()
                            cardHolderInfo = mykad!!.getCardHolderInfo(false, false)
                            mykad!!.powerDown()
                            result.success(cardHolderInfo.name)
                        } catch (e: Exception) {
                            // TODO Auto-generated catch block
                            throw RuntimeException(e.message)
                        }
                    } catch (e: DeviceException) {
                        throw RuntimeException("Error opening smartcard reader:" + e.message)
                    }
                } else if (call.method == "onFingerprintVerify") {
                    if (morphoSmart == null) {
                        val usbManager = this.baseContext
                            .getSystemService(USB_SERVICE) as UsbManager
                        if (deviceProbe == null) {
                            result.error(
                                "UNAVAILABLE",
                                "No fingerprint reader attached to the system",
                                null
                            )
                        }
                        if (deviceProbe!!.usbDevice == null) {
                            result.error(
                                "UNAVAILABLE",
                                "No fingerprint reader attached to the system",
                                null
                            )
                        }
                        morphoSmart = MorphoSmart(
                            usbManager,
                            deviceProbe!!.usbDevice, this
                        )
                    }
                    try {
                        morphoSmart!!.open()
                        if (!morphoSmart!!.isFpReaderReady) {
                            result.error(
                                "UNAVAILABLE",
                                "No fingerprint reader attached to the system",
                                null
                            )
                        }
                        mykad = MyKad(morphoSmart)
                        try {
                            mykad!!.powerUp()
                            fp = mykad!!.fingerPrint
                            result.success("Please place your thumb on the fingerprint reader...")
                        } catch (e: CTException) {
                            throw RuntimeException(e.message)
                        }
                    } catch (e: DeviceException) {
                        throw RuntimeException("Error opening fingerprint reader: " + e.message)
                    }
                } else if (call.method == "onFingerprintVerify2") {
                    try {
                        mykad!!.powerDown()
                        val morphosmartResult = morphoSmart!!.verifyFingerprint(fp, 10.toShort())
                        if (morphosmartResult.errorCode == ILVErrorCode.ILV_OK) {
                            if (morphosmartResult.resultCode == ILVResultCode.ILVSTS_HIT) {
                                result.success("Fingerprint matches fingerprint in MyKad")
                            } else {
                                result.error(
                                    "UNAVAILABLE",
                                    "Fingerprint does not match fingerprint in MyKad",
                                    null
                                )
                            }
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_INVALID_MINUTIAE) {
                            result.error("UNAVAILABLE", "Invalid fingerprint miniature", null)
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_TIMEOUT) {
                            result.error(
                                "UNAVAILABLE",
                                "Fingerprint verification operation timed out",
                                null
                            )
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_CMDE_ABORTED) {
                            result.error(
                                "UNAVAILABLE",
                                "Fingerprint verification operation aborted",
                                null
                            )
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_MYKAD) {
                            result.error("UNAVAILABLE", "ILVERR_MYKAD", null)
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_LICENSE_REG_FAILED) {
                            result.error(
                                "UNAVAILABLE",
                                "Fingerprint SDK activation failed. Make sure tablet is connected to internet.",
                                null
                            )
                        } else if (morphosmartResult.errorCode == ILVErrorCode.ILVERR_INVALID_LICENSE) {
                            result.error(
                                "UNAVAILABLE",
                                "Fingerprint SDK activation failed due to invalid or missing license",
                                null
                            )
                        } else {
                            result.error(
                                "UNAVAILABLE",
                                "Fingerprint verification operation encountered an error",
                                null
                            )
                        }
                    } catch (e: Exception) {
                        throw RuntimeException(e.message)
                    }
                } else if (call.method == "onReadCardVerifyFp") {
                    if (morphoSmart == null) {
                        val usbManager = this.baseContext
                            .getSystemService(USB_SERVICE) as UsbManager
                        if (deviceProbe == null) {
                            throw RuntimeException("No fingerprint reader attached to the system")
                        }
                        if (deviceProbe!!.usbDevice == null) {
                            throw RuntimeException("No fingerprint reader attached to the system")
                        }
                        morphoSmart = MorphoSmart(
                            usbManager,
                            deviceProbe!!.usbDevice, this
                        )
                    }
                    try {
                        morphoSmart!!.open()
                        mykad = MyKad(morphoSmart)
                        if (!morphoSmart!!.isFpReaderReady) {
                            throw RuntimeException("No fingerprint reader attached to the system")
                        }
                        var cardHolderInfo = CardHolderInfo()
                        try {
                            mykad!!.powerUp()
                            cardHolderInfo = mykad!!.getCardHolderInfo(false, true)

//                      if (readPhoto)
//                      {
//                        cardHolderInfo.setPhoto(mykad.getPhoto());
//                      }
                            mykad!!.powerDown()
                            val lEndTime = Date().time
                            val fingerprint = ByteArray(1196)
                            System.arraycopy(
                                cardHolderInfo.fingerprint1,
                                0,
                                fingerprint,
                                0,
                                cardHolderInfo.fingerprint1.size
                            )
                            System.arraycopy(
                                cardHolderInfo.fingerprint2,
                                0,
                                fingerprint,
                                cardHolderInfo.fingerprint1.size,
                                cardHolderInfo.fingerprint2.size
                            )
                            //                      MorphoSmartResult morphosmartResult = morphosmart.verifyFingerprint(fingerprint, (short) verifyFpTimeout);
                            result.success("")
                        } catch (e: Exception) {
                            throw RuntimeException(e.message)
                        }
                    } catch (e: DeviceException) {
                        throw RuntimeException(e.message)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    companion object {
        private const val CHANNEL = "samples.flutter.dev/mykad"
    }
}
