#include <jni.h>
#include <string.h>

JNIEXPORT jlong JNICALL
Java_com_flutterzero_FlutterZeroNative_nativeCreateView(JNIEnv *env, jobject thiz, jstring type, jstring props) {
    (void)env;
    (void)thiz;
    (void)type;
    (void)props;
    static jlong handle = 50000;
    return ++handle;
}

JNIEXPORT void JNICALL
Java_com_flutterzero_FlutterZeroNative_nativeUpdateLayout(JNIEnv *env, jobject thiz, jlong handle, jdouble x, jdouble y, jdouble w, jdouble h) {
    (void)env;
    (void)thiz;
    (void)handle;
    (void)x; (void)y; (void)w; (void)h;
}
