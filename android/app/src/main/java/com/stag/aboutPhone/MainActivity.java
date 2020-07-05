package com.stag.aboutPhone;

import androidx.annotation.NonNull;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String STORAGE = "com.stag.about/Storage";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor(), STORAGE).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getStorage")) {
                        Map<String, Object> storage = getStorageInfo();

                        if (storage != null) {
                            result.success(storage);
                        } else {
                            result.error("UNAVAILABLE", "Permission not granted", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    Map<String, Object> getStorageInfo() {
        //Internal
        double totalInternalSize = new File(getApplicationContext().getFilesDir().getAbsoluteFile().toString()).getTotalSpace();
        String totMb = String.valueOf(totalInternalSize / (1024 * 1024));
        double availableSize = new File(getApplicationContext().getFilesDir().getAbsoluteFile().toString()).getFreeSpace();
        String freeMb = String.valueOf(availableSize/ (1024 * 1024));

        System.out.println("Internal");
        System.out.println(totMb);
        System.out.println(freeMb);

        //External
//        long freeBytesExternal =  new File(Objects.requireNonNull(getExternalFilesDir(null)).toString()).getFreeSpace();
//        String free = String.valueOf((int) (freeBytesExternal/ (1024 * 1024)));
//        long totalExternalSize =  new File(Objects.requireNonNull(getExternalFilesDir(null)).toString()).getTotalSpace();
//        String total= String.valueOf((int) (totalExternalSize/ (1024 * 1024)));
//
//        System.out.println("External");
//        System.out.println(free);
//        System.out.println(total);

        Map<String, Object> storage = new HashMap<>();
        storage.put("TotalInternal", totMb);
        storage.put("FreeInternal", freeMb);
//        storage.put("TotalExternal", total);
//        storage.put("FreeExternal", free);

        return storage;
    }
}
