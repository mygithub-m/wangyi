package cn.learn.utils;

import java.util.ResourceBundle;

/**
 * 路径工具类
 */
public class PathUtils {
    public static String HEAD_PATH;
    public static String HEAD_HTTP_PATH;
    public static String SONG_LOAD_PATH;
    public static String IMAGE_FORMAT;
    public static String SONG_HTTP_LOAD_PATH;
    public static String SONG_SAVE_PATH;
    public static String LOCAL_SONG_PATH;
    public static String SONG_FORMAT;
    public static String LOCAL_SONG_PLAY_PATH;
    public static String ALBUM_SAVE_PAHT;

    static {
        ResourceBundle resource = ResourceBundle.getBundle("path");
        HEAD_PATH = resource.getString("HEAD_PATH");
        HEAD_HTTP_PATH = resource.getString("HEAD_HTTP_PATH");
        SONG_LOAD_PATH = resource.getString("SONG_LOAD_PATH");
        IMAGE_FORMAT = resource.getString("IMAGE_FORMAT");
        SONG_HTTP_LOAD_PATH = resource.getString("SONG_HTTP_LOAD_PATH");
        SONG_SAVE_PATH = resource.getString("SONG_SAVE_PATH");
        LOCAL_SONG_PATH = resource.getString("LOCAL_SONG_PATH");
        SONG_FORMAT = resource.getString("SONG_FORMAT");
        LOCAL_SONG_PLAY_PATH = resource.getString("LOCAL_SONG_PLAY_PATH");
        ALBUM_SAVE_PAHT = resource.getString("ALBUM_SAVE_PAHT");
    }
}
