#include <jni.h>
#include "opencv2/core.hpp"
#include "opencv2/imgproc.hpp"
//#include "opencv2/aruco.hpp"
#include "opencv2/videoio.hpp"
#include <vector>

using namespace cv;
using namespace std;

extern "C"
JNIEXPORT jstring JNICALL Java_monadic_1software_sampletest_MainActivity_opencv(JNIEnv* env)
{
    Mat test;
    VideoCapture camera;
    camera.open(0);
    //Ptrcv::aruco::Dictionary dict = aruco::getPredefinedDictionary(aruco::DICT_6X6_250);
    Mat marker;
    //aruco::drawMarker(dict, 25, 200, marker, 1);
    string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

int start_logger(const char *app_name);

JNIEXPORT void JNICALL Java_monadic_1software_sampletest_MainActivity_start(JNIEnv* env)
{
    start_logger("test");
}
