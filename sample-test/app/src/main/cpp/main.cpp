#include <jni.h>
#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/features2d/features2d.hpp"
#include <vector>

using namespace std;
using namespace cv;

extern "C"
JNIEXPORT void JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FindFeatures(JNIEnv*, jobject, jlong addrGray, jlong addrRgba)
{
    Mat& mGr  = *(Mat*)addrGray;
    Mat& mRgb = *(Mat*)addrRgba;
    vector<KeyPoint> v;

    Ptr<FeatureDetector> detector = FastFeatureDetector::create(50);
    detector->detect(mGr, v);
    for( unsigned int i = 0; i < v.size(); i++ )
    {
        const KeyPoint& kp = v[i];
        circle(mRgb, Point(kp.pt.x, kp.pt.y), 10, Scalar(255,0,0,255));
    }
}

int start_logger(const char *app_name);
void * ferns_initialize(const char * model);
bool ferns_track_and_draw(void * dt, void * addrRgba, bool show_keypoints, bool show_tracked_locations);
bool ferns_detect_and_draw(void * dt, void * addrRgba, bool show_keypoints);
bool ferns_detect_and_track_and_draw(void * dt, void * addrRgba, bool show_keypoints, bool show_tracked_locations);
void ferns_get_detected_position(void * dt, int * u, int * v);
void ferns_dispose(void * dt);

extern "C"
JNIEXPORT jlong JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsCreate(JNIEnv* env, jobject, jstring model)
{
    start_logger("Ferns");
    const char * nModel = env->GetStringUTFChars(model, 0);
    jlong ferns = (jlong)ferns_initialize(nModel);
    env->ReleaseStringUTFChars(model, nModel);
    return ferns;
}

extern "C"
JNIEXPORT bool JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsTrack(JNIEnv* env, jobject, jlong ferns, jlong addrRgba)
{
    void * dt = (void *)ferns;
    Mat * mRgba = (Mat *)addrRgba;
    return ferns_track_and_draw(dt, mRgba, false, false);
}

extern "C"
JNIEXPORT bool JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsDetectTrack(JNIEnv* env, jobject, jlong ferns, jlong addrRgba)
{
    void * dt = (void *)ferns;
    Mat * mRgba = (Mat *)addrRgba;
    return ferns_detect_and_track_and_draw(dt, mRgba, false, false);
}

extern "C"
JNIEXPORT bool JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsDetect(JNIEnv* env, jobject, jlong ferns, jlong addrRgba)
{
    void * dt = (void *)ferns;
    Mat * mRgba = (Mat *)addrRgba;
    return ferns_detect_and_draw(dt, mRgba, false);
}

extern "C"
JNIEXPORT void JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsGetDetectedPosition(JNIEnv* env, jobject, jlong ferns, jintArray u, jintArray v)
{
    jint * ju = env->GetIntArrayElements(u, 0);
    jint * jv = env->GetIntArrayElements(v, 0);
    void * dt = (void *)ferns;
    ferns_get_detected_position(dt, ju, jv);
    env->ReleaseIntArrayElements(u, ju, 0);
    env->ReleaseIntArrayElements(v, jv, 0);
}

extern "C"
JNIEXPORT void JNICALL Java_org_toca_virtualreality_viewer_ViewerActivity_FernsDispose(JNIEnv* env, jobject, jlong ferns)
{
    void * dt = (void *)ferns;
    ferns_dispose(dt);
}

/**************************************************************************************************/

#include <unistd.h>
#include <android/log.h>

static int pfd[2];
static pthread_t thr;
static const char *tag = "myapp";

static void *log_thread_func(void*);

int start_logger(const char *app_name)
{
    tag = app_name;

    /* make stdout line-buffered and stderr unbuffered */
    setvbuf(stdout, 0, _IOLBF, 0);
    setvbuf(stderr, 0, _IONBF, 0);

    /* create the pipe and redirect stdout and stderr */
    pipe(pfd);
    dup2(pfd[1], 1);
    dup2(pfd[1], 2);

    /* spawn the logging thread */
    if(pthread_create(&thr, 0, log_thread_func, 0) == -1)
        return -1;
    pthread_detach(thr);
    return 0;
}

void *log_thread_func(void*)
{
    ssize_t rdsz;
    char buf[128];
    while((rdsz = read(pfd[0], buf, sizeof buf - 1)) > 0) {
        if(buf[rdsz - 1] == '\n') --rdsz;
        buf[rdsz] = 0;  /* add null-terminator */
        __android_log_write(ANDROID_LOG_DEBUG, tag, buf);
    }
    return 0;
}

/**************************************************************************************************/