import cn.learn.controller.LoginController;
import cn.learn.dao.*;
import cn.learn.pojo.*;
import cn.learn.service.AlbumService;
import cn.learn.service.CommentsService;
import cn.learn.service.LoginService;
import cn.learn.service.PlayListService;
import cn.learn.utils.FileUtil;
import org.jaudiotagger.audio.exceptions.InvalidAudioFrameException;
import org.jaudiotagger.audio.exceptions.ReadOnlyFileException;
import org.jaudiotagger.audio.mp3.MP3AudioHeader;
import org.jaudiotagger.audio.mp3.MP3File;
import org.jaudiotagger.tag.FieldKey;
import org.jaudiotagger.tag.TagException;
import org.jaudiotagger.tag.id3.AbstractID3v2Frame;
import org.jaudiotagger.tag.id3.AbstractID3v2Tag;
import org.jaudiotagger.tag.id3.framebody.FrameBodyAPIC;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.*;

/**
 * spring整合junit
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class SpringTest {

    @Autowired
    private LoginService loginService;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private LoginController loginController;

    @Autowired
    private LoginMapper loginMapper;

    @Autowired
    @Qualifier("loginServiceImpl")
    private LoginService loginServiceImpl;

    @Autowired
    private SqlSessionFactoryBean sqlSessionFactoryBean;

    @Autowired
    private RegisterMapper registerMapper;

    @Test
    public void test01() {
        System.out.println(dataSource);
    }


    @Test
    public void test02() {
        User user = new User();
        user.setU_nickname("滑翔的人儿");
        user.setU_password("123456");

        User user1 = loginServiceImpl.userLogin(user);
        System.out.println(user1);
    }

    @Test
    public void test03() {
        System.out.println(sqlSessionFactoryBean);
    }

    @Test
    public void test04() {
        //遍历目录
        File file = new File("E:\\wangyi");
        fileList(file);
    }

    public void fileList(File file) {
        if (file.isDirectory()) {  //如果是文件夹，继续遍历

            File[] files = file.listFiles(new FileFilter() {
                public boolean accept(File pathname) {
                    if (pathname.isDirectory() || pathname.getName().toLowerCase().endsWith(".mp3")) {
                        return true;
                    }
                    return false;
                }
            });

            for (File file1 : files) {
                fileList(file1);
            }
        } else {
            try {
                MP3File mp3File = new MP3File(file);
                System.out.println(mp3File);
                AbstractID3v2Tag id3v2Tag = mp3File.getID3v2Tag();
                System.out.println(id3v2Tag);
                String album = id3v2Tag.getFirst(FieldKey.ALBUM); //专辑名
                System.out.println("专辑名：" + album);
                String artist = id3v2Tag.getFirst(FieldKey.ARTIST); //歌手名
                System.out.println("歌手名：" + artist);
                String songname = id3v2Tag.getFirst(FieldKey.TITLE);  //歌名
                System.out.println("歌名：" + songname);
                MP3AudioHeader mp3AudioHeader = mp3File.getMP3AudioHeader();
                String time = mp3AudioHeader.getTrackLengthAsString();//时长
                System.out.println("时长：" + time);
                long length = mp3File.getFile().length();
                double size = length / 1024.0 / 1024;
                DecimalFormat format = new DecimalFormat("0.00");
                String x = format.format(size);
                System.out.println(x);

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

  /*  //测试读取本地音乐文件
    @Test
    public void test05() {
        List<Song> songs = new ArrayList<Song>();
        File file = new File("E:\\wangyi");
        FileUtil.getFileList(file, ".mp3", songs);

        for (Song song : songs) {
            System.out.println(song);
        }
    }*/

    @Autowired
    private RedisTemplate redisTemplate;

    //redisTemplate测试
    @Test
    public void test06() {
        ValueOperations ops = redisTemplate.opsForValue();
        ops.set("name", "mayu");
        System.out.println(ops.get("name"));
    }

    @Autowired
    private PlayListService playListService;

    @Autowired
    private PlayListMapper playListMapper;

   /* @Test
    public void test07() {

        List<Song> all = playListService.findAll();
        for (Song song : all) {
            System.out.println(song);
        }
    }*/

    @Autowired
    private CommentsService commentsService;

    @Autowired
    private CommentsMapper commentsMapper;


    @Test
    public void test08() {
        List<Comments> bySingId = commentsMapper.findBySingId(10);
        System.out.println(bySingId);
        List<Comments> songComments = commentsService.findSongComments(10);
        System.out.println(songComments);
    }

    @Test
    public void test09() {
        List<Integer> list = new ArrayList<Integer>();
        list.add(1);
        list.add(2);
        list.add(3);
        list.add(3, 4);
        System.out.println(list);
    }


    @Test
    public void test10() {
        List<Song> songs = songMapper.searchSongs("%我%你%");
        for (Song song : songs) {
            System.out.println(song);
        }
    }

    @Autowired
    private SongListToSongMapper songListToSongMapper;

    @Test
    public void test11() {
        List<Integer> bySLId = songListToSongMapper.findBySLId(1);
        System.out.println(bySLId);
    }

    @Autowired
    private LikeSongsMapper likeSongsMapper;

    @Test
    public void test12() {
        Integer id = likeSongsMapper.findByUIdAndSId(4, 4);
        System.out.println(id);
    }

    @Autowired
    private SongListMapper songListMapper;

    @Test
    public void test13() {
        SongList songList = new SongList();
        songList.setSl_name("gushi");  //歌单名
        songList.setU_id(4);  //用户id
        songList.setSl_date(new Date()); //创建时间
        songList.setSl_playnum(0);  //播放次数,默认为0
        System.out.println(songList);
        songListMapper.saveList(songList);
    }

    @Test
    public void test14() {
        songListToSongMapper.saveSong(5, 9);
    }

    @Test
    public void test15() {
        SongList byId = songListMapper.findById(5);
        songListMapper.updatePlayNum(byId);
    }

    @Test
    public void test16() {
        SongList songList = new SongList();
        songList.setSl_name("自定义歌单");  //歌单名
        songList.setU_id(1);  //用户id
//        songList.setSl_date(new Date()); //创建时间
        songList.setSl_playnum(0);  //播放次数,默认为0
        SongList others = songListMapper.findByOthers(songList);
        System.out.println(others);
    }

    @Autowired
    private AlbumService albumService;

    @Test
    public void test17() {
//        Album album = albumService.getAlbumDetails(6);
//        System.out.println(album);
    }

    @Autowired
    private DownLoadMapper downLoadMapper;
/*    @Test
    public void test18(){
        System.out.println(111);
        DownLoad downLoad = new DownLoad();
        downLoad.setS_id(7);
        downLoad.setU_id(4);
        downLoad.setM_date(new Date());
        downLoad.setStatus(0);
        downLoadMapper.saveSong(downLoad);
    }*/

   /* @Autowired
    private ArrayList arrayList;

    @Test
    public void test19(){
        System.out.println(arrayList);
    }*/

    @Test
    public void test20(){
        List<Song> songs = FileUtil.getLocalSongs();
        for (Song song : songs) {
            System.out.println(song);
        }
    }
/*********************************************************************/
    /**
     * 下面的测试方法用来添加歌曲信息进数据库
     */

    @Autowired
    private SingerMapper singerMapper;

    //先添加歌手，包括歌手名，歌手图片
    @Test
    public void insertSinger() {
        String path = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_remote_song";
        List<File> files = new ArrayList<File>();
        mp3FileList(new File(path), ".mp3", files);

        for (File file : files) {
            try {
                Singer singer = new Singer();
                MP3File mp3File = new MP3File(file);
                AbstractID3v2Tag tag = mp3File.getID3v2Tag();  //用来获取歌曲的专辑名，歌手名，歌名
                String singer_name = tag.getFirst(FieldKey.ARTIST);//歌手名
                System.out.println(singer_name);

                if (singer_name != null) {

                    singer.setSinger_name(singer_name);
                    singer.setSinger_image("http://localhost:8080/music_player_singer_image/head.png");
                }
                Integer integer = singerMapper.insertSinger(singer);
                System.out.println(integer);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    //添加专辑信息
    @Autowired
    private AlbumMapper albumMapper;

    @Test
    public void insertAlbum() {
        String path = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_remote_song";
        List<File> files = new ArrayList<File>();
        mp3FileList(new File(path), ".mp3", files);

        for (File file : files) {
            try {
                Album album = new Album();
                MP3File mp3File = new MP3File(file);
                AbstractID3v2Tag tag = mp3File.getID3v2Tag();  //用来获取歌曲的专辑名，歌手名，歌名
                String singer_name = tag.getFirst(FieldKey.ARTIST);//歌手名

                Singer singer = singerMapper.selectBySingerName(singer_name);

                album.setS_id(singer.getSinger_id());  //添加歌手id

                String albumName = tag.getFirst(FieldKey.ALBUM);//专辑名
                album.setA_name(albumName); //添加专辑名

                AbstractID3v2Frame frame = (AbstractID3v2Frame) tag.getFrame("APIC");//歌曲封面
                FrameBodyAPIC body = (FrameBodyAPIC) frame.getBody();

                byte[] imageData = body.getImageData();  //得到封面图片的字节数组

                //歌曲封面操作
                String pathName = null;  //封面图片存储路径
                if (imageData == null) {
                    System.out.println("读取歌曲封面失败");
                } else {
                    //将图片存起来
                    pathName = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_song_image\\" + albumName + ".png";
                    if (new File(pathName).exists()) {  //判断文件是否已经存在，如果已经存在则不用写入了

                    } else {  //生成文件
                        try {
                            FileOutputStream fos = new FileOutputStream(pathName);

                            fos.write(imageData);
                            fos.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    album.setA_image("http://localhost:8080/music_player_song_image/" + albumName + ".png");
                }

                System.out.println(album);
                Integer integer = albumMapper.insertAlbum(album);


            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Autowired
    private SongMapper songMapper;

    //添加歌曲信息
    @Test
    public void insertSong() {

        String path = "E:\\Tomcat 8\\apache-tomcat-8.5.49\\webapps\\music_player_remote_song";
        List<File> files = new ArrayList<File>();
        mp3FileList(new File(path), ".mp3", files);

        for (File file : files) {
            try {
                Song song = new Song();
                MP3File mp3File = new MP3File(file);
                AbstractID3v2Tag tag = mp3File.getID3v2Tag();  //用来获取歌曲的专辑名，歌手名，歌名
                String singer_name = tag.getFirst(FieldKey.ARTIST);//歌手名

                Singer singer = singerMapper.selectBySingerName(singer_name);
                System.out.println(singer);
                song.setSinger(singer);  //添加歌手信息
                song.setSinger(singer);

                String albumName = tag.getFirst(FieldKey.ALBUM);//专辑名
                Album album = albumMapper.selectByName(albumName);  //添加专辑信息
                System.out.println(album);
                song.setAlbum(album);

                String songName = tag.getFirst(FieldKey.TITLE);//歌名
                song.setS_name(songName);

                MP3AudioHeader header = mp3File.getMP3AudioHeader();  //用来获取音乐的时长信息
                String s_length = header.getTrackLengthAsString();  //时长，格式  MM:SS
                song.setS_length(s_length);

                long length = mp3File.getFile().length();   //文件大小  单位字节
                double d_length = length / 1024.0 / 1024.0;  //将文件转成MB的单位
                DecimalFormat decimalFormat = new DecimalFormat("0.0");  //将double保留一位小数，四舍五入
                String size = decimalFormat.format(d_length);  //文件大小  xx.xMB

                song.setS_size(size);

                song.setS_path("http://localhost:8080/music_player_remote_song/" + file.getName());

                System.out.println(song);

                Integer integer = songMapper.insertSong(song);
                System.out.println(integer);


            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    //筛选出目录下的所有mp3文件
    public void mp3FileList(File file, final String format, List<File> files) {

        if (file.isDirectory()) {
            File[] listFiles = file.listFiles(new FileFilter() {
                public boolean accept(File pathname) {
                    if (pathname.isDirectory() || pathname.getName().toLowerCase().endsWith(format)) {
                        return true;
                    }
                    return false;
                }
            });
            for (File listFile : listFiles) {
                mp3FileList(listFile, format, files);
            }

        } else {
            files.add(file);
        }
    }

    //将所有的mp3文件封装为MP3File对象
//    public MP3File
}
