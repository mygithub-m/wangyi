package cn.learn.utils;

import cn.learn.pojo.Album;
import cn.learn.pojo.Singer;
import cn.learn.pojo.Song;
import org.jaudiotagger.audio.exceptions.InvalidAudioFrameException;
import org.jaudiotagger.audio.exceptions.ReadOnlyFileException;
import org.jaudiotagger.audio.mp3.MP3AudioHeader;
import org.jaudiotagger.audio.mp3.MP3File;
import org.jaudiotagger.tag.FieldKey;
import org.jaudiotagger.tag.TagException;
import org.jaudiotagger.tag.id3.AbstractID3v2Frame;
import org.jaudiotagger.tag.id3.AbstractID3v2Tag;
import org.jaudiotagger.tag.id3.framebody.FrameBodyAPIC;

import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 一个用于文件操作的工具类
 */
public class FileUtil {

    private static final File SCANFILE = new File("C:\\Users\\3031874211\\Desktop\\wangyi");  //默认扫描目录
    private static final String FILEFORMAT = ".mp3";  //默认识别音乐格式

    /**
     * 获取本地音乐文件
     * @return
     */
    public static List<Song> getLocalSongs(){
        List<Song> songs = new ArrayList<Song>();
        getFileList(SCANFILE,FILEFORMAT,songs);
        return songs;
    }


    /**
     * 用于遍历参数路径下的所有满足条件的文件，并获得相关信息
     *
     * @param file
     */
    public static void getFileList(File file, final String format, List<Song> songs) {
        if (!file.exists()){
            return;
        }
        if (file.isDirectory()) {  //如果file是一个文件夹，则迭代遍历
            File[] files = file.listFiles(new FileFilter() {   //筛选出满足条件的文件
                public boolean accept(File pathname) {
                    if (pathname.isDirectory()
                            || pathname.getName().toLowerCase().endsWith(format)) {  //如果file是一个文件夹或者是指定的格式，则放进数组中
                        return true;
                    }
                    return false;
                }
            });

            for (File f : files) {  //进入迭代
                getFileList(f, format, songs);
            }

        } else {  //获取文件信息
            try {

                MP3File mp3File = new MP3File(file);
                AbstractID3v2Tag tag = mp3File.getID3v2Tag();  //用来获取歌曲的专辑名，歌手名，歌名
                String album = tag.getFirst(FieldKey.ALBUM);//专辑名
                String singer = tag.getFirst(FieldKey.ARTIST);//歌手名
                String songName = tag.getFirst(FieldKey.TITLE);//歌名

                MP3AudioHeader header = mp3File.getMP3AudioHeader();  //用来获取音乐的时长信息
                String s_length = header.getTrackLengthAsString();  //时长，格式  MM:SS
                long length = mp3File.getFile().length();   //文件大小  单位字节
                double d_length = length / 1024.0 / 1024.0;  //将文件转成MB的单位
                DecimalFormat decimalFormat = new DecimalFormat("0.0");  //将double保留一位小数，四舍五入
                String size = decimalFormat.format(d_length);  //文件大小  xx.xMB

                AbstractID3v2Frame frame = (AbstractID3v2Frame) tag.getFrame("APIC");//歌曲封面
                FrameBodyAPIC body = (FrameBodyAPIC) frame.getBody();

                byte[] imageData = body.getImageData();  //得到封面图片的字节数组

                Song song = new Song();  //将信息存进歌曲对象中
                song.setS_id(songs.size());
                song.setS_name(songName);
                Album album1 = new Album();
                album1.setA_name(album);
                Singer singer1 = new Singer();
                singer1.setSinger_name(singer);
                singer1.setSinger_image("http://localhost:8080/music_player_singer_image/head.png");
                song.setSinger(singer1);
                song.setS_length(s_length);
                song.setS_size(size);
                song.setS_path("http://localhost:8080/file/" + file.getName());

                //歌曲封面操作
                String path = null;  //封面图片存储路径
                if (imageData == null) {
                    System.out.println("读取歌曲封面失败");
                } else {
                    //将图片存起来
                    path = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_song_image\\" + song.getS_name() + ".png";
                    if (new File(path).exists()) {  //判断文件是否已经存在，如果已经存在则不用写入了

                    } else {  //生成文件
                        try {
                            FileOutputStream fos = new FileOutputStream(path);
                            System.out.println(path);
                            fos.write(imageData);
                            fos.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    album1.setA_image("http://localhost:8080/music_player_song_image/" + song.getS_name() + ".png");
                }

                song.setAlbum(album1);  //添加专辑
                songs.add(song);  //将信息存进集合中返回

            } catch (IOException e) {
                e.printStackTrace();
            } catch (TagException e) {
                e.printStackTrace();
            } catch (ReadOnlyFileException e) {
                e.printStackTrace();
            } catch (InvalidAudioFrameException e) {
                e.printStackTrace();
            }

        }
    }
}
