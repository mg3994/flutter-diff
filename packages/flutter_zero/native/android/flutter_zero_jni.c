#include <jni.h>
#include <string.h>
#include <stdlib.h>

static jlong g_jni_handle_counter = 50000;

JNIEXPORT jlong JNICALL
Java_com_flutterzero_FlutterZeroNative_nativeCreateView(JNIEnv *env, jobject thiz, jstring type, jstring props) {
    (void)env;
    (void)thiz;
    (void)type;
    (void)props;
    return ++g_jni_handle_counter;
}

JNIEXPORT void JNICALL
Java_com_flutterzero_FlutterZeroNative_nativeUpdateLayout(JNIEnv *env, jobject thiz, jlong handle, jdouble x, jdouble y, jdouble w, jdouble h) {
    (void)env;
    (void)thiz;
    (void)handle;
    (void)x;
    (void)y;
    (void)w;
    (void)h;
}

JNIEXPORT void JNICALL
Java_com_flutterzero_FlutterZeroNative_nativeDispatchEvent(JNIEnv *env, jobject thiz, jlong handle, jstring eventName, jstring dataJson) {
    (void)env;
    (void)thiz;
    (void)handle;
    (void)eventName;
    (void)dataJson;
}
