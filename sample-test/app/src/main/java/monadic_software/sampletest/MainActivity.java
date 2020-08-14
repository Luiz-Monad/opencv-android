package monadic_software.sampletest;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        System.loadLibrary("native-lib");
        start();
        opencv();
    }

    private native static void opencv();
    private native static void start();

}
